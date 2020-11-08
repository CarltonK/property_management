declare module namespace {

    export interface Item {
        Name: string;
        Value: any;
    }

    export interface CallbackMetadata {
        Item: Item[];
    }

    export interface StkCallback {
        MerchantRequestID: string;
        CheckoutRequestID: string;
        ResultCode: number;
        ResultDesc: string;
        CallbackMetadata: CallbackMetadata;
    }

    export interface Body {
        stkCallback: StkCallback;
    }

    export interface RootObject {
        Body: Body;
    }

}

