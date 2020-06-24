public with sharing class ContactTableController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Title, Phone, Email FROM Contact WHERE CreatedDate = THIS_WEEK];
    }
}
