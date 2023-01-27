import { LightningElement, api } from 'lwc';

export default class NavigationItem extends LightningElement {
    @api section;

    handleClick() {
        this.dispatchEvent(new CustomEvent('select', {
            detail: this.section.key
        }));
    }
}