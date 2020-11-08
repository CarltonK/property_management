import {singleNotificationSend} from './notifications'
import * as functions from 'firebase-functions'
import { db } from './index'

export const serviceRequest = functions.firestore
    .document('service_requests/{request}')
    .onCreate(async (snapshot) => {
        const by: string = snapshot.get('by')
        // const to: string = snapshot.get('to')
        const toToken: string = snapshot.get('toToken')

        if (toToken !== null) {
            try {
                await db.collection('users').doc(by).update({isPremium: false})
                functions.logger.info(`${by} has been downgraded from premium`, {structuredData: true})
                await singleNotificationSend(toToken,'You have received a new request','Knock Knock')
                const phone: string | null = await getPhone(by)
                if (typeof(phone) === 'string') {
                    await db.collection('service_requests').doc(snapshot.id).update({
                        byPhone: phone
                    })
                }
            } catch (error) {
                console.error(error)
            }
        }
    })

async function getPhone(uid: string): Promise<string | null> {
    try {
        const doc = await db.collection('users').doc(uid).get()
        const phone: string = doc.get('phone')
        return phone
    } catch (error) {
        return null
    }
}