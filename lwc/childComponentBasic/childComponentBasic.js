import { LightningElement,api } from 'lwc';

export default class ChildComponentBasic extends LightningElement {
    @api mydata;

    handleClick() {
        // Creates the event with the contact ID data.
        const selectedEvent = new CustomEvent('selected', {detail: this.mydata.Id});

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}