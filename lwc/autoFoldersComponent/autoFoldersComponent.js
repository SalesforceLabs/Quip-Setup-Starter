import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOrgObjects from '@salesforce/apex/Utils.getOrgObjects';
import getUrlFieldsForObject from '@salesforce/apex/Utils.getUrlFieldsForObject';
import getReferenceFieldsForObject from '@salesforce/apex/Utils.getReferenceFieldsForObject';
import checkIfFieldExists from '@salesforce/apex/Utils.checkIfFieldExists';
import checkIfFlowExists from '@salesforce/apex/Utils.checkIfFlowExists';
import checkIfFolderExists from '@salesforce/apex/Utils.checkIfFolderExists';
import setupFolderOrganization from '@salesforce/apex/AutoFolderHandler.setupFolderOrganization';
import getLastRun from '@salesforce/apex/AutoFolderHandler.getLastRun';
import storeRun from '@salesforce/apex/AutoFolderHandler.storeRun';

import HOME_IMAGE from '@salesforce/resourceUrl/folders';

const folderFieldName = 'Quip_Folder__c';
const folderFieldLabel = 'Quip Folder';

export default class AutoFoldersComponent extends LightningElement {
    homeImage = HOME_IMAGE;

    steps = [
        {
            label: 'Introduction',
            id: 1,
            visible: true
        },
        {
            label: 'Choose Documents',
            id: 2,
            visible: true
        },
        {
            label: 'Create Folder Structure',
            id: 3,
            visible: true
        },
        {
            label: 'Review Selection',
            id: 4,
            visible: false
        },
        {
            label: 'Automate',
            id: 5,
            visible: false
        },
        {
            label: 'Finish Up',
            id: 6,
            visible: true
        }
    ]
    currentStep = 1

    objectType = null;
    @track objectName = '';

    fieldName = '';

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

    loadingObjectInfo = false;
    objectFields = [];
    relatedObjects = [];

    folderType = null;
    folderCreateChoice = 'create';
    folderName = '';
    folderRelatedObject = '';
    folderRelationshipFieldName = 'Id';

    folderCreateChoices = [
        { label: 'Create a New Folder', value: 'create' },
        { label: 'Use an Existing Folder', value: 'existing' }
    ];

    @wire(getObjectInfo, { objectApiName: '$folderRelatedObject' })
    relatedObjectInfo;

    @track preflightCheckResults = {
        fieldCheck: {},
        folderCheck: {},
        flowCheck: {},
        triggerCheck: {}
    };

    lastRunLoaded = false;
    lastRunTimestamp = null;

    loadObjectInfo() {
        this.loadingObjectInfo = true;
        getUrlFieldsForObject({ objectName: this.objectName, depth: 0 })
            .then(data => {
                this.objectFields = data.sort((a, b) => (a.label > b.label) ? 1 : b.label > a.label ? -1 : 0);
                return getReferenceFieldsForObject({ objectName: this.objectName });
            })
            .then(data => {
                this.relatedObjects = data;
            })
            .catch(error => {
                console.error(error);
                this.objectFields = [];
                this.relatedObjects = [];
            })
            .then(() => {
                this.loadingObjectInfo = false;
            });
    }

    checkLastRun() {
        getLastRun()
            .then(data => {
                if (data !== undefined) {
                    this.lastRunLoaded = true;
                    if (data != null) {
                        this.outputFolderUrl = data.folderUrl;
                        this.objectName = data.objectName;
                        this.fieldName = data.fieldName;
                        this.folderName = data.folderName;
                        this.folderRelatedObject = data.folderRelatedObject;
                        this.folderRelationshipFieldName = data.folderRelationshipFieldName;
                        this.lastRunTimestamp = data.timestamp;

                        this.loadObjectInfo();

                        this.currentStep = 6;
                    }
                }
            })
            .catch(error => {
                this.lastRunLoaded = true;
                this.showNotification('An error has occurred', 'Could not check if this flow has run already.', 'error');
            });
    }

    outputFolderUrl = '';

    get relatedObjectLabel() {
        if (this.relatedObjectInfo.data) {
            return this.relatedObjectInfo.data.label;
        }

        return 'related';
    }

