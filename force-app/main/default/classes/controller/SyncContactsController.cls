/**
* @Name SyncContactsController
* @Author Adrian Paul Stan
* @Date Created: 20-06-2020
* @Group Controller
* @Description Controller class for Lightning Web Component 'contactsTable'
*/
public with sharing class SyncContactsController {

    /**
     * @Author Adrian Paul Stan
	 * @Date 20-06-2020
	 * @Description create and execute the batch
	 * @return batchId
	 * @example .sendContactsOrgB()
	 **/
    @AuraEnabled
    public static Id sendContactsOrgB(){
        UpsertContacts2OrgB upsertContacts = new UpsertContacts2OrgB();
        Id batchId = Database.executeBatch(upsertContacts, 2000);

        return batchId;
    }
}
