/**
* @Name ContactTableController
* @Author Adrian Paul Stan
* @Date Created: 20-06-2020
* @Group Controller
* @Description Controller class created for Lightning Web Component 'contactsTable'
*/
public with sharing class ContactTableController {
    /**
     * @Author Adrian Paul Stan
	 * @Date 20-06-2020
	 * @Description method that return a list of Contacts that have been created this week
	 * @return List<Contact>
	 * @example .getContacts()
	 **/
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Title, Phone, Email FROM Contact WHERE CreatedDate = THIS_WEEK];
    }
}
