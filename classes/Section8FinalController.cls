public with sharing class Section8FinalController {
    public List<String> listAllObjects {get;set;}//List all available Objects on Org
    public String inputObject {get; set;}
    public String selectedvalue {get; set;}
    public String objectApiName {get; set;}
    public Schema.SObjectType sobjectType {get; set;}
    public Schema.SObjectType currentObjectType {get; set;}
    public Schema.DescribeSObjectResult currentSObjectResult {get; set;}
    public Boolean isCustomObject {get; set;}
    public Boolean isAccessible {get; set;} //
    public Boolean isCreateable {get; set;} 
    public Boolean isUpdateable {get; set;}
    public Boolean isDeletable {get; set;}
    Map<String, Schema.SObjectType> globalDescribeMap {get; set;}
    public List<InnerClassForCrudOfObject> crudOfObject {get;set;}
    public List<InnerClassForFlsOfObject> flsOfObject {get;set;}
    public String error {get; set;}
    
    public Section8FinalController () {
        listAllObjects = getObjectAPINameToLabel();
    }
    
    public class InnerClassForCrudOfObject{
        public String apiName {get; set;}
        public Boolean isCreatable{get; set;}
        public Boolean isAccessible{get; set;}
        public Boolean isUpdatable{get; set;}
        public Boolean isDeletable{get; set;}
        public InnerClassForCrudOfObject(String apiName, Boolean isCreatable, Boolean isAccessible, Boolean isUpdatable, Boolean isDeletable){
            this.apiName = apiName;
            this.isCreatable = isCreatable;
            this.isAccessible = isAccessible;
            this.isUpdatable = isUpdatable;
            this.isDeletable = isDeletable;
        }
    }
    public class InnerClassForFlsOfObject{
        public String field {get; set;}
        public Boolean isCreatable{get; set;}
        public Boolean isUpdatable{get; set;}
        public InnerClassForFlsOfObject (String field, Boolean isCreatable, Boolean isUpdatable){
            this.field = field;
            this.isCreatable = isCreatable;
            this.isUpdatable = isUpdatable;
        }
    } 
    
    public static List<String> getObjectAPINameToLabel() {
        
        // * Initializing Map
        Map<String, String> objectAPINameToLabelMap = new Map<String, String>();
        // * Getting all sObjects metadata
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        // * Processing each sObject one by one
        for(String globalDescribeKey : globalDescribeMap.keySet()) {
            // * Getting the current sObject type
            Schema.SObjectType currentSObjectType = globalDescribeMap.get(globalDescribeKey);
            // * Getting the current sObject description result from sObject Type
            Schema.DescribeSObjectResult currentSObjectResult = currentSObjectType.getDescribe();
            // * Getting the API name and value of current sObject and adding it to the map
            objectAPINameToLabelMap.put(currentSObjectResult.getName(), currentSObjectResult.getLabel());
        }
        // * Processing each entry of the map one by one and displaying sObject API Name and Label
        for(String objectAPIName : objectAPINameToLabelMap.keySet()) {
            System.debug(objectAPIName + ' --> ' + objectAPINameToLabelMap.get(objectAPIName));
        }
        Set<String> objectAPINameSet = objectAPINameToLabelMap.keySet(); 
        List<String> objectAPINameList = new List<String>(objectAPINameSet);
        objectAPINameList.sort();
        // * Returning the map
        return objectAPINameList; //objectAPINameToLabelMap;
    } 
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        for(String s : listAllObjects){
            options.add(new SelectOption(s, s));
        }
        return options;
    }
    
    public void viewCrudAndFls() {
        try{
        sobjectType = ((SObject) Type.forName(inputObject).newInstance()).getSObjectType();
        DescribeSObjectResult currentSObjectResult = sobjectType.getDescribe();
        objectApiName = currentSObjectResult.getName();
        isCustomObject = currentSObjectResult.isCustom();
        isAccessible = currentSObjectResult.isAccessible();
        isCreateable = currentSObjectResult.isCreateable();
        isUpdateable = currentSObjectResult.isUpdateable();  
        isDeletable = currentSObjectResult.isDeletable();
            
        crudOfObject = new List<InnerClassForCrudOfObject>{
            new InnerClassForCrudOfObject(objectApiName, isCreateable, isAccessible, isUpdateable, isDeletable)
                };
         
            // * Getting Fields for current sObject
        Map<String, Schema.SObjectField> fieldMap = sobjectType.getDescribe().fields.getMap();
        
        flsOfObject = new List<InnerClassForFlsOfObject>();
        
        for (SObjectField field: fieldMap.values()){
            DescribeFieldResult fieldResult = field.getDescribe();
            flsOfObject.add(new InnerClassForFlsOfObject (fieldResult.getName(), fieldResult.isCreateable(), fieldResult.isUpdateable()));
            
        }
            error = null;    
        }catch (Exception ex) {
            error = 'BE ATTENTIVE: Enter Object Name';
            crudOfObject = null;
            flsOfObject = null;
            isAccessible = null;
            objectApiName = null;
            isCustomObject = null;
        }
    }
    
    
}

/*
 List<Contact> contacts = [SELECT Name, Phone FROM Contact];
        System.debug(contacts);
        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, contacts, true);
        System.debug(decision.getModifiedIndexes());
        System.debug(decision.getRecords());
        System.debug(decision.getRemovedFields());
*/