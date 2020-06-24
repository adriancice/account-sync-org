public with sharing class BatchContact {
    public String ExternalId;
    public String LastName;
    public String Title;
    public String Phone;
    public String Email;

    public BatchContact(String ExternalId, String LastName, String Title, String Phone, String Email) {
        this.ExternalId = ExternalId;
        this.LastName = LastName;
        this.Title = Title;
        this.Phone = Phone;
        this.Email = Email;
    }
}
