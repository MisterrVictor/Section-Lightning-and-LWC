import { LightningElement, api } from 'lwc';

export default class Clock extends LightningElement {
    timestamp = new Date();

    @ api timerId = setInterval(() => refresh(), 2000);

    @api
    refresh() {
        this.timestamp = new Date();
        console.log('time -- ' + this.timestamp);
    }
}