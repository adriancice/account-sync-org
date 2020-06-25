@isTest
public class UpsertContacts2OrgBTest {
    static testMethod void testMethod1() {
        List<Contact> lstContact= new List<Contact>();
        for(Integer i=0 ;i <200;i++) {
            Contact con = new Contact();
            con.LastName ='Last Name ' + i;
            lstContact.add(con);
        }
        
        insert lstContact;
        
        Test.startTest();

            UpsertContacts2OrgB obj = new UpsertContacts2OrgB();
            Database.executeBatch(obj, 2000);
            
        Test.stopTest();
    }
}
