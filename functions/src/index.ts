import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
// import axios from "axios";

//Initialize the firebase app
admin.initializeApp()
//Define messaging
const fcm = admin.messaging()

export const sendAnnouncement = functions.firestore
    .document('apartments/{code}/announcements/{doc}')
    .onCreate(async snapshot => {
        console.log(`Snapshot:\n${snapshot.data()}`)
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

// export const paymentProcessUpdater = functions.firestore
//     .document('/payments/{payment}/received/{doc}')
//     .onUpdate(async snapshot => {
//         console.log(`Snapshot:\n${snapshot.after.data()}`)
//         //Define the payload
//         const payload = {
//             notification: {
//                 title: 'Payment status',
//                 body: 'Your M-PESA payment has been approved',
//                 clickAction: 'FLUTTER_NOTIFICATION_CLICK'
//             }
//         }
//         console.log(payload);
//         return fcm.sendToTopic(snapshot.after.get('code'), payload)
//         .catch(error => {
//             console.error('paymentProcessUpdater FCM Error',error)
//         })
//     })

// export const paymentProcessHandler = functions.firestore
//     .document('/payments/{payment}/received/{doc}')
//     .onCreate(async snapshot => {
//         console.log(`Snapshot:\n${snapshot}`)
//         const mode = snapshot.get('mode')
//         if (mode == "M-PESA") {
//             // var amt = snapshot.get('amount')
//             // var uid = snapshot.get('uid')
//             // var phone = snapshot.get('phone')
//             const consumer_key:string = "HMcwXeBfAIQQBYWyVPPWHpkqACA6DH5X"
//             const consumer_secret:string = "p70GXLhb87GoW5Tw"
//             const apiurl = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
//             const auth = "Basic " + new Buffer(consumer_key + ":" + consumer_secret).toString("base64");

//             requests({
//                 url: apiurl,
//                 headers: {
//                     "Authorization": auth
//                 }
//             },
//             function(error, response, body) {
//                 if (response.statusCode == 200) {
//                     const token = response.body["access_token"]
//                     console.log(`Token: ${token}`)
//                 }
//                 else {
//                     console.error(error)
//                 }
//             }
//             )
//         }
//     })
