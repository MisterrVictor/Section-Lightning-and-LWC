import { LightningElement, api, wire, track} from 'lwc';
import sortAccountItem from '@salesforce/apex/lwcSortingDataTableCtrl.sortAccountList';

export default class Task3cmp3 extends LightningElement {
    @track data;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;
    @wire(sortAccountItem)
     
 
    handleSortData(event) {       
        this.sortBy = event.detail.fieldName;       
        this.sortDirection = event.detail.sortDirection;       
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }
 
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
 
       let isReverse = direction === 'asc' ? 1: -1;
           parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
           
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }
}