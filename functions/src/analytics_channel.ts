import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

const db = admin.firestore()
const docID: string = 'Qcm7O4YJlhJe4TIFbw8n'
const doc: FirebaseFirestore.DocumentReference = db.collection('analytics').doc(docID)

export const paymentTracker = functions.firestore
    .document('payments/{code}/received/{doc}')
    .onCreate(async snapshot => {
        const amount: number = snapshot.get('amount')
        if (amount === null || typeof(amount) === "string") {
            return {status: 400, detail: 'The amount should be a valid integer'}
        }
        return doc.update({
            amount: admin.firestore.FieldValue.increment(amount),
            payments: admin.firestore.FieldValue.increment(1)
        })
    })

export const complaintTracker = functions.firestore
    .document('complaints/{doc}')
    .onCreate(async snapshot => {
        return doc.update({
            complaints: admin.firestore.FieldValue.increment(1)
        })
    })


export const landlordTracker = functions.firestore
    .document('landlords/{doc}')
    .onCreate(async snapshot => {
        return doc.update({
            landlords: admin.firestore.FieldValue.increment(1)
        })
    })

export const tenantTracker = functions.firestore
    .document('tenants/{doc}')
    .onCreate(async snapshot => {
        return doc.update({
            tenants: admin.firestore.FieldValue.increment(1)
        })
    })

export const listingTracker = functions.firestore
    .document('listings/{doc}')
    .onCreate(async snapshot => {
        return doc.update({
            listings: admin.firestore.FieldValue.increment(1)
        })
    })

export const vacationTracker = functions.firestore
    .document('vacations/{doc}')
    .onCreate(async snapshot => {
        return doc.update({
            vacations: admin.firestore.FieldValue.increment(1)
        })
    })