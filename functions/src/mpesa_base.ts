import * as functions from 'firebase-functions'
import { Request, Response } from "express"
import {PayAdminDocModel} from './models/pay_admin_doc_model'
import { lipaNaMpesaService, lipaNaMpesaLandlord } from './payments/mpesa/stk_push'
import { StkResponse } from './models/stk_response'
import { db } from './index'

export const payAdminSecure = functions.firestore
    .document('payments/Admin/remittances/{doc}')
    .onCreate(async snapshot => {
        try {
            const model: PayAdminDocModel = snapshot.data() as PayAdminDocModel
            const phone: number = Number("254" + model.phone.slice(1))
            //TODO change to actual amount
            const amount = 5
            await lipaNaMpesaLandlord(phone, amount)
        } catch (error) {
            console.error(error)
        }
    })

export const payServiceCharge = functions.firestore
    .document('payments/Admin/serviceremittances/{doc}')
    .onCreate(async snapshot => {
        try {
            const model: PayAdminDocModel = snapshot.data() as PayAdminDocModel
            const phone: number = Number("254" + model.phone.slice(1))
            //TODO change to actual amount
            const amount = 5
            await lipaNaMpesaService(phone, amount)
        } catch (error) {
            console.error(error)
        }
    })

export function mpesaLnmCallbackForPayAdminLandlord(request: Request, response: Response) {
    try {
        console.log('---Received Safaricom M-PESA Webhook For Pay Landlord Fees---')
        const serverRequest = request.body
        const stkResponse: StkResponse = serverRequest as StkResponse
        const code: number = stkResponse.Body.stkCallback.ResultCode
        if (code === 0) {
            const transactionAmount: number = stkResponse.Body.stkCallback.CallbackMetadata.Item[0].Value
            const transactionCode: string = stkResponse.Body.stkCallback.CallbackMetadata.Item[1].Value
            const transactionPhone: number = stkResponse.Body.stkCallback.CallbackMetadata.Item[4].Value
            console.log(`${transactionAmount} KES was received from ${transactionPhone} under ${transactionCode}`)

        }
        //Send a Response back to Safaricom
        const message = {
            "ResponseCode": "00000000",
	        "ResponseDesc": "success"
        }
        response.json(message)
    } catch (error) {
        functions.logger.error(error, {structuredData: true})
    }
}

export function mpesaLnmCallbackForPayAdminService(request: Request, response: Response) {
    try {
        console.log('---Received Safaricom M-PESA Webhook For Pay Service Charge---')
        const serverRequest = request.body
        const stkResponse: StkResponse = serverRequest as StkResponse
        const code: number = stkResponse.Body.stkCallback.ResultCode
        if (code === 0) {
            const transactionAmount: number = stkResponse.Body.stkCallback.CallbackMetadata.Item[0].Value
            const transactionCode: string = stkResponse.Body.stkCallback.CallbackMetadata.Item[1].Value
            const transactionPhone: number = stkResponse.Body.stkCallback.CallbackMetadata.Item[4].Value
            console.log(`${transactionAmount} KES was received from ${transactionPhone} under ${transactionCode}`)

            let transactionPhoneFormatted: string = transactionPhone.toString().slice(3)
            transactionPhoneFormatted = "0" + transactionPhoneFormatted

            db.collection('users').where('phone','==', transactionPhoneFormatted).limit(1).get()
                .then(async (doc) => {
                    if (doc.docs.length === 1) {
                        const uid: string = doc.docs[0].id
                        try {
                            await db.collection('users').doc(uid).update({isPremium: true})
                            functions.logger.info(`${uid} has been upgraded to premium`, {structuredData: true})
                        } catch (error) {
                            functions.logger.error(error, {structuredData: true})
                        }
                    } else {
                        functions.logger.info(`More than one user with the number ${transactionPhoneFormatted} exists`, {structuredData: true})
                    }
                })
                .catch(error => {
                    functions.logger.error(error, {structuredData: true})
                })
        }
        //Send a Response back to Safaricom
        const message = {
            "ResponseCode": "00000000",
	        "ResponseDesc": "success"
        }
        response.json(message)
    } catch (error) {
        functions.logger.error(error, {structuredData: true})
    }
}