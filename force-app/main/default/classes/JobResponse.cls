public with sharing class JobResponse {
    public Integer apexProcessingTime {get;set;} 
	public Integer apiActiveProcessingTime {get;set;} 
	public Double apiVersion {get;set;} 
	public Object assignmentRuleId {get;set;} 
	public String concurrencyMode {get;set;} 
	public String contentType {get;set;} 
	public String createdById {get;set;} 
	public String createdDate {get;set;} 
	public String externalIdFieldName {get;set;} 
	public Boolean fastPathEnabled {get;set;} 
	public String id {get;set;} 
	public Integer numberBatchesCompleted {get;set;} 
	public Integer numberBatchesFailed {get;set;} 
	public Integer numberBatchesInProgress {get;set;} 
	public Integer numberBatchesQueued {get;set;} 
	public Integer numberBatchesTotal {get;set;} 
	public Integer numberRecordsFailed {get;set;} 
	public Integer numberRecordsProcessed {get;set;} 
	public Integer numberRetries {get;set;} 
	public String object_Z {get;set;} // in json: object
	public String operation {get;set;} 
	public String state {get;set;} 
	public String systemModstamp {get;set;} 
	public Integer totalProcessingTime {get;set;} 

	public JobResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'apexProcessingTime') {
						apexProcessingTime = parser.getIntegerValue();
					} else if (text == 'apiActiveProcessingTime') {
						apiActiveProcessingTime = parser.getIntegerValue();
					} else if (text == 'apiVersion') {
						apiVersion = parser.getDoubleValue();
					} else if (text == 'assignmentRuleId') {
						assignmentRuleId = parser.readValueAs(Object.class);
					} else if (text == 'concurrencyMode') {
						concurrencyMode = parser.getText();
					} else if (text == 'contentType') {
						contentType = parser.getText();
					} else if (text == 'createdById') {
						createdById = parser.getText();
					} else if (text == 'createdDate') {
						createdDate = parser.getText();
					} else if (text == 'externalIdFieldName') {
						externalIdFieldName = parser.getText();
					} else if (text == 'fastPathEnabled') {
						fastPathEnabled = parser.getBooleanValue();
					} else if (text == 'id') {
						id = parser.getText();
					} else if (text == 'numberBatchesCompleted') {
						numberBatchesCompleted = parser.getIntegerValue();
					} else if (text == 'numberBatchesFailed') {
						numberBatchesFailed = parser.getIntegerValue();
					} else if (text == 'numberBatchesInProgress') {
						numberBatchesInProgress = parser.getIntegerValue();
					} else if (text == 'numberBatchesQueued') {
						numberBatchesQueued = parser.getIntegerValue();
					} else if (text == 'numberBatchesTotal') {
						numberBatchesTotal = parser.getIntegerValue();
					} else if (text == 'numberRecordsFailed') {
						numberRecordsFailed = parser.getIntegerValue();
					} else if (text == 'numberRecordsProcessed') {
						numberRecordsProcessed = parser.getIntegerValue();
					} else if (text == 'numberRetries') {
						numberRetries = parser.getIntegerValue();
					} else if (text == 'object') {
						object_Z = parser.getText();
					} else if (text == 'operation') {
						operation = parser.getText();
					} else if (text == 'state') {
						state = parser.getText();
					} else if (text == 'systemModstamp') {
						systemModstamp = parser.getText();
					} else if (text == 'totalProcessingTime') {
						totalProcessingTime = parser.getIntegerValue();
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static JobResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JobResponse(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
}
