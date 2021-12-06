public with sharing class ContactController {
    @AuraEnabled
    public static String getAccounts(){
        List<Account> accounts = 
            [SELECT Id, Name, Phone, AnnualRevenue, BillingState From Account];
        return JSON.serialize(accounts);
    }

    @AuraEnabled
    public static String searchAccountByNameBack(String nameSegment){
        String nameSegmentSoql = '%' + nameSegment + '%';
        List<Account> accounts = 
            [SELECT Id, Name, Phone, AnnualRevenue, BillingState From Account
             WHERE Name LIKE :nameSegmentSoql
            ];
        return JSON.serialize(accounts);
    }

    @AuraEnabled
    public static String searchAccountByIdBack(String nameSegment){
        System.debug('nameSegment');
        Id myId = Id.valueOf(nameSegment);
        System.debug('myId' + myId);
        List<Account> accounts = 
            [SELECT Id, Name, Phone, AnnualRevenue, BillingState From Account
             WHERE Id =: myId
            ];
        return JSON.serialize(accounts);
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT Id, Name, Title, Phone, Email, Department
            FROM Contact
            //WHERE Picture__c != NULL
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, Department
            FROM Contact
            WHERE Name LIKE :key // AND Picture__c != NULL
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getSingleContact() {
        return [
            SELECT Id, Name, Title, Phone, Email, Department
            FROM Contact
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
}