@isTest
public with sharing class SyncContactsTest {
    static List<Contact> lst = new List<Contact>();
    @isTest
	static void sendContactsTest() {

        RequestMock fakeResponse = new RequestMock(200,
                                            'OK',
                                            '{"access_token":"00D2X000001QbFa!ARgAQLlC50nc13Y84TxDMh1QvpyWRAq2.hk9gHtD6dZkpZqdKTmVIgt4CT2bm3SWOhBsuMHEbwaGB16T1Q5PlZOWZEkVHVjE"}',
                                            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        String token = SyncContacts.getAccessToken();
        System.debug('RESSSSSS::::: ' + token);
        SyncContacts.bulkCreateJob('accessToken');
        SyncContacts.bulkCreateBatch('accessToken', 'jobId', lst);
        SyncContacts.bulkCloseJob('accessToken', 'jobId');      
        //System.assertEquals(/*check for expected results here...*/);
    }
}
