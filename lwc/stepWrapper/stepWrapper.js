import { LightningElement, api } from 'lwc';

export default class StepWrapper extends LightningElement {
    @api step;
    @api current;

    get isVisible() {
        return this.current == this.step;
    }
}