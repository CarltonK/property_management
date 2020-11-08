import * as functions from 'firebase-functions'
import { Request, Response } from "express"
import {PayAdminDocModel} from './models/pay_admin_doc_model'
import { lipaNaMpesa } from './payments/mpesa/stk_push'

export const payAdminSecure = functions.firestore
    .document('payments/Admin/remittances/{doc}')
    .onUpdate(async snapshot => {
        try {
            const model: PayAdminDocModel = snapshot.after.data() as PayAdminDocModel
            const phone: number = Number("254" + model.phone.slice(1))
            //TODO change to actual amount
            const amount = 5
            await lipaNaMpesa(phone, amount)
        } catch (error) {
            console.error(error)
        }
    })

export function mpesaLnmCallbackForPayAdmin(request: Request, response: Response) {
    try {
        console.log('---Received Safaricom M-PESA Webhook For Pay Admin---')
        const serverRequest = request.body

        console.log(typeof(serverRequest))
        functions.logger.info(serverRequest, {structuredData: true});

        const code: number = serverRequest['Body']['stkCallback']['ResultCode']
        if (code === 0) {
            const transactionAmount: number = serverRequest['Body']['stkCallback']['CallbackMetadata']['Item'][0]['Value']
            const transactionCode: string = serverRequest['Body']['stkCallback']['CallbackMetadata']['Item'][1]['Value']
            const transactionPhone: number = serverRequest['Body']['stkCallback']['CallbackMetadata']['Item'][4]['Value']
            console.log(`${transactionAmount} KES was received from ${transactionPhone} under ${transactionCode}`)
        }
        //Send a Response back to Safaricom
        const message = {
            "ResponseCode": "00000000",
	        "ResponseDesc": "success"
        }
        response.json(message)
    } catch (error) {
        console.error(error)
    }
}