import {singleNotificationSend} from './notifications'
import * as functions from 'firebase-functions'

export const serviceRequest = functions.firestore
    .document('service_requests/{request}')
    .onCreate(async (snapshot) => {
        // const by: string = snapshot.get('by')
        // const to: string = snapshot.get('to')
        const toToken: string = snapshot.get('toToken')

        if (toToken !== null) {
            try {
                await singleNotificationSend(toToken,'You have received a new request','Knock Knock')
            } catch (error) {
                throw error
            }
        }
    })