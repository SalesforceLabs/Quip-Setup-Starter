import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOrgObjects from '@salesforce/apex/Utils.getOrgObjects';
import getRecordPages from '@salesforce/apex/Utils.getRecordPages';
import checkIfFieldExists from '@salesforce/apex/Utils.checkIfFieldExists';
import checkIfPageExists from '@salesforce/apex/ByopHandler.checkIfPageExists';
import checkIfFlowExists from '@salesforce/apex/Utils.checkIfFlowExists';
import checkTabPositioningOnPage from '@salesforce/apex/ByopHandler.checkTabPositioningOnPage';
import checkQuipTemplate from '@salesforce/apex/Utils.checkQuipTemplate';
import deployProcess from '@salesforce/apex/ByopHandler.deployProcess';
import deployFlow from '@salesforce/apex/ByopHandler.deployFlow';
import getLastRun from '@salesforce/apex/ByopHandler.getLastRun';
import storeRun from '@salesforce/apex/ByopHandler.storeRun';

import HOME_IMAGE from '@salesforce/resourceUrl/byop';
import TAB_SAMPLE_IMAGE from '@salesforce/resourceUrl/tabSample';

export default class ByopComponent extends LightningElement {
    homeImage = HOME_IMAGE;
    tabSampleImage = TAB_SAMPLE_IMAGE;
    steps = [
        {
            label: 'Introduction',
            id: 1,
            visible: true
        },
        {
            label: 'Choose Template',
            id: 2,
            visible: true
        },
        {
            label: 'Embed Template',
            id: 3,
            visible: true
        },
        {
            label: 'Choose Lightning Page',
            id: 4,
            visible: false
        },
        {
            label: 'Configure Sharing',
            id: 5,
            visible: false
        },
        {
            label: 'Review Selection',
            id: 6,
            visible: false
        },
        {
            label: 'Embed',
            id: 7,
            visible: false
        },
        {
            label: 'Automate Creation',
            id: 8,
            visible: true
        },
        {
            label: 'Triggers',
            id: 9,
            visible: false
        },
        {
            label: 'Create Process',
            id: 10,
            visible: false
        },
        {
            label: 'Finish Up',
            id: 11,
            visible: true
        }
    ];
    currentStep = 1;

    sharingOptions = [
        {
            label: 'View and Edit',
            value: 'edit'
        },
        {
            label: 'View Only',
            value: 'view'
        },
        {
            label: 'Must Request Access',
            value: 'none'
        }
    ];

    templateType = null;
    templateUrl = '';

    orgObjects = [];
    @wire(getOrgObjects)
    wiredOrgObjects({ error, data }) {
        if (data) {
            this.orgObjects = data.slice().sort((a, b) => {
                var textA = a.label.toUpperCase();
                var textB = b.label.toUpperCase();
                return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
            });
        } else {
            if (error) {
                this.showNotification('An error has occurred', 'List of objects could not be retrieved.', 'error');
            }
            this.orgObjects = [];
        }
    }

    objectType = null;
    @track objectName = '';

    recordPages = [];
    loadingRecordPages = false;

    recordPageName = '';
    recordPageCopy = false;
    tabName = '';

    sharingOption = 'edit';

    createOption = null;

    @track preflightCheckResults = {
        fieldCheck: {},
        pageCheck: {},
        tabCheck: {},
        templateCheck: {},
        flowCheck: {}
    };

    outputTemplateUrl = '';
    outputPageId = '';

    lastRunLoaded = false;
    lastRunTimestamp = null;

    checkLastRun() {
        getLastRun()
            .then(data => {
                if (data !== undefined) {
                    this.lastRunLoaded = true;
                    if (data != null) {
                        this.objectName = data.objectName;
                        this.outputPageId = data.pageId;
                        this.recordPageCopy = data.copyPage;
                        this.tabName = data.tabName;
                        this.createOption = data.createOption;
                        this.outputTemplateUrl = data.templateUrl;
                        this.lastRunTimestamp = data.timestamp;
            
                        this.currentStep = 11;
                    }
                }
            })
            .catch(error => {
                this.lastRunLoaded = true;
                this.showNotification('An error has occurred', 'Could not check if this flow has run already.', 'error');
            });
    }

    get visibleSteps() {
        return this.steps.filter(s => s.visible);
    }

    get highlightedStep() {
        for (let i = this.currentStep; i > 0; i--) {
            let step = this.visibleSteps.find(s => s.id === i);
            if (step) {
                return i;
            }
        }
    }

    get isFirstStep() {
        return this.currentStep === 1;
    }

