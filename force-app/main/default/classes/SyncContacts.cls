public with sharing class SyncContacts {

    public static HttpResponse SyncContacts() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://adrianorga-dev-ed.my.salesforce.com/services/data/v48.0/query/?q=SELECT+Id,Name,Title,Phone,Email+FROM+Contact+limit+12');
        req.setMethod('GET');
        
        // Specify the required header and header information to access the endpoint
        String authorizationHeader = 'Bearer 00D2X000001QbF9!ARIAQKbje3rQFp4WkiHgbu8oYEs.qACy_PQW2YTzTeujqQJ6l0lOKCOiJcjmAyRw2COErv4MvbVbzzomPqnVY_JXg4yzXUkx';
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('Body ' + res.getBody());
        System.debug('RES ' + res);
        return res;
    }

    public static HttpResponse UpsertContacts(List<Contact> contactList) {
        System.debug('Contact List serialized-> ' + JSON.serialize(contactList));
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://adrianorgb-dev-ed.my.salesforce.com/services/data/v48.0/sobjects/Contact');
        req.setMethod('POST');
        
        // Specify the required header and header information to access the endpoint
        String authorizationHeader = 'Bearer 00D2X000001QbFa!ARgAQON8rCxEJRGxABQMJbLy4p.mGzycFBD9gY5LArk739cXS5VeUeiB27tJijIpquDkcyzcAoUVU7M20RVtS3ko17YH2BNq';
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(contactList));
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request
        Http http = new Http();
        HTTPResponse res = http.send(req);

        return res;
    }

    public static String bulkCreateJob(String accessToken){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://adrianorgb-dev-ed.my.salesforce.com/services/async/48.0/job');
        req.setMethod('POST');
        
        // Specify the required header and header information to access the endpoint
        req.setHeader('X-SFDC-Session', accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('charset', 'UTF-8');
        String body = '{"operation" : "upsert","object" : "Contact","contentType" : "JSON","externalIdFieldName" : "ExternalId__c"}';
        req.setBody(body);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Map<String, String> mapParameters = ((Map<String, String>) JSON.deserialize(res.getBody(), Map<String, String>.class));
        return mapParameters.get('id');
    }

    public static HttpResponse bulkCreateBatch(String accessToken, String jobId){
        List<Contact> lstContact = new List<Contact>();
        for (Contact c : getContacts()) {
            lstContact.add(new Contact(ExternalId__c = c.ExternalId__c, LastName = c.LastName, Title = c.Title, Phone = c.Phone, Email = c.Email));
        }       
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://adrianorgb-dev-ed.my.salesforce.com/services/async/48.0/job/' + jobId + '/batch');
        req.setMethod('POST');
        
        // Specify the required header and header information to access the endpoint
        req.setHeader('X-SFDC-Session', accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('charset', 'UTF-8');
        req.setBody(JSON.serialize(lstContact));
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request
        Http http = new Http();
        HTTPResponse res = http.send(req);

        return res;
    }

    public static HttpResponse bulkCloseJob(String accessToken, String jobId){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://adrianorgb-dev-ed.my.salesforce.com/services/async/48.0/job/' + jobId);
        req.setMethod('POST');
        
        // Specify the required header and header information to access the endpoint
        req.setHeader('X-SFDC-Session', accessToken);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('charset', 'UTF-8');
        String body = '{"state" : "UploadComplete"}';
        req.setBody(body);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request
        Http http = new Http();
        HTTPResponse res = http.send(req);

        return res;
    }

    public static String getAccessToken() {
        // Read metadata with credentials
        ConnectedAppOrgB__mdt customMeta = [SELECT Client_Id__c, Client_Secret__c, Password__c, Username__c FROM ConnectedAppOrgB__mdt];

        // Create http request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        
        // Specify the required header and header information to access the endpoint
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'grant_type=password&' + 
                    'client_id=' + customMeta.Client_Id__c + 
                    '&client_secret=' + customMeta.Client_Secret__c + 
                    '&username=' + customMeta.Username__c +
                    '&password=' + customMeta.Password__c;
        req.setBody(body);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request
        Http http = new Http();
        HTTPResponse res = http.send(req);
        Map<String, String> mapParameters = ((Map<String, String>) JSON.deserialize(res.getBody(), Map<String, String>.class));
        return mapParameters.get('access_token');
    }

    public static List<Contact> getContacts(){
            return [SELECT ExternalId__c, LastName, Title, Phone, Email FROM Contact WHERE CreatedDate = THIS_WEEK];
    }

}
