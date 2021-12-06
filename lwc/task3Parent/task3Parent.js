import { LightningElement, track} from 'lwc';

export default class Task3Parent extends LightningElement {
    myData  = [
        {Id: 1,}, {Id: 2,}, {Id: 3,},
       // {Id: 4,},{Id: 5,},{Id: 6,},{Id: 7,},{Id: 8,},{Id: 9,},{Id: 10,},
    ];

    @track selectedNumber;

    // @track arr = [];
    // connectedCallback(){
    //     for (var i = 1; i < 10; i++) {
    //         arr.push({
    //             Id: [i],
    //         });
    //     }
    // }
    
    numberSelected(event) {
        this.selectedNumber = event.detail;
    }

}