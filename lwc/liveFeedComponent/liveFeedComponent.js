import { LightningElement } from 'lwc';

export default class LiveFeedComponent extends LightningElement {
    handleFinish() {
        this.dispatchEvent(new CustomEvent('finish'));
    }
}