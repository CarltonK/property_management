interface Body {
    stkCallback: StkCallback;
}

interface StkCallback {
    MerchantRequestID: string;
    CheckoutRequestID: string;
    ResultCode: number;
    ResultDesc: string;
    CallbackMetadata: CallbackMetadata;
}

interface CallbackMetadata {
    Item: Item[];
}

interface Item {
    Name: string;
    Value: any;
}

export interface StkResponse {
    Body: Body
}