    get verificationSteps() {
        let steps = [];

        if (this.isFolderTypeRelated) {
            steps.push({
                text: `Create a custom field on the ${this.relatedObjectLabel} object called ${folderFieldLabel}`,
                description: `This is to track which folder belongs to which ${this.relatedObjectLabel} record`,
                preflightCheck: this.preflightCheckResults.fieldCheck,
                checkTrue: 'The field already exists, we\'ll skip this step',
                checkFalse: 'The field does not exist yet and will be created'
            });
        } else if (this.isFolderTypeObject) {
            steps.push({
                text: `Create a custom field on the ${this.objectLabel} object called ${folderFieldLabel}`,
                description: `This is to track which folder belongs to which ${this.objectLabel} record`,
                preflightCheck: this.preflightCheckResults.fieldCheck,
                checkTrue: 'The field already exists, we\'ll skip this step',
                checkFalse: 'The field does not exist yet and will be created'
            });
        }

        if (this.isFolderChoiceCreate) {
            steps.push({
                text: `Create a Quip folder called ${this.folderName}`,
                description: `This will be placed in your Private folder, but you can move it elsewhere or share it`,
                preflightCheck: {
                    loading: false,
                    result: true
                },
                checkTrue: 'The folder will be created for you',
                checkFalse: 'The folder will be created for you'
            });
        } else {
            steps.push({
                text: "Link existing Quip folder to the flow",
                description: "This will be filled with all the documents, and you will be able to move it elsewhere or share it",
                preflightCheck: this.preflightCheckResults.folderCheck,
                checkTrue: 'The folder was found and it can be accessed',
                checkFalse: 'Folder not found'
            });
        }

        steps.push({
            text: `Create a flow called Quip - ${this.objectLabel} - ${this.fieldLabel} - Folder Organization`,
            description: `This will manage the folder structure`,
            preflightCheck: this.preflightCheckResults.flowCheck,
            checkTrue: 'There is a duplicate flow for this object. Deactivate it and try again.',
            checkFalse: 'The flow does not yet exist and will be created'
        });

        steps.push({
            text: `Create a process called Quip - ${this.objectLabel} - ${this.fieldLabel} - Folder Organization (Trigger)`,
            description: `This will be used as a trigger for the main flow`,
            preflightCheck: this.preflightCheckResults.triggerCheck,
            checkTrue: 'There is a duplicate process for this object. Deactivate it and try again.',
            checkFalse: 'The process does not yet exist and will be created'
        });


        return steps.map((step, i) => ({
            ...step,
            key: i + 1
        }));
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

    get isBackDisabled() {
        // true -> disabled
        // false -> enabled

        if (this.currentStep === 5 || this.currentStep === 6) {
            return true;
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
            return !this.objectName || !this.fieldName;
        }

        if (this.currentStep === 3) {
            return !this.folderName || !this.folderType || (this.isFolderTypeRelated && !this.folderRelatedObject);
        }

        if (this.currentStep === 4) {
            for (let check in this.preflightCheckResults) {
                if (this.preflightCheckResults[check].loading || this.preflightCheckResults[check].error) {
                    return true;
                }
            }
            return false;
        }

        if (this.currentStep === 5) {
            return true;
        }

        // Default: enable next step
        return false;
    }

    get isObjectTypeAccount() {
        return this.objectType === 'account';
    }

    get isObjectTypeOpportunity() {
        return this.objectType === 'opportunity';
    }

    get isObjectTypeCustom() {
        return this.objectType === 'custom';
    }

    get objectLabel() {
        let object = this.orgObjects.find(object => object.value === this.objectName);
        if (!object) {
            return this.objectName;
        }
        return object.label;
    }

    get fieldLabel() {
        if (!this.objectFields || !this.objectFields.length) {
            return this.fieldName;
        }

        let field = this.objectFields.find(field => field.value === this.fieldName);
        if (!field) {
            return this.fieldName;
        }

        return field.label;
    }

    get isFolderTypeOne() {
        return this.folderType === 'one';
    }

    get isFolderTypeObject() {
        return this.folderType === 'object';
    }

    get isFolderTypeRelated() {
        return this.folderType === 'related';
    }

    get preflightChecksRunning() {
        return Object.keys(this.preflightCheckResults).length > 0;
    }

    get isPreflightCheckError() {
        for (let check in this.preflightCheckResults) {
            if (this.preflightCheckResults[check].error) {
                return true;
            }
        }

        return false;
    }

    get flowLabel() {
        return `Quip - ${this.objectLabel} - ${this.fieldLabel} - Folder Organization`;
    }

    get foundObjectFields() {
        return this.objectFields.length > 0;
    }

    get lastRunTime() {
        if (!this.lastRunTimestamp) {
            return '';
        } else {
            return (new Date(this.lastRunTimestamp * 1000)).toLocaleString();
        }
    }

    get isFolderChoiceCreate() {
        return this.folderCreateChoice === 'create';
    }

    handleNext() {
        if (this.currentStep < this.steps.length) {
            this.currentStep++;

            if (this.currentStep === 4) {
                this.runPreflightChecks();
            }

            if (this.currentStep === 5) {
                this.startAutomate();
            }

            if (this.currentStep === 6) {
                this.storeFlowResult();
            }
        }
    }

    handleBack() {
        if (this.currentStep > 1) {
            this.currentStep--;
        }
    }

    handleFinish() {
        this.dispatchEvent(new CustomEvent('finish'));
    }

    handleObjectTypeChange(event) {
        this.objectType = event.target.value;
        if (this.objectType === 'opportunity') {
            this.objectName = 'Opportunity';
        } else if (this.objectType === 'account') {
            this.objectName = 'Account';
        } else {
            this.objectName = '';
        }
        this.fieldName = '';

        this.loadObjectInfo();
    }

    handleObjectNameChange(event) {
        this.objectName = event.target.value;
        this.fieldName = '';

        this.loadObjectInfo();
    }

    handleFieldChange(event) {
        this.fieldName = event.target.value;
    }

    handleFolderTypeChange(event) {
        this.folderType = event.target.value;
        this.folderName = '';
        this.folderRelationshipFieldName = 'Id';
        this.folderRelatedObject = '';
    }

    handleFolderNameChange(event) {
        this.folderName = event.target.value;
    }

    handleFolderRelatedObjectChange(event) {
        let values = event.target.value.split('/');
        this.folderRelationshipFieldName = values[0];
        this.folderRelatedObject = values[1];
    }

    handleFolderCreateChoiceChange(event) {
        this.folderCreateChoice = event.target.value;
    }

    runPreflightChecks() {
        this.preflightCheckResults = {};

        // Field exist
        if (this.isFolderTypeObject || this.isFolderTypeRelated) {
            this.preflightCheckResults.fieldCheck = {
                loading: true,
                result: null
            };
            let objectName = this.objectName;
            if (this.isFolderTypeRelated) {
                objectName = this.folderRelatedObject;
            }
            checkIfFieldExists({
                objectName: objectName,
                fieldName: folderFieldName
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
        }

        // Folder check
        if (!this.isFolderChoiceCreate) {
            this.preflightCheckResults.folderCheck = {
                loading: true,
                result: null
            };

            checkIfFolderExists({
                url: this.folderName
            })
                .then(result => {
                    if (result) {
                        this.preflightCheckResults.folderCheck = {
                            loading: false,
                            result: result
                        };
                    } else {
                        this.preflightCheckResults.folderCheck = {
                            loading: false,
                            error: 'Folder not found'
                        };
                    }
                })
                .catch(error => {
                    this.preflightCheckResults.folderCheck = {
                        loading: false,
                        error: error.body.message
                    };
                    console.error(error);
                    this.showNotification('An Error Occurred', `Folder check failed: ${error.body.message}`, 'error');
                });
        }

        // Flow check
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
                        error: 'Flow already exists'
                    };
                }
            })
            .catch(error => {
                this.preflightCheckResults.flowCheck = {
                    loading: false,
                    error: error.body.message
                };
                console.error(error);
                this.showNotification('An Error Occurred', `Flow check failed: ${error.body.message}`, 'error');
            });