    get isLastStep() {
        return this.currentStep === this.steps.length;
    }

    get isPreflightCheckError() {
        for (let check in this.preflightCheckResults) {
            if (this.preflightCheckResults[check].error) {
                return true;
            }
        }

        return false;
    }

    get isBackDisabled() {
        // true -> disabled
        // false -> enabled

        if (this.currentStep === 7 || this.currentStep === 8) {
            return true;
        }

        if (this.currentStep === 10) {
            return true;
        }

        if (this.currentStep === 11) {
            return this.createOption === 'creation' || this.lastRunTimestamp;
        }

        // Default: enable back
        return false;
    }

    get isNextDisabled() {
        // true -> disabled
        // false -> enabled
        if (this.currentStep === 1) {
            return !this.lastRunLoaded;
        }
        
        if (this.currentStep === 2) {
            if (!this.templateUrl || !this.isTemplateUrlValid) {
                return true;
            }
        }

        if (this.currentStep === 3) {
            return !this.objectName;
        }

        if (this.currentStep === 4) {
            return !this.tabName || !this.recordPageName;
        }

        if (this.currentStep === 6) {
            for (let check in this.preflightCheckResults) {
                if (this.preflightCheckResults[check].loading || this.preflightCheckResults[check].error) {
                    return true;
                }
            }
            return false;
        }

        if (this.currentStep === 7) {
            return true;
        }

        if (this.currentStep === 9) {
            return !this.createOption || (this.createOption === 'creation' && (this.preflightCheckResults.flowCheck.loading || this.preflightCheckResults.flowCheck.error));
        }

        if (this.currentStep === 10) {
            return true;
        }

        // Default: enable next step
        return false;
    }

    get objectNameLabel() {
        let object = this.orgObjects.find(o => o.value === this.objectName);
        if (!object) {
            return this.objectName;
        }
        return object.label;
    }

    get recordPageLabel() {
        let page = this.recordPages.find(p => p.value === this.recordPageName);
        if (!page) {
            return null;
        }
        return page.label;
    }

    get newApiName() {
        return `${this.tabName.trim().replace(/[^0-9A-Za-z]/g, '_').replace(/_+/g, '_')}_Quip_URL__c`;
    }

    get isObjectTypeAccount() {
        return this.objectType === 'account';
    }

    get isObjectTypeCustom() {
        return this.objectType === 'custom';
    }

    get isCreateOptionManual() {
        return this.createOption === 'manual';
    }

    get isCreateOptionCreation() {
        return this.createOption === 'creation';
    }

    get isCreateOptionCustom() {
        return this.createOption === 'custom';
    }

    get isTemplateUrlValid() {
        return RegExp(/https:\/\/[A-z0-9\-_\.]*?quip.com\/[A-z0-9]+[\/.]*/).test(this.templateUrl);
    }

    get verificationSteps() {
        let steps = [];

        steps.push({
            text: `Add a custom field on the ${this.objectNameLabel} object called ${this.tabName}`,
            description: `Quip uses this field to store the document URL for every ${this.objectNameLabel}`,
            preflightCheck: this.preflightCheckResults.fieldCheck,
            checkTrue: 'The field already exists, we\'ll skip this step',
            checkFalse: 'The field does not exist yet and will be created'
        });

        if (this.recordPageCopy) {
            steps.push({
                text: `Create a copy of the Record Page and call it ${this.recordPageLabel} - with Quip ${this.tabName}`,
                description: `From Object Manager, choose the ${this.objectNameLabel} object, and select Lightning Record Pages`,
                preflightCheck: this.preflightCheckResults.pageCheck,
                checkTrue: 'The page already exists, we\'ll skip this step',
                checkFalse: 'The page does not exist yet and a copy will be created'
            });

            steps.push({
                text: `Create a custom tab called ${this.tabName} on ${this.recordPageLabel} - with Quip ${this.tabName}`,
                preflightCheck: this.preflightCheckResults.tabCheck,
                checkTrue: 'Quip Document can be embedded on this page',
                checkFalse: 'Quip Document cannot be embedded here'
            });
        } else {
            steps.push({
                text: `Create a custom tab called ${this.tabName} on ${this.recordPageLabel}`,
                preflightCheck: this.preflightCheckResults.tabCheck,
                checkTrue: 'Quip Document can be embedded on this page',
                checkFalse: 'Quip Document cannot be embedded here'
            });
        }
        
        steps.push({
            text: `Add the Quip Document component to the ${this.tabName} tab`,
            preflightCheck: this.preflightCheckResults.templateCheck,
            checkTrue: 'Quip template is accessible and ready to use',
            checkFalse: 'Quip template is not accessible'
        });

        return steps.map((step, i) => ({
            ...step,
            key: i+1
        }));
    }

