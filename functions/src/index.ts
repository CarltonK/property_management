import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
//Initialize the firebase app
admin.initializeApp()
//Define messaging
const fcm = admin.messaging()
const db = admin.firestore()

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

// export const delete3dayOldComplaint = functions.firestore
//     .document('complaints/{complaint}')
//     .onUpdate(async snapshot => {
//         //Check if issue has been fixed
//         if (snapshot.after.get('fixed') == true) {
//             //Get the time now
//             const now = Date.now();
//             const fixedDate = snapshot.after.get('fixedDate');
//             const difference = now - fixedDate;
//             //Delete the doc if the days are greater than 3
//             if (difference > 3) {
//                 const docId = snapshot.after.id;
//                 db.collection('complaints').doc(docId).delete;
//             }
//         }
//     })
