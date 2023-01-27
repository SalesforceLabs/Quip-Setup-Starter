import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import isQuipAuthOkay from '@salesforce/apex/QuipSetupHandler.isQuipAuthOkay';
import checkMetadataApiAccess from '@salesforce/apex/QuipSetupHandler.checkMetadataApiAccess';
import checkPermissionSet from '@salesforce/apex/QuipSetupHandler.checkPermissionSet';
import checkNoApexTriggers from '@salesforce/apex/QuipSetupHandler.checkNoApexTriggers';

export default class WrapperComponent extends LightningElement {
    headings = [
        {
            label: 'Check Your Connection',
            key: 'check-your-connection'
        },
        {
            label: 'Embed Documents in Salesforce',
            key: 'embed-docs'
        },
        {
            label: 'Set Up Automation',
            key: 'automation-setup'
        // },
        // {
        //     label: 'Keep Learning at Quip EDU',
        //     key: 'keep-learning'
        }
    ];

    sections = [
        {
            label: 'Connect Quip Checklist',
            key: 'check-connections',
            heading: 'check-your-connection'
        },
        {
            label: 'Add Account Plan',
            key: 'account-plan',
            heading: 'embed-docs'
        },
        {
            label: 'Add Opportunity Notes',
            key: 'opp-notes',
            heading: 'embed-docs'
        },
        {
            label: 'Add Custom Quip Document',
            key: 'custom-process',
            heading: 'embed-docs'
        },
        {
            label: 'Move Documents to Folders',
            key: 'auto-folders',
            heading: 'automation-setup'
        },
        {
            label: 'Send Document Notifications',
            key: 'auto-notifications',
            heading: 'automation-setup'
        },
        {
            label: 'Set Up Live Data Feed',
            key: 'live-feed',
            heading: 'automation-setup'
        // },
        // {
        //     label: 'Virtual Trainings',
        //     key: 'virtual-trainings',
        //     heading: 'keep-learning',
        //     link: 'https://www.quipsupport.com/hc/en-us/articles/360024757451-Register-for-a-virtual-training-'
        // },
        // {
        //     label: 'Admin Quick Start Guide',
        //     key: 'admin-quick-start-guide',
        //     heading: 'keep-learning',
        //     link: 'https://quip.com/5d8cAIPwe8UJ'
        // },
        // {
        //     label: 'Contact Support',
        //     key: 'contact-support',
        //     heading: 'keep-learning',
        //     link: '/HelpAndTrainingDoor'
        }
    ];

    selectedSection = null;

    quipAuthStatus = null;
    quipAuthProviderOkay = null;

    hasMetadataApi = false;
    hasPermissionSetExists = false;
    hasPermissionSetAssigned = false;

    hasNoApexTriggers = null;

    loadingChecks = true;

    get isError() {
        return !this.isLoadingChecks && (!this.hasMetadataApi || !this.hasPermissionSetExists || !this.hasPermissionSetAssigned || !this.hasNoApexTriggers);
    }

    get quipAuthChecked() {
        return this.quipAuthStatus !== null && this.quipAuthStatus !== undefined;
    }

    runPreflightChecks() {
        this.loadingChecks = true;
        this.checkMetadataApi()
            .then(() => this.checkPermSet())
            .then(() => this.checkQuipAuth())
            .then(() => this.checkApexTriggers())
            .then(() => {
                this.loadingChecks = false;
            });
    }

    checkMetadataApi() {
        return checkMetadataApiAccess()
            .then(result => {
                if (result) {
                    this.hasMetadataApi = true;
                } else {
                    this.hasMetadataApi = false;
                }
            })
            .catch(error => {
                this.showNotification('An Error Occurred', 'We couldn\'t check your access to Metadata API. Try again later.', 'error');
            });
    }

    checkPermSet() {
        return checkPermissionSet()
            .then(result => {
                this.hasPermissionSetExists = result.exists;
                this.hasPermissionSetAssigned = result.assigned;
            })
            .catch(error => {
                this.showNotification('An Error Occurred', 'We couldn\'t check your Quip Permission Set. Try again later.', 'error');
            });
    }
    
    checkApexTriggers() {
        return checkNoApexTriggers()
            .then(result => {
                this.hasNoApexTriggers = result;
            })
            .catch(error => {
                this.showNotification('An Error Occurred', 'We couldn\'t check your Apex Triggers. Try again later.', 'error');
            });
    }

    checkQuipAuth() {
        return isQuipAuthOkay()
            .then(data => {
                this.quipAuthProviderOkay = true;
                this.quipAuthStatus = data.valid;
                if (this.quipAuthStatus && !data.viewed) {
                    this.showNotification('Connection Successful', 'Great work! You are now ready to set up Quip.', 'success');
                }
            })
            .catch(error => {
                this.quipAuthProviderOkay = false;
                this.quipAuthStatus = false;
            });
    }

    handleSelectSection(event) {
        let section = this.sections.find(s => s.key === event.detail);

        if (!section.link) {
            this.selectedSection = event.detail;
        } else {
            window.open(section.link, '_blank');
        }
    }

    handleFinish() {
        this.selectedSection = null;
    }

    get isAccountPlanSection() {
        return this.selectedSection === 'account-plan';
    }
    
    get isByopSection() {
        return this.selectedSection === 'custom-process';
    }

    get isCheckConnectionsSection() {
        return this.selectedSection === 'check-connections';
    }

    get isOppNotesSection() {
        return this.selectedSection === 'opp-notes';
    }

    get isAutoFoldersSection() {
        return this.selectedSection === 'auto-folders';
    }

    get isAutoNotificationsSection() {
        return this.selectedSection === 'auto-notifications';
    }

    get isLiveFeedSection() {
        return this.selectedSection === 'live-feed';
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: variant === 'error' ? 'sticky' : 'dismissable'
        });
        this.dispatchEvent(evt);
    };

    connectedCallback() {
        this.runPreflightChecks();
    }
}