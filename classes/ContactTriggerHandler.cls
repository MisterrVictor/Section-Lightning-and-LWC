public with sharing class ContactTriggerHandler {
    public static Set<id> newAccountId = new Set<id>();
    public static Boolean isFirstTime = true;

    public static void updateDepartment(List<Contact> newContacts) {
        List<Contact> contactsForUpdate = new List<Contact>();
        List<Contact> contactsForInsert = new List<Contact>();

// При создании нового Contact, у всех Contacts, имеющих тот же AccountId,
// необходимо заполнить поле Department (обновить), как и у свежесозданного контакта. 
         for(Contact newCont : newContacts){ //Set AccountId from trigger.New
            newAccountId.add(newCont.AccountId); 

         }
        List<Contact> ListAllContacts = [ //List All Contacts from DB WHERE AccountId IN : newAccountId
                SELECT Id, FirstName, LastName, AccountId, Department
                FROM Contact
                WHERE AccountId IN : newAccountId
            ];

        for (Contact contact : ListAllContacts) {//все Contacts, имеющих тот же AccountId,
            for(Contact newCont : newContacts){
                if(contact.AccountId == newCont.AccountId){
                    if(contact.Department != newCont.Department){
                    contact.Department = newCont.Department;
                    contactsForUpdate.add(contact);
                    //Для каждого AccountId, Contacts которого были обновлены, создать новую запись Contact    
                    Contact newContact = new Contact(LastName = 'Confidential Contact', Confidential__c ='Private info', AccountId = contact.AccountId);
                    contactsForInsert.add(newContact);
                    }
                }
            }

        }            
        update contactsForUpdate;
        insert contactsForInsert;
    }
}