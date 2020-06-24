global with sharing class UpsertContacts2OrgB implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT LastName, Title, Phone, Email
            FROM Contact
            LIMIT 4
        ]);
    }
    global void execute(Database.BatchableContext bc, List<Contact> scope){
        // process each batch of records
        System.debug('###### ' + scope);
        HttpResponse res = SyncContacts.UpsertContacts(scope);
        recordsProcessed = recordsProcessed + scope.size();
    }    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        //EmailUtils.sendMessage(job, recordsProcessed);
    }    
}
