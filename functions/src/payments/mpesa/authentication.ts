import * as functions from 'firebase-functions'
import {SecretManagerServiceClient} from '@google-cloud/secret-manager'

// Instantiate the Secret Manager
const client = new SecretManagerServiceClient()

// Retrieve the secret
const retrieveSecrets = async (version: string) => {
    const [ consumerKey ] = await client.accessSecretVersion({
        name: version.
    })
    return {}
}