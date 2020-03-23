import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
//Initialize the firebase app
admin.initializeApp()
//Define messaging
const fcm = admin.messaging()

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
