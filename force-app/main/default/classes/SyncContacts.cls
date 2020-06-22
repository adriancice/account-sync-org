public with sharing class SyncContacts {
    public static HttpResponse SyncContacts() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://adrianorga-dev-ed.my.salesforce.com/services/data/v48.0/query/?q=SELECT+Name+,+Title+,+Phone+,+Email+FROM+Contact+limit+10');
        req.setMethod('GET');
        
        // Specify the required header and header information to access the endpoint
        String authorizationHeader = 'Bearer 00D2X000001QbF9!ARIAQFgM8Lv9LsM0txSsjj2PvDRCVipJ_xDzjn7_D8ilzThNXKnKQw26o081QqhhqCq2j3UjqWEbTVuLU0MCCkehyN4R50d9';
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return res;
    }
}
