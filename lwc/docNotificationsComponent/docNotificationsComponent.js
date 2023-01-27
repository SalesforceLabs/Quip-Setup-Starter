import { LightningElement } from 'lwc';

export default class DocNotificationsComponent extends LightningElement {
    handleFinish() {
        this.dispatchEvent(new CustomEvent('finish'));
    }
}