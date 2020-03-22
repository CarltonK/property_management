export interface credentialsinterface {
    client_key: "HMcwXeBfAIQQBYWyVPPWHpkqACA6DH5X";
    client_secret: "p70GXLhb87GoW5Tw";
    initiator_password: string;
    certificate_path?: string | null;
}

export interface transactionstatusinterface {
    Initiator: string;
    TransactionID: string;
    PartyA: string;
    IdentifierType: any;
    ResultURL: string;
    QueueTimeOutURL: string;
    CommandID?: string;
    Remarks?: string;
    Occasion?: string;
}

export interface stkpushinterface {
    BusinessShortCode: number;
    Amount: number;
    PartyA: string;
    PartyB: string;
    PhoneNumber: string;
    CallBackURL: string;
    AccountReference: string;
    passKey: any;
    TransactionType?: "CustomerPayBillOnline";
    TransactionDesc?: string;
}

export interface stkqueryinterface {
    BusinessShortCode: number;
    CheckoutRequestID: string;
    passKey: any;
}