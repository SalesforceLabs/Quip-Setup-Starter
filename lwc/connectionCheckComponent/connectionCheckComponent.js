import { LightningElement } from 'lwc';
import HOME_IMAGE from '@salesforce/resourceUrl/connectionChecklist';

export default class ConnectionCheckComponent extends LightningElement {
    homeImage = HOME_IMAGE;

    steps = [
        {
            label: 'Introduction',
            id: 1,
            visible: true
        },
        {
            label: 'Check Connections',
            id: 2,
            visible: true
        }
    ];
    currentStep = 1;

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

        // Default: enable back
        return false;
    }

    get isNextDisabled() {
        // true -> disabled
        // false -> enabled

        // Default: enable next step
        return false;
    }

    handleNext() {
        if (this.currentStep < this.steps.length) {
            this.currentStep++;
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
}