/**
* @Name UpsertContacts2OrgB
* @Author Adrian Paul Stan
* @Date Created: 20-06-2020
* @Group Batchable
* @Description Class that implements Batchable Interface
*/
global with sharing class UpsertContacts2OrgB implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global String jobId;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT ExternalId__c, LastName, Title, Phone, Email
            FROM Contact
            WHERE CreatedDate = THIS_WEEK
        ]);
    }
    global void execute(Database.BatchableContext bc, List<Contact> scope){
        // process each batch of records

        // Create a new job and save the jobId
        // If the job exist we don´t create it
        if (jobId == null) {
            jobId = SyncContacts.bulkCreateJob(SyncContacts.getAccessToken());
        }

        // Create the batch for the jobId
        SyncContacts.bulkCreateBatch(SyncContacts.getAccessToken(), jobId, scope);

        recordsProcessed = recordsProcessed + scope.size();
    }    
    global void finish(Database.BatchableContext bc){
        //Close the job
        SyncContacts.bulkCloseJob(SyncContacts.getAccessToken(), jobId);

        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        System.debug(job);
        // call some utility to send email
        //EmailUtils.sendMessage(job, recordsProcessed);
    }    
}
