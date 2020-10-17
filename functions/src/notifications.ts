import * as superadmin from 'firebase-admin'

const fcm = superadmin.messaging()

export async function singleNotificationSend(token: string, message: string, title: string): Promise<void> {
    const payload = {
        notification: {
            title: title,
            body: message,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        }
    }
    try {
        await fcm.sendToDevice(token, payload)
        console.log('The notification has been sent')
    } catch (error) {
        console.error('Error: ', error)
    }
}