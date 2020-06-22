public with sharing class SyncContactsController {
    @AuraEnabled(Cacheable = true)
    public static String getContactsFromOrgA(){
        System.debug(SyncContacts.SyncContacts().getBody());
        if(SyncContacts.SyncContacts().getStatusCode() == 200){
            Response2Apex obj = (Response2Apex) JSON.deserialize(SyncContacts.SyncContacts().getBody(), Response2Apex.class);
            System.debug('Total size: ' + obj.totalSize);
            System.debug('Done: ' + obj.done);
            System.debug('Records: ' + obj.records);
            List<Response2Apex.Records> lst = obj.records;      
            for (Response2Apex.Records a : lst) {
                System.debug('Name: ' + a.Name);
                System.debug('Title: ' + a.Title);
                System.debug('Phone: ' + a.Phone);
                System.debug('Email: ' + a.Email);
            }
            Contact c = new Contact();
            c.LastName = 'Stan';
            c.Title = 'CEO';
            c.Phone = '658921456';
            c.Email = 'stan@gmail.com';

            insert c;
        }

        return 'OK';
    }
}
