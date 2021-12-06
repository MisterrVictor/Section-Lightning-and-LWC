
  import { LightningElement, wire } from 'lwc';
  import getContactList from '@salesforce/apex/ContactController.getContactList';
  import findContacts from '@salesforce/apex/ContactController.findContacts';
  
  const columns = [
    { label: "Name", fieldName: "Name", sortable: "true" },
    { label: "Title", fieldName: "Title" },
    { label: "Department", fieldName: "Department" },
    { label: "Phone", fieldName: "Phone", type: "phone" },
    { label: "Email", fieldName: "Email", type: "email" }
  ];
  export default class Task2 extends LightningElement {
      error;
      contacts;
      columns = columns;
      searchKey = '';
  
      @wire(getContactList) 
      wiredContacts ({ error, data }) {
          if (data) {
              this.contacts = data; 
          } else if (error) { 
              this.error = error;  
          }   
      }
      handleKeyChange(event) {
          this.searchKey = event.target.value;
          findContacts({ searchKey: this.searchKey })
              .then((result) => {
                  this.contacts = result;
                  this.error = undefined;
              })
              .catch((error) => {
                  this.error = error;
                  this.contacts = undefined;
              });
      }
  }