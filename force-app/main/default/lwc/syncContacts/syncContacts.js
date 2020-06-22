import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSyncContacts from "@salesforce/apex/SyncContactsController.getContactsFromOrgA";

export default class SyncContacts extends LightningElement {

    handleClick() {
        console.log('synchronize');
        getSyncContacts()
            .then(result => {
                console.log(result);
            })
            .catch(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error al sincronizar los contactos !',
                        message: JSON.stringify(result),
                        variant: 'error',
                    }),
                );
            });
    }
}