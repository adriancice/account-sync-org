@isTest
public with sharing class ContactTableControllerTest {
	@testSetup
	static void setup() {
        List<Contact> contacts = new List<Contact>();
        for (Integer count = 0; count < 100; count++) {
            contacts.add(new Contact (LastName = 'Adrian ' + count, Title = 'Technology' , Phone ='00000000' + count, Email = 'Adrian' + count + '@gmail.com'));
        }            
        insert contacts;
    }
    @isTest
	static void getContactsTest() {
        Test.startTest();
        ContactTableController.getContacts();
        Test.stopTest();
        Contact contact = [SELECT LastName FROM Contact LIMIT 1];
        System.assertEquals ( contact.LastName , 'Adrian 0');
    }
}
