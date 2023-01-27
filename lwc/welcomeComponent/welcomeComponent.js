import { LightningElement } from 'lwc';
import ASTRO_IMAGE from '@salesforce/resourceUrl/astro';

export default class WelcomeComponent extends LightningElement {
    astroImage = ASTRO_IMAGE;
}