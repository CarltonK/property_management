import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

const db = admin.firestore()
const docID: string = 'Qcm7O4YJlhJe4TIFbw8n'
const doc: FirebaseFirestore.DocumentReference = db.collection('analytics').doc(docID)

export const paymentTracker = functions.firestore
    .document('payments/{code}/received/{doc}')
    .onCreate(async snapshot => {
        try {
            const amount: number = snapshot.get('amount')
            await doc.update({
                amount: admin.firestore.FieldValue.increment(amount),
                payments: admin.firestore.FieldValue.increment(1)
            })
        } catch (error) {
            throw error
        }
    })

export const complaintTracker = functions.firestore
    .document('complaints/{doc}')
    .onCreate(async snapshot => {
        try {
            await doc.update({
                complaints: admin.firestore.FieldValue.increment(1)
            })
        } catch (error) {
            throw error
        }
    })


export const landlordTracker = functions.firestore
    .document('landlords/{doc}')
    .onCreate(async snapshot => {
        try {
            await doc.update({
                landlords: admin.firestore.FieldValue.increment(1)
            })
        } catch (error) {
            throw error
        }
    })

export const tenantTracker = functions.firestore
    .document('tenants/{doc}')
    .onCreate(async snapshot => {
        try {
            await doc.update({
                tenants: admin.firestore.FieldValue.increment(1)
            })
        } catch (error) {
            throw error
        }
    })

export const listingTracker = functions.firestore
    .document('listings/{doc}')
    .onCreate(async snapshot => {
        try {
            await doc.update({
                listings: admin.firestore.FieldValue.increment(1)
            })
        } catch (error) {
            throw error
        }
    })

export const vacationTracker = functions.firestore
    .document('vacations/{doc}')
    .onCreate(async snapshot => {
        try {
            await doc.update({
                vacations: admin.firestore.FieldValue.increment(1)
            })
        } catch (error) {
            throw error
        }
    })