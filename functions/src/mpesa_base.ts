// import {db} from './index'
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
            const amount = 10
            await lipaNaMpesa(phone, amount)
        } catch (error) {
            console.error(error)
        }
    })

export function mpesaLnmCallbackForPayAdmin(request: Request, response: Response) {
    try {
        console.log('---Received Safaricom M-PESA Webhook For Pay Admin---')
        const serverRequest = request.body
        console.log(serverRequest)
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