import { routes } from '../../helpers/routes'
import { authenticate } from './authentication'
import axios from 'axios'

const passKey: any = process.env.PASS_KEY
const shortCode: any = process.env.SHORT_CODE

export async function lipaNaMpesa(phone: number, amount: number) {
    const timestamp = new Date().toISOString().replace(/[^0-9]/g, "").slice(0, -3)
    const password = Buffer.from(shortCode + passKey + timestamp).toString("base64")

    try {
        const token = await authenticate()
        await axios({
            method: "POST",
            url: routes.production + routes.stkpush,
            headers: {
              Authorization: "Bearer " + token,
            },
            data: {
                BusinessShortCode: shortCode,
                Password: password,
                Timestamp: timestamp,
                TransactionType: "CustomerPayBillOnline",
                Amount: amount,
                PartyA: phone,
                PartyB: shortCode,
                PhoneNumber: phone,
                CallBackURL: "https://us-central1-property-moha.cloudfunctions.net/mpesaMain/api/v1/nitumiekakitu/s649wpar3mdy",
                AccountReference: phone,
                TransactionDesc: "Landlord fee"
            }
        })
    } catch (error) {
        console.error(error)
    }
}