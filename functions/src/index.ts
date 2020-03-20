import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

//Initialize the firebase app
admin.initializeApp()
//Define messaging
const fcm = admin.messaging()

export const sendAnnouncement = functions.firestore
    .document('apartments/{code}/announcements/{doc}')
    .onCreate(async snapshot => {
        console.log(`Snapshot:\n${snapshot.data}`)
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
            console.error('FCM Error',error)
        })
    })

    // export const sendPaymentRequest = functions.firestore
    //     .document('payments/{code}/received/{doc}')
    //     .onCreate(async snapshot => {
    //         //Define the payload
    //         const payload = {
    //             notification: {
    //                 title: 'Payment Request',
    //                 body: `${snapshot.get('fullName')} wants to pay via ${snapshot.get('mode')}`,
    //                 clickAction: 'FLUTTER_NOTIFICATION_CLICK'
    //             }
    //         }
    //         console.log(payload);
    //     });
