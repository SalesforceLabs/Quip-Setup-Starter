import { LightningElement, track, wire, api } from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from 'lightning/platformResourceLoader';
import getOrgObjects from '@salesforce/apex/Utils.getOrgObjects';
import getUrlFieldsForObject from '@salesforce/apex/Utils.getUrlFieldsForObject';
import checkIfFlowExists from '@salesforce/apex/Utils.checkIfFlowExists';
import checkQuipTemplate from '@salesforce/apex/Utils.checkQuipTemplate';
import deployLiveDataFeed from '@salesforce/apex/LiveDataFeedHandler.deployLiveDataFeed';
import getLastRun from '@salesforce/apex/LiveDataFeedHandler.getLastRun';
import storeRun from '@salesforce/apex/LiveDataFeedHandler.storeRun';

import LIVE_FEED_HOME_IMAGE from '@salesforce/resourceUrl/liveFeed';
import DOC_NOTIFICATIONS_HOME_IMAGE from '@salesforce/resourceUrl/notificationsDocs';
import CUSTOM_CSS from '@salesforce/resourceUrl/textArea';

const SUPPORTED_FIELD_DATA_TYPES = [
    'Boolean',
    'Currency',
    'Date',
    'DateTime',
    'Double',
    'Int',
    'Percent',
    'Picklist',
    'String',
    'Url'
];

export default class LiveFeedComopnent extends LightningElement {
    liveFeedHomeImage = LIVE_FEED_HOME_IMAGE;
    docNotificationsHomeImage = DOC_NOTIFICATIONS_HOME_IMAGE;

    @api type;

    steps = [
        {
            label: 'Introduction',
            id: 1,
            visible: true
        },
        {
            label: 'Set Conditions',
            id: 2,
            visible: true
        },
        {
            label: 'Configure Conditions',
            id: 3,
            visible: false
        },
        {
            label: 'Create Data Feed',
            id: 4,
            visible: false
        },
        {
            label: 'Configure Template',
            id: 5,
            visible: true
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
            label: 'Finish Up',
            id: 8,
            visible: true
        },
    ];
    currentStep = 1;

    objectType = null;
    @track objectName = '';

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

    objectFields = [];
    destinationUrlFields = [];
    @track recordTypeId = null;
    @wire(getObjectInfo, { objectApiName: '$objectName' })
    wiredGetObjectInfo({ error, data }) {
        if (error) {
            console.error(error);
            this.objectFields = [];
        } else if (data) {
            this.objectFields = Object.values(data.fields)
                .filter(field => SUPPORTED_FIELD_DATA_TYPES.indexOf(field.dataType) > -1);
            this.recordTypeId = data.defaultRecordTypeId;

            if (this.isDocNotifications) {
                getUrlFieldsForObject({ objectName: this.objectName, depth: 3 })
                    .then(result => {
                        this.destinationUrlFields = result.slice().sort((a, b) => (a.label > b.label) ? 1 : b.label > a.label ? -1 : 0);
                    })
                    .catch(error => {
                        this.destinationUrlFields = [];
                    });
            }
        } else {
            this.objectFields = [];
        }
    }

    criteriaType = null;
    @track criteriaFieldName = null;
    criteriaFieldChangeType = 'any';
    criteriaFieldOperator = null;
    criteriaFieldValue = null;

