import { LightningElement, api } from 'lwc';
import ASTRO_IMAGE from '@salesforce/resourceUrl/astro2';

export default class ErrorComponent extends LightningElement {
    @api metadata;
    @api permSetExists;
    @api permSetAssigned;
    @api apexTriggers;
    astroImage = ASTRO_IMAGE;
}