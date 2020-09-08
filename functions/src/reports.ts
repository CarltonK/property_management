import * as functions from 'firebase-functions'
import {firestore, storage} from 'firebase-admin'
import {join} from 'path'
import {tmpdir} from 'os'
import {outputFile} from 'fs-extra'
import {Parser} from 'json2csv'
import { ObjectMetadata } from 'firebase-functions/lib/providers/storage'

const db = firestore()
const bucketId: string = 'property-moha.appspot.com'
const store = storage().bucket(bucketId)

export const paymentReportGenerator = functions.firestore
    .document('reports/{report}')
    .onCreate(async snapshot => {
        const code: number = snapshot.get('code')
        const start: FirebaseFirestore.Timestamp = snapshot.get('start')
        const end: FirebaseFirestore.Timestamp = snapshot.get('end')
        const codeStr: string = code.toString()

        //Set Main Variables
        const reportId = snapshot.id
        const fileName = `reports/${reportId}.csv`
        const tempFilePath = join(tmpdir(), fileName) 
        const reportRef = db.collection('reports').doc(reportId)

        //Set CSV File Options
        const fields = ['amount','date','fullName','phone','natId','mode']
        const opts = { fields }

        try {
            //Query Collection
            return db.collection('payments').doc(codeStr).collection('received')
                .where('date','>=',start)
                .where('date','<=',end)
                .get()
                .then(querySnapshot => {
                    //Creates CSV file
                    const data: any[] = []
                    querySnapshot.forEach((doc: FirebaseFirestore.DocumentSnapshot) => {
                        data.push(doc.data())
                    })
                    return new Parser(opts).parse(data)
                })
                .then(csv => {
                    //Write the file to cloud function temporary storage
                    return outputFile(tempFilePath, csv)
                })
                .then(() => {
                    //Upload to Cloud Storage
                    return store.upload(tempFilePath, {destination: fileName})
                })
                .then((file) => {
                    //Update report status
                    return reportRef.update({status: 'complete'})
                })
        } 
        catch (error) {
            return `Report Error: ${error}`
        }
    })


export const reportAccesser = functions.storage
    .bucket(bucketId)
    .object()
    .onFinalize(async (object: ObjectMetadata) => {
        const content: string | undefined = object.contentType
        if (content !== null && content?.includes('/csv')) {
            const name: string | undefined = object.name
            if (name !== null && name?.includes('reports')) {
                const csvName: string = name.split('/')[1]
                const reportId: string =  csvName.split('.')[0]
                const link: string | undefined = object.selfLink
                const docRef = db.collection('reports').doc(reportId)
                try {
                    await docRef.update({
                        url: link
                    })
                } catch (error) {
                    throw error
                }
            }
        }
    })