    booleanOptions = [
        { label: 'True', value: 'true' },
        { label: 'False', value: 'false' }
    ]
    picklistOptions = {}
    dateOperatorOptions = [
        { label: 'Equals', value: 'EqualTo', type: 'date' },
        { label: 'Does not equal', value: 'NotEqualTo', type: 'date' },
        { label: 'Greater than', value: 'GreaterThan', type: 'date' },
        { label: 'Greater than or equal', value: 'GreaterThanOrEqualTo', type: 'date' },
        { label: 'Less than', value: 'LessThan', type: 'date' },
        { label: 'Less than or equal', value: 'LessThanOrEqualTo', type: 'date' },
        { label: 'Is null', value: 'IsNull', type: 'boolean' }
    ]
    numericOperatorOptions = [
        { label: 'Equals', value: 'EqualTo', type: 'number' },
        { label: 'Does not equal', value: 'NotEqualTo', type: 'number' },
        { label: 'Greater than', value: 'GreaterThan', type: 'number' },
        { label: 'Greater than or equal', value: 'GreaterThanOrEqualTo', type: 'number' },
        { label: 'Less than', value: 'LessThan', type: 'number' },
        { label: 'Less than or equal', value: 'LessThanOrEqualTo', type: 'number' },
        { label: 'Is null', value: 'IsNull', type: 'boolean' }
    ]
    stringOperatorOptions = [
        { label: 'Equals', value: 'EqualTo', type: 'text' },
        { label: 'Does not equal', value: 'NotEqualTo', type: 'text' },
        { label: 'Starts With', value: 'StartsWith', type: 'text' },
        { label: 'Contains', value: 'Contains', type: 'text' },
        { label: 'Ends With', value: 'EndsWith', type: 'text' },
        { label: 'Is null', value: 'IsNull', type: 'boolean' }
    ]
    fieldChangeTypeOptions = [
        { label: 'Anytime the field changes', value: 'any' },
        { label: 'When a condition is met', value: 'condition' }
    ]
    notificationOptions = [
        { label: 'Send a notification to @everyone in the document', value: 'yes' },
        { label: 'Post the update in the document\'s conversation pane, but do not send any notifications', value: 'no' }
    ]

    notifyEveryone = 'no'
    message = ''

    @wire(getPicklistValuesByRecordType, { recordTypeId: '$recordTypeId', objectApiName: '$objectName' })
    wiredGetPicklistValues({ error, data }) {
        if (error) {
            console.error(error);
            this.picklistOptions = {};
        } else if (data) {
            let newOptions = {};
            for (let apiName in data.picklistFieldValues) {
                newOptions[apiName] = data.picklistFieldValues[apiName].values;
            }
            this.picklistOptions = newOptions;
        } else {
            this.picklistOptions = {};
        }
    }

    destinationUrl = ''
    destinationUrlField;

    @track preflightCheckResults = {
        docCheck: {},
        flowCheck: {}
    };

    lastRunLoaded = false;
    lastRunTimestamp = null;

    checkLastRun() {
        getLastRun({
            type: this.type
        })
            .then(data => {
                if (data !== undefined) {
                    this.lastRunLoaded = true;
                    if (data != null) {
                        this.objectName = data.objectName;
                        this.destinationUrl = data.destiationUrl;
                        this.criteriaType = data.criteriaType;
                        this.criteriaFieldName = data.criteriaFieldName;
                        this.lastRunTimestamp = data.timestamp;
            
                        this.currentStep = 8;
                    }
                }
            })
            .catch(error => {
                this.lastRunLoaded = true;
                this.showNotification('An error has occurred', 'Could not check if this flow has run already.', 'error');
            });
    }

    get isDataFeed() {
        return this.type === 'data-feed';
    }

