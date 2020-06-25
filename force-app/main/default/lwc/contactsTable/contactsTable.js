import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendContacts from "@salesforce/apex/SyncContactsController.sendContactsOrgB";
import getContacts from '@salesforce/apex/ContactTableController.getContacts';

const columns = [
    { label: 'Contact Name', fieldName: 'oppLink', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, tooltip: 'Go to detail page', target: '_blank' } },
    { label: 'Title', fieldName: 'Title', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Email', fieldName: 'Email', type: 'email' },
];
export default class ContactsTable extends LightningElement {
    @track error;
    @track columns = columns;
    @track accs; //All accounts available for data table    
    @track showTable = false; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track rowNumberOffset; //Row number

    @wire(getContacts)
    wopps({ error, data }) {
        if (data) {
            let recs = [];
            for (let i = 0; i < data.length; i++) {
                let opp = {};
                opp.rowNumber = '' + (i + 1);
                opp.oppLink = '/' + data[i].Id;
                opp = Object.assign(opp, data[i]);
                recs.push(opp);
            }
            this.accs = recs;
            this.showTable = true;
        } else {
            this.error = error;
        }
    }
    //Capture the event fired from the paginator component
    handlePaginatorChange(event) {
        this.recordsToDisplay = event.detail;
        this.rowNumberOffset = this.recordsToDisplay[0].rowNumber - 1;
    }

    handleClick() {
        sendContacts()
            .then(result => {
                console.log('Batch Id created: ' + result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!',
                        message: 'Se han enviado los contactos a la Org B!',
                        variant: 'success',
                    }),
                );
            })
            .catch(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error al batchear los contactos !',
                        message: JSON.stringify(result),
                        variant: 'error',
                    }),
                );
            })
    }
}