    get preflightChecksRunning() {
        return Object.keys(this.preflightCheckResults).length > 0;
    }

    get noRecordPages() {
        return !this.loadingRecordPages && this.recordPages.length === 0;
    }

    get flowLabel() {
        return `Quip - ${this.objectName} - Create ${this.tabName}`;
    }

    get lastRunTime() {
        if (!this.lastRunTimestamp) {
            return '';
        } else {
            return (new Date(this.lastRunTimestamp * 1000)).toLocaleString();
        }
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

    startEmbed() {
        deployProcess({
            objectName: this.objectName,
            fieldName: this.newApiName,
            templateUrl: this.templateUrl,
            pageId: this.recordPageName,
            copyPage: this.recordPageCopy,
            tabName: this.tabName,
            sharingLevel: this.sharingOption
        })
            .then(data => {
                if (data.page && data.page !== '') {
                    data.page = `/visualEditor/appBuilder.app?id=${data.page}`;
                } else {
                    data.page = `/lightning/setup/ObjectManager/${this.objectName}/LightningPages/view`;
                }
                this.outputPageId = data.page;
                this.outputTemplateUrl = data.document;
                this.handleNext();
            })
            .catch(error => {
                console.error(error);
                this.showNotification('An Error Occurred', `Document embedding failed: ${error.body.message}`, 'error');
                this.handleBack();
            });
    }

    startAutomate() {
        if (this.createOption !== 'creation') {
            this.handleNext();
            return;
        }

        let templateUrl = this.outputTemplateUrl;
        if (!templateUrl) {
            templateUrl = this.templateUrl;
        }

        deployFlow({
            objectName: this.objectName,
            fieldName: this.newApiName,
            templateUrl: templateUrl,
            sharingLevel: this.sharingOption,
            tabName: this.tabName
        })
            .then(() => {
                this.handleNext();
            })
            .catch(error => {
                console.error(error);
                this.showNotification('An Error Occurred', `Process creation failed: ${error.body.message}`, 'error');
                this.handleBack();
            });
    }

    loadRecordPages() {
        this.loadingRecordPages = true;
        getRecordPages({ objectName: this.objectName })
            .then(data => {
                this.recordPages = data.slice().sort((a, b) => {
                    var textA = a.label.toUpperCase();
                    var textB = b.label.toUpperCase();
                    return (textA < textB) ? -1 : (textA > textB) ? 1 : 0;
                });
            })
            .catch(error => {
                this.showNotification('An error has occurred', `Record pages could not be retrieved.`, 'error');
                this.recordPages = [];
            })
            .then(() => {
                this.loadingRecordPages = false;
            });
    }

    handleNext() {
        if (this.currentStep < this.steps.length) {
            this.currentStep++;

            if (this.currentStep === 4) {
                this.loadRecordPages();
            }

            if (this.currentStep === 6) {
                this.runPreflightChecks();
            }

            if (this.currentStep === 7) {
                this.startEmbed();
            }

            if (this.currentStep === 10) {
                this.startAutomate();
            }

            if (this.currentStep === 11) {
                this.storeFlowResult();
            }
        }
    }

    handleBack() {
        if (this.currentStep > 1) {
            this.currentStep--;
        }

        if (this.currentStep === 10) {
            this.currentStep--;
        }
    }

    handleFinish() {
        this.dispatchEvent(new CustomEvent('finish'));
    }

    handleTemplateUrlChange(event) {
        this.templateUrl = event.target.value;
    }

    handleObjectTypeChange(event) {
        this.objectType = event.target.value;
        if (this.objectType === 'account') {
            this.objectName = 'Account';
        } else {
            this.objectName = '';
        }
    }

    handleObjectNameChange(event) {
        this.objectName = event.target.value;
    }

    handleTabNameChange(event) {
        this.tabName = event.target.value;
    }

    handleRecordPageChange(event) {
        this.recordPageName = event.target.value;
    }

    handleRecordPageCopyChange() {
        this.recordPageCopy = !this.recordPageCopy;
    }

    handleCreateOptionChange(event) {
        this.createOption = event.target.value;
        if (this.createOption === 'creation') {
            this.runFlowPreflightCheck();
        }
    }

    handleSharingOptionSelect(event) {
        this.sharingOption = event.target.value;
    }

    runPreflightChecks() {
        this.preflightCheckResults = {};
        
        // Field exist
        this.preflightCheckResults.fieldCheck = {
            loading: true,
            result: null
        };
        checkIfFieldExists({
            objectName: this.objectName,
            fieldName: this.newApiName
        })
            .then(result => {
                this.preflightCheckResults.fieldCheck = {
                    loading: false,
                    result: result
                };
            })
            .catch(error => {
                this.preflightCheckResults.fieldCheck = {
                    loading: false,
                    error: error.body.message
                };
                console.error(error);
                this.showNotification('An Error Occurred', `Field check failed: ${error.body.message}`, 'error');
            });
        
        // Page exist
        if (this.recordPageCopy) {
            this.preflightCheckResults.pageCheck = {
                loading: true,
                result: null
            };
            checkIfPageExists({
                pageId: this.recordPageName,
                pageCopy: this.recordPageCopy,
                tabName: this.tabName
            })
                .then(result => {
                    this.preflightCheckResults.pageCheck = {
                        loading: false,
                        result: result
                    };
                })
                .catch(error => {
                    this.preflightCheckResults.pageCheck = {
                        loading: false,
                        error: error.body.message
                    };
                    console.error(error);
                    this.showNotification('An Error Occurred', `Page check failed: ${error.body.message}`, 'error');
                });
        }

        // Tab check
        this.preflightCheckResults.tabCheck = {
            loading: true,
            result: null
        };
        checkTabPositioningOnPage({
            pageId: this.recordPageName,
            pageCopy: this.recordPageCopy,
            tabName: this.tabName
        })
            .then(result => {
                if (result) {
                    this.preflightCheckResults.tabCheck = {
                        loading: false,
                        result: result
                    };
                } else {
                    this.preflightCheckResults.tabCheck = {
                        loading: false,
                        error: 'Quip Document cannot be embedded on this page. If a tab with the same name already exists on this page, remove it and try again.'
                    };
                }
            })
            .catch(error => {
                this.preflightCheckResults.tabCheck = {
                    loading: false,
                    error: error.body.message
                };
                console.error(error);
                this.showNotification('An Error Occurred', `Tab check failed: ${error.body.message}`, 'error');
            });

        // Quip template check
        this.preflightCheckResults.templateCheck = {
            loading: true,
            result: null
        };
        checkQuipTemplate({
            templateUrl: this.templateUrl
        })
            .then(result => {
                if (result) {
                    this.preflightCheckResults.templateCheck = {
                        loading: false,
                        result: result
                    };
                } else {
                    this.preflightCheckResults.templateCheck = {
                        loading: false,
                        error: 'Quip template is not accessible'
                    };
                }
            })
            .catch(error => {
                this.preflightCheckResults.templateCheck = {
                    loading: false,
                    error: error.body.message
                };
                console.error(error);
                this.showNotification('An Error Occurred', `Template check failed: ${error.body.message}`, 'error');
            });
            
    }

    runFlowPreflightCheck() {
        // Flow exist
        this.preflightCheckResults.flowCheck = {
            loading: true,
            result: null
        };
        checkIfFlowExists({
            flowLabel: this.flowLabel
        })
            .then(result => {
                if (!result) {
                    this.preflightCheckResults.flowCheck = {
                        loading: false,
                        result: result
                    };
                } else {
                    this.preflightCheckResults.flowCheck = {
                        loading: false,
                        error: 'There is a duplicate process for this object. Deactivate it and try again.'
                    };
                }
            })
            .catch(error => {
                this.preflightCheckResults.flowCheck = {
                    loading: false,
                    error: error.body.message
                };
                console.error(error);
                this.showNotification('An Error Occurred', `Process check failed: ${error.body.message}`, 'error');
            });
    }

    handleStartAgain() {
        this.lastRunTimestamp = null;
        this.objectName = null;
        this.outputPageId = '';
        this.recordPageCopy = false;
        this.tabName = '';
        this.createOption = null;
        this.outputTemplateUrl = '';
        this.currentStep = 1;
        this.templateType = null;
    }

    storeFlowResult() {
        storeRun({
            objectName: this.objectName,
            fieldName: this.newApiName,
            createOption: this.createOption,
            copyPage: this.recordPageCopy,
            pageId: this.outputPageId,
            timestamp: Math.floor(Date.now() / 1000),
            tabName: this.tabName,
            templateUrl: this.outputTemplateUrl
        })
            .catch(error => {
                console.error(error);
                this.showNotification('An Error Occurred', `Could not store the run results: ${error.body.message}`, 'error');
            });
    }

    connectedCallback() {
        this.checkLastRun();
    }
}