    get isDocNotifications() {
        return this.type === 'doc-notifications';
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

        if (this.currentStep === 7 || this.currentStep === 8) {
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
            return !this.objectName;
        }

        if (this.currentStep === 3) {
            return !this.criteriaType || (this.criteriaType === 'field-change' && (!this.criteriaFieldName || (this.isCriteriaFieldChangeTypeCondition && (!this.criteriaFieldOperator || this.criteriaFieldValue === null))));
        }

        if (this.currentStep === 4) {
            return !this.message || this.message.trim().length === 0;
        }

        if (this.currentStep === 5) {
            return !this.destinationUrl && !this.destinationUrlField;
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

        // Default: enable next step
        return false;
    }

    get isObjectTypeOpportunity() {
        return this.objectType === 'opportunity';
    }
    
    get isObjectTypeCase() {
        return this.objectType === 'case';
    }

    get isObjectTypeCustom() {
        return this.objectType === 'custom';
    }

    get objectFieldOptions() {
        return this.objectFields
            .map(field => ({
                label: field.label,
                value: field.apiName
            }))
            .sort((a, b) => (a.label > b.label) ? 1 : b.label > a.label ? -1 : 0);
    }

    get isCriteriaTypeRecord() {
        return this.criteriaType === 'new-record';
    }

    get isCriteriaTypeField() {
        return this.criteriaType === 'field-change';
    }

    get criteriaFieldDataType() {
        let field = this.objectFields.find(field => field.apiName === this.criteriaFieldName);
        if (!field) {
            return null;
        }
        return field.dataType;
    }

    get criteriaFieldLabel() {
        let field = this.objectFields.find(field => field.apiName === this.criteriaFieldName);
        if (!field) {
            return null;
        }
        return field.label;
    }

    get isCriteriaFieldTypeBoolean() {
        return this.criteriaFieldDataType === 'Boolean';
    }

    get isCriteriaFieldTypePicklist() {
        return this.criteriaFieldDataType === 'Picklist';
    }

    get isCriteriaFieldTypeString() {
        return this.criteriaFieldDataType === 'String' ||
            this.criteriaFieldDataType === 'Url';
    }

    get isCriteriaFieldTypeDate() {
        return this.criteriaFieldDataType === 'Date' ||
            this.criteriaFieldDataType === 'DateTime';
    }

    get isCriteriaFieldTypeNumeric() {
        return this.criteriaFieldDataType === 'Currency' ||
            this.criteriaFieldDataType === 'Double' ||
            this.criteriaFieldDataType === 'Int' ||
            this.criteriaFieldDataType === 'Percent';
    }

    get criteriaOperatorValueType() {
        if (!this.criteriaFieldOperator) {
            return null;
        }

        let operators = [];
        if (this.isCriteriaFieldTypeBoolean || this.isCriteriaFieldTypePicklist) {
            return null;
        } else if (this.isCriteriaFieldTypeDate) {
            operators = this.dateOperatorOptions;
        } else if (this.isCriteriaFieldTypeString) {
            operators = this.stringOperatorOptions;
        } else if (this.isCriteriaFieldTypeNumeric) {
            operators = this.numericOperatorOptions;
        }

        return operators.find(op => op.value === this.criteriaFieldOperator).type;
    }

    get isCriteriaOperatorValueTypeBoolean() {
        return this.criteriaOperatorValueType === 'boolean';
    }

    get isCriteriaFieldChangeTypeCondition() {
        return this.criteriaFieldChangeType === 'condition';
    }

    get picklistFieldOptions() {
        if (!this.picklistOptions[this.criteriaFieldName]) {
            return [];
        }

        return this.picklistOptions[this.criteriaFieldName];
    }

    get isOpportunityClosed() {
        return this.isObjectTypeOpportunity && (this.criteriaFieldName == 'IsClosed' || this.criteriaFieldName == 'IsWon' || (this.criteriaFieldName == 'StageName' && (this.criteriaFieldValue && this.criteriaFieldValue.toLowerCase().indexOf('closed') > -1)));
    }

    get templateCreateButtonLabel() {
        return `${this.objectLabel} Created Template`;
    }

    get templateEditButtonLabel() {
        return `${this.objectLabel} Changed Template`;
    }

    get objectLabel() {
        let object = this.orgObjects.find(object => object.value === this.objectName);
        if (!object) {
            return this.objectName;
        }
        return object.label;
    }

    get verificationSteps() {
        let steps = [];

        if (!this.isDocNotifications) {
            steps.push({
                text: `Check Document Access`,
                description: 'This is the document where notifications will appear',
                preflightCheck: this.preflightCheckResults.docCheck,
                checkTrue: 'Quip document is accessible and ready to use',
                checkFalse: 'Quip document is not accessible. Request access from the document owner'
            });
        }
        
        steps.push({
            text: `Create a process called Quip - ${this.objectLabel} - ${this.isDataFeed ? 'Live Data Feed' : 'Document Notifications'}`,
            description: 'The Process Builder process will send notifications to Quip',
            preflightCheck: this.preflightCheckResults.flowCheck,
            checkTrue: 'There is a duplicate process with this name. Deactivate it and try again.',
            checkFalse: 'The process does not yet exist and will be created'
        });


        return steps.map((step, i) => ({
            ...step,
            key: i + 1
        }));
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
        if (this.isDocNotifications) {
            return `Quip - ${this.objectLabel} - ${this.isCriteriaTypeRecord ? 'New' : this.criteriaFieldName} - Document Notifications`;
        } else {
            return `Quip - ${this.objectLabel} - ${this.isCriteriaTypeRecord ? 'New' : this.criteriaFieldName} - Live Data Feed`;
        }
    }

    get foundDestinationUrlFields() {
        return this.destinationUrlFields.length > 0;
    }

    get lastRunTime() {
        if (!this.lastRunTimestamp) {
            return '';
        } else {
            return (new Date(this.lastRunTimestamp * 1000)).toLocaleString();
        }
    }

    handleNext() {
        if (this.currentStep < this.steps.length) {
            this.currentStep++;

            if (this.currentStep === 6) {
                this.runPreflightChecks();
            }

            if (this.currentStep === 7) {
                this.startAutomate();
            }

            if (this.currentStep === 8) {
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
        } else if (this.objectType === 'case') {
            this.objectName = 'Case';
        } else {
            this.objectName = '';
        }
    }

    handleObjectNameChange(event) {
        this.objectName = event.target.value;
    }

    handleCriteriaTypeChange(event) {
        this.criteriaType = event.target.value;
        if (this.criteriaType === 'new-record') {
            this.criteriaFieldName = null;
            this.criteriaFieldOperator = null;
            this.criteriaFieldValue = null;
        }
        this.message = '';
    }

    handleCriteriaFieldChange(event) {
        this.criteriaFieldName = event.target.value;
        this.criteriaFieldOperator = 'EqualTo';
        this.criteriaFieldChangeType = 'any';
        this.criteriaFieldValue = null;
        this.message = '';
    }

    handleCriteriaFieldValueChange(event) {
        this.criteriaFieldValue = event.target.value;
    }

    handleCriteriaFieldOperatorChange(event) {
        this.criteriaFieldOperator = event.target.value;
    }

    handleCriteriaFieldChangeType(event) {
        this.criteriaFieldChangeType = event.target.value;
        this.criteriaFieldOperator = 'EqualTo';
        this.criteriaFieldValue = null;
    }

    handleDestinationUrlFieldChange(event) {
        this.destinationUrlField = event.target.value;
    }

    fillInOpportunityClosedTemplate() {
        let everyoneMessage = this.notifyEveryone === 'yes' ? '"@Everyone <br />"\n& ' : '';
        this.message = `${everyoneMessage}"Congrats <b>"
& [Opportunity].Owner.FirstName
& " "
& [Opportunity].Owner.LastName
& "</b> on closing <br /><b>"
& [Opportunity].Name
& "</b><br />Opportunity Amount: <b>"
& TEXT([Opportunity].Amount)
& "</b><br />Opportunity Link: "
& "${location.origin}/"
& [Opportunity].Id`;
    }

    fillInRecordCreatedTemplate() {
        let everyoneMessage = this.notifyEveryone === 'yes' ? '"@Everyone <br />"\n& ' : '';
        this.message = `${everyoneMessage}"Live Alert! <br />"
& "<b>A new ${this.objectLabel} has been created!</b>"
& "</b><br />"
& "Check it out: "
& "${location.origin}/"
& [${this.objectName}].Id`;
    }

    fillInFieldChangeTemplate() {
        let everyoneMessage = this.notifyEveryone === 'yes' ? '"@Everyone <br />"\n& ' : '';
        if (this.isCriteriaFieldTypePicklist) {
            this.message = `${everyoneMessage}"${this.objectLabel} Live Alert! <br />"
& "<b>${this.criteriaFieldLabel} has moved to " & TEXT([${this.objectName}].${this.criteriaFieldName}) & "!</b>"
& "</b><br />"
& "Check it out: "
& "${location.origin}/"
& [${this.objectName}].Id`;
        } else {
            this.message = `${everyoneMessage}"${this.objectLabel} Live Alert! <br />"
& "<b>${this.criteriaFieldLabel} is now " & TEXT([${this.objectName}].${this.criteriaFieldName}) & "!</b>"
& "</b><br />"
& "Check it out: "
& "${location.origin}/"
& [${this.objectName}].Id`;
        }
    }

    handleContentChange(event) {
        this.message = event.target.value;
        if (this.message.toLowerCase().indexOf('@everyone') > -1) {
            this.notifyEveryone = 'yes';
        } else {
            this.notifyEveryone = 'no';
        }
    }

    handleDestinationUrlChange(event) {
        this.destinationUrl = event.target.value;
    }

    handleNotificationChange(event) {
        this.notifyEveryone = event.target.value;
        if (this.notifyEveryone === 'yes') {
            if (this.message.toLowerCase().indexOf('@everyone') === -1) {
                this.message = `"@Everyone <br />"\n& ${this.message}`;
            }
        } else {
            if (this.message.indexOf('"@Everyone <br />"\n& ') > -1) {
                this.message = this.message.split('"@Everyone <br />"\n& ').join('');
            } else if (this.message.indexOf('"@everyone <br />"\n& ') > -1) {
                this.message = this.message.split('"@everyone <br />"\n& ').join('');
            } else if (this.message.indexOf('@Everyone') > -1) {
                this.message = this.message.split('@Everyone').join('');
            } else if (this.message.indexOf('@everyone') > -1) {
                this.message = this.message.split('@everyone').join('');
            }
        }
    }

    runPreflightChecks() {
        this.preflightCheckResults = {};

        if (this.isDataFeed) {

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
                            error: 'Process already exists'
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

            // Quip template check
            this.preflightCheckResults.docCheck = {
                loading: true,
                result: null
            };
            checkQuipTemplate({
                templateUrl: this.destinationUrl
            })
                .then(result => {
                    if (result) {
                        this.preflightCheckResults.docCheck = {
                            loading: false,
                            result: result
                        };
                    } else {
                        this.preflightCheckResults.docCheck = {
                            loading: false,
                            error: 'Quip document is not accessible'
                        };
                    }
                })
                .catch(error => {
                    this.preflightCheckResults.docCheck = {
                        loading: false,
                        error: error.body.message
                    };
                    console.error(error);
                    this.showNotification('An Error Occurred', `Document check failed: ${error.body.message}`, 'error');
                });
        }

        if (this.isDocNotifications) {
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
                            error: 'Process already exists'
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

    }

    startAutomate() {
        let message = this.message.trim().replace(/\n/g, ' ');
        if (message.indexOf('"') === -1) {
            message = `"${message}"`;
        }

        let destination = this.destinationUrl;
        if (this.isDocNotifications) {
            destination = this.destinationUrlField;
        }
        deployLiveDataFeed({
            objectName: this.objectName,
            documentUrl: destination,
            message: message,
            criteriaNewRecord: this.isCriteriaTypeRecord,
            criteriaName: this.criteriaFieldName,
            criteriaCondition: this.isCriteriaFieldChangeTypeCondition,
            criteriaOperator: this.criteriaFieldOperator,
            criteriaValue: this.criteriaFieldValue,
            staticDestination: this.isDataFeed
        })
            .then(() => {
                this.handleNext();
            })
            .catch(error => {
                this.showNotification('An Error Occurred', `${this.isDataFeed ? 'Live Data Feed' : 'Document Notifications'} creation failed: the field condition or the notification template formula appear to be invalid`, 'error');
                console.error(error);
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
        this.lastRunTimestamp = null;
        this.objectName = null;
        this.destinationUrl = '';
        this.criteriaType = null;
        this.criteriaFieldName = null;
        this.currentStep = 1;
    }

    storeFlowResult() {
        storeRun({
            type: this.type,
            objectName: this.objectName,
            destinationUrl: this.destinationUrl,
            criteriaType: this.criteriaType,
            criteriaFieldName: this.criteriaFieldName,
            timestamp: Math.floor(Date.now() / 1000)
        })
            .catch(error => {
                console.error(error);
                this.showNotification('An Error Occurred', `Could not store the run results: ${error.body.message}`, 'error');
            });
    }

    connectedCallback() {
        this.checkLastRun();

        loadStyle(this, CUSTOM_CSS)
        .then(() => {});
    }
}