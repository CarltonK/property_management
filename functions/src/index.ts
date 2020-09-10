import * as admin from 'firebase-admin'

//Initialize the firebase app
admin.initializeApp()

import * as functions from 'firebase-functions'
import * as analytics from './analytics_channel'
import * as reports from './reports'

//Define messaging
const fcm = admin.messaging()
export const db = admin.firestore()

//Custom Analytics
/*
COMMENT IF PRICE IS TOO HIGH
*/
export const adminpaymentTracker = analytics.paymentTracker
export const admincomplaintTracker = analytics.complaintTracker
export const adminlandlordTracker = analytics.landlordTracker
export const admintenantTracker = analytics.tenantTracker
export const adminlistingTracker = analytics.listingTracker
export const adminvacationTracker = analytics.vacationTracker

//Payment Reports
export const paymentReportGenerator = reports.paymentReportGenerator
// export const reportAccesser  = reports.reportAccesser

export const sendAnnouncement = functions.firestore
    .document('apartments/{code}/announcements/{doc}')
    .onCreate(async snapshot => {
        //Define the payload
        const payload = {
            notification: {
                title: 'New Message',
                body: `${snapshot.get('message')}`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        }
        console.log(payload);
        //Send to all tenants in the topic "landlord_code"
        return fcm.sendToTopic(snapshot.get('code'), payload)
        .catch(error => {
            console.error('sendAnnouncement FCM Error',error)
        })
    })

export const sendPaymentNotice = functions.firestore
    .document('payments/{code}/received/{doc}')
    .onCreate(async snapshot => {
        //Define the payload
        const name = snapshot.get('fullName')
        const payload = {
            notification: {
                title: 'Payment approval',
                body: `You have received a new payment approval request from ${name}`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        }
        console.log(payload);
        //Send to all managers in the topic "landlord_code + 'Managers'"
        const topic = snapshot.get('code') + "Manager"
        return fcm.sendToTopic(topic,payload)
        .catch(error => {
            console.error('sendPaymentNotice FCM Error',error)
        })
    })

// export const changePaymentStatus = functions.firestore
//     .document('apartments/{code}/floors/{floor}/tenants/{tenant}')
//     .onWrite(async snapshot => {
//         //Get the current system date
//         const now: Date = new Date()
//         console.log(`System Date ${now}`)
//         if (now.getDate() > 24 && now.getDate() <= 31) {
//             //Get document ID
//             const docId = snapshot.before.id
//             console.log(`Document ID ${docId}`)
//             await db.doc(`apartments/{code}/floors/{floor}/tenants/${docId}`).update({"paid":false})
//         } 
//     })

export const delete3dayOldComplaint = functions.firestore
    .document('complaints/{complaint}')
    .onUpdate(async snapshot => {
        //Check if issue has been fixed
        if (snapshot.after.get('fixed') === true) {
            //Get the date now
            const now: Date = new Date()
            //Get the date in the document
            const fixedDate = snapshot.after.get('fixedDate');
            // console.log(`System Date ${now}`)
            // console.log(`Document Date ${fixedDate.toDate()}`)
            //Convert firebase timestamp to Date object
            const timeStampAsDate = fixedDate.toDate()
            //Get the difference between the two dates
            const diff = Number(now) - Number(timeStampAsDate);
            // console.log(`Difference Date ${diff}`)
            const threeDaysInNumber: number = 259200
            if (diff > threeDaysInNumber) {
                //Get document ID
                const docId = snapshot.before.id
                console.log(`Document ID ${docId}`)
                await db.collection('complaints').doc(docId).delete()
            }
        }
    })
