/**
* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
* @Name SyncContactsController
* @Author Adrian Paul Stan
* @Date Created: 20-06-2020
* @Group Controller
* @Description Controller class for component 
*/
public with sharing class SyncContactsController {
    static String JobID2;

    @AuraEnabled
    public static String getContactsFromOrgA(){
        Integer recordProcessed;
        System.debug(SyncContacts.SyncContacts().getBody());
        HttpResponse res = SyncContacts.SyncContacts();
        if(res.getStatusCode() == 200){
            Response2Apex obj = (Response2Apex) JSON.deserialize(res.getBody(), Response2Apex.class);
            recordProcessed = obj.totalSize;
            List<Response2Apex.Records> lst = obj.records; 
            List<Contact> contactList = new List<Contact>();    
            for (Response2Apex.Records a : lst) {
                contactList.add(new Contact(LastName = a.Name, Title = a.Title, Phone = a.Phone, Email = a.Email));
            }            
            System.debug('Contact LIST-> ' + contactList);
            insert contactList;
        }else {
            System.debug('ERROR ' + res);
            return 'ERROR ' + res;
        }
        return 'OK ' + recordProcessed;
    }

    @AuraEnabled
    public static String sendContactsToOrgB(){
        String status;
        // Create the job and save the jobId
        String jobId = SyncContacts.bulkCreateJob(SyncContacts.getAccessToken());
        JobID2 = jobId;
        // Create the batch for the jobId
        SyncContacts.bulkCreateBatch(SyncContacts.getAccessToken(), jobId);

        return 'OK';
    }

    @AuraEnabled
    public static String upsertContacts(){
        UpsertContacts2OrgB batchable = new UpsertContacts2OrgB();
        Database.executeBatch(batchable);
        return 'batchable OK';
    }
}
