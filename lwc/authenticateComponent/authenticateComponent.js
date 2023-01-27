import { LightningElement, api } from 'lwc';

export default class AuthenticateComponent extends LightningElement {

    @api authProvider;

    hasAttemptedAuthentication = false;

    handleAuthenticate() {
        this.hasAttemptedAuthentication = true;
        window.open('/services/auth/oauth/Quip', '_blank');
    }

    handleVerify() {
        location.reload();
    }

    handleSetup() {
        location.href = '/lightning/setup/QuipSetupAssistant/home';
    }

}