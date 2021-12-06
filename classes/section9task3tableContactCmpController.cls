public with sharing class section9task3tableContactCmpController {
    @AuraEnabled
    public static String getRecords() {
    return JSON.serialize([SELECT Id, FirstName, LastName, Email, Phone FROM Contact]);
    }

    @AuraEnabled
    public static String getAccountRecords() {
    return JSON.serialize([SELECT Id, Name, Phone, AnnualRevenue, BillingState From Account]);
    }

    @AuraEnabled
    public static String saveRecordBack(String cont){
        SObject con = (SObject)JSON.deserialize(cont, Sobject.class);
        upsert con;
        return cont;
    }

    @AuraEnabled
    public static String deleteRecordBack(String cont){
        SObject con = (SObject)JSON.deserialize(cont, Sobject.class);
        delete con;
        return cont;
    }

}