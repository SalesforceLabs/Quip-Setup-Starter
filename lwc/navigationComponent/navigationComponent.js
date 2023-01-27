import { LightningElement, api } from 'lwc';

export default class NavigationComponent extends LightningElement {
    @api headings;
    @api sections;
    @api selected;
    search = '';
    packageVersion = 'Quip Setup Starter v1.4.0';

    handleSelect(event) {
        this.dispatchEvent(new CustomEvent('selectsection', {
            detail: event.detail
        }));
    };

    handleSearch(event) {
        this.search = event.target.value;
    };

    get headingsWithSections() {
        return this.headings
            .map(h => ({
                ...h,
                sections: this.sections
                    .filter(s => {
                        if (this.search.trim().length === 0) {
                            return true;
                        } else {
                            return s.label.toLowerCase().indexOf(this.search.toLowerCase().trim()) > -1;
                        }
                    })
                    .filter(s => s.heading === h.key)
                    .map(s => ({
                        ...s,
                        selected: s.key === this.selected
                    }))
            }))
            .filter(h => h.sections.length > 0);
    };
}