import * as functions from 'firebase-functions'
import {db} from './index'

// const bucketId: string = 'property-moha.appspot.com'

export const paymentReportGenerator = functions.firestore
    .document('reports/{report}')
    .onCreate(async (snapshot) => {
        const code: number = snapshot.get('code')
        const start: FirebaseFirestore.Timestamp = snapshot.get('start')
        const end: FirebaseFirestore.Timestamp = snapshot.get('end')
        const codeStr: string = code.toString()
        const uid: string = snapshot.get('uid')

        const join = (await import('path')).join
        const tmpdir = (await import('os')).tmpdir()

        //Set Main Variables
        const reportId = snapshot.id
        const fileName = `reports/${reportId}.csv`
        const tempFilePath = join(tmpdir, fileName) 
        const reportRef = db.collection('reports').doc(reportId)

        //Attachment
        let attachment: any

        try {
            //Query Collection
            return db.collection('payments').doc(codeStr).collection('received')
                .where('date','>=',start)
                .where('date','<=',end)
                .get()
                .then(async querySnapshot => {
                    //Creates CSV file
                    const data: any[] = []
                    querySnapshot.forEach((doc: FirebaseFirestore.DocumentSnapshot) => {
                        data.push(doc.data())
                    })

                    //Set CSV File Options
                    const fields = ['amount','fullName','phone','natId','mode']
                    const opts = { fields }

                    const parser = (await import('json2csv')).Parser
                    return new parser(opts).parse(data)
                })
                .then(async (csv: any) => {
                    const outputFile = (await import('fs-extra')).outputFile
                    //Write the file to cloud function temporary storage
                    return outputFile(tempFilePath, csv)
                })
                .then(async () => {
                    const readSync = (await import('fs')).readFileSync
                    attachment = readSync(tempFilePath).toString('base64')
                    //Send Email
                    //First Get Email
                    return db.collection('users').doc(uid).get()
                })
                .then(async doc => {
                    //Define SendGrid
                    const sgMail = (await import('@sendgrid/mail'))
                    const sgKey: any = (process.env.SENDGRID_API_KEY)
                    sgMail.setApiKey(sgKey)

                    //Message
                    const requesterEmail: string = doc.get('email')
                    const apartment = doc.get('apartment_name')
                    const msg: any = {
                        to: (requesterEmail === 'mcarlton33@gmail.com') ? 'easyshopke@gmail.com' : requesterEmail,
                        from: 'mcarlton33@gmail.com',
                        subject: `${apartment} Payment Report`,
                        text: `This report was requested by ${requesterEmail}`,
                        attachments: [
                            {
                                filename: 'report.csv',
                                type: "application/csv",
                                content: attachment,
                                disposition: "attachment"
                            },
                        ]
                    }
                    return sgMail.send(msg)
                })
                .then((value) => {
                    //Update report status
                    return reportRef.update({status: 'complete'})
                })
                .then(() => {
                    console.log('The report has been sent to the user')
                })
        } 
        catch (error) {
            return `Report Error: ${error}`
        }
    })


// export const reportAccesser = functions.storage
//     .bucket(bucketId)
//     .object()
//     .onFinalize(async (object) => {
//         const content: string | undefined = object.contentType
//         if (content !== null && content?.includes('/csv')) {
//             const name: string | undefined = object.name
//             if (name !== null && name?.includes('reports')) {
//                 const csvName: string = name.split('/')[1]
//                 const reportId: string =  csvName.split('.')[0]
//                 const link: string | undefined = object.selfLink
//                 const docRef = db.collection('reports').doc(reportId)
//                 try {
//                     await docRef.update({
//                         url: link
//                     })
//                 } catch (error) {
//                     throw error
//                 }
//             }
//         }
//     })