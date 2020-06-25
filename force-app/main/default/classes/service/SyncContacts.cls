/**
* @Name SyncContacts
* @Author Adrian Paul Stan
* @Date Created: 20-06-2020
* @Group Service
* @Description Service class. Manage the calls to webService and the data that I storage of the web service response.
*/
public with sharing class SyncContacts {

	/**
     * @Author Adrian Paul Stan
	 * @Date 20-06-2020
	 * @Description call to endpoint that returns the access token
	 * @return access token
	 * @example .getAccessToken()
	 **/
    public static String getAccessToken() {
        // Read metadata fields that contain credentials of Connected App from Org B
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

        // Read the access token value and return it
        Map<String, String> mapBody = ((Map<String, String>) JSON.deserialize(res.getBody(), Map<String, String>.class));
        return mapBody.get('access_token');
    }

    /**
     * @Author Adrian Paul Stan
	 * @Date 20-06-2020
	 * @Description Create a new job that upsert the contacts with ExternalId__c field
     * @param accessToken token for authentication
	 * @return job Id
	 * @example .bulkCreateJob(accessToken)
	 **/
    public static String bulkCreateJob(String accessToken){        
        //Create http request
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

        // Read the job Id value and return it
        Map<String, String> mapParameters = ((Map<String, String>) JSON.deserialize(res.getBody(), Map<String, String>.class));
        return mapParameters.get('id');
    }

    /**
     * @Author Adrian Paul Stan
	 * @Date 20-06-2020
	 * @Description Create new batch for the jobId with the contacts from the list
     * @param accessToken token for authentication
     * @param jobId job Id to create new batches
     * @param scope list with the contacts to upsert
	 * @return HttpResponse res
	 * @example .bulkCreateBatch(accessToken, jobId, scope)
	 **/
    public static HttpResponse bulkCreateBatch(String accessToken, String jobId, List<Contact> scope){
        // Create new list with the contacts without Salesforce Id
        List<Contact> lstContact = new List<Contact>();
        for (Contact c : scope) {
            lstContact.add(new Contact(ExternalId__c = c.ExternalId__c, LastName = c.LastName, Title = c.Title, Phone = c.Phone, Email = c.Email));
        }
        //Create http request
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

    /**
     * @Author Adrian Paul Stan
	 * @Date 20-06-2020
	 * @Description Close the job
     * @param accessToken token for authentication
     * @param jobId job Id to close
	 * @return HttpResponse res
	 * @example .bulkCloseJob(accessToken, jobId)
	 **/
    public static HttpResponse bulkCloseJob(String accessToken, String jobId){
        //Create http request
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

}
