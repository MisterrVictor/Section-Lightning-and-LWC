public with sharing class lwcSortingDataTableCtrl {

    @AuraEnabled(Cacheable = true)
    public static List<Account> sortAccountList(){
        List<Account> accListObj= [SELECT Id, Name, Phone, Industry, Description, Type, Website 
        FROM Account 
        //Where Phone != null
        LIMIT 10 ];
        return accListObj;
    }
}