        // Trigger check
        this.preflightCheckResults.triggerCheck = {
            loading: true,
            result: null
        };
        checkIfFlowExists({
            flowLabel: `${this.flowLabel} (Trigger)`
        })
            .then(result => {
                if (!result) {
                    this.preflightCheckResults.triggerCheck = {
                        loading: false,
                        result: result
                    };
                } else {
                    this.preflightCheckResults.triggerCheck = {
                        loading: false,
                        error: 'Process already exists'
                    };
                }
            })
            .catch(error => {
                this.preflightCheckResults.triggerCheck = {
                    loading: false,
                    error: error.body.message
                };
                console.error(error);
                this.showNotification('An Error Occurred', `Process check failed: ${error.body.message}`, 'error');
            });

    }

    startAutomate() {
        this.outputFolderUrl = '';
        let folderMasterObject = this.objectName;
        if (this.isFolderTypeRelated) {
            folderMasterObject = this.folderRelatedObject;
        }
        setupFolderOrganization({
            objectName: this.objectName,
            fieldName: this.fieldName,
            folderCreate: this.isFolderChoiceCreate,
            folderName: this.folderName,
            relatedFieldName: this.folderRelationshipFieldName,
            folderMasterObject: folderMasterObject,
            setupFolders: this.isFolderTypeObject || this.isFolderTypeRelated
        })
            .then(data => {
                if (data) {
                    this.outputFolderUrl = data.folder;
                } else {
                    this.outputFolderUrl = 'https://quip.com/';
                }
                this.handleNext();
            })
            .catch(error => {
                console.error(error);
                this.showNotification('An Error Occurred', `Folder Organization creation failed: ${error.body.message}`, 'error');
                this.handleBack();
            });
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

    handleStartAgain() {
        this.outputFolderUrl = '';
        this.objectName = '';
        this.fieldName = '';
        this.folderName = '';
        this.folderRelatedObject = '';
        this.folderRelationshipFieldName = 'Id';
        this.lastRunTimestamp = null;
        this.currentStep = 1;
    }

    storeFlowResult() {
        storeRun({
            folderUrl: this.outputFolderUrl,
            objectName: this.objectName,
            fieldName: this.fieldName,
            folderName: this.folderName,
            folderRelatedObject: this.folderRelatedObject,
            folderRelationshipFieldName: this.folderRelationshipFieldName,
            timestamp: Math.floor(Date.now() / 1000)
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