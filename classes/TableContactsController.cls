public with sharing class TableContactsController {
    @AuraEnabled
    public static String getContacts() {
        try {
            List<Contact> contacts = [
                    SELECT Id, Name, AccountId, Department, CreatedDate, Phone, Account.Name, Email, Confidential__c
                    FROM Contact
                    WHERE AccountId != null
                    AND Department != null
                    ORDER BY CreatedDate DESC
                    LIMIT 50000
            ];
            return JSON.serialize(contacts);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
  
    
    @AuraEnabled
    public static String createContact(String name, String department) {
        try {
            List<Account> allAccounts =
            [
                    SELECT Id, Name, (
                            SELECT Id, LastName, AccountId FROM Contacts
                    )
                    FROM Account
                    LIMIT 50000
            ];
            Account accWithMinContacts = new Account();
            Contact newContact = new Contact();
            if (allAccounts.size() != 0) {
                accWithMinContacts = allAccounts[0];
                for (Account acc : allAccounts) {
                    if (accWithMinContacts.Contacts.size() > acc.Contacts.size()) {
                        accWithMinContacts = acc;
                    } else if (accWithMinContacts.Contacts.size() == acc.Contacts.size()) {
                        if (accWithMinContacts.Name > acc.Name) {
                            accWithMinContacts = acc;
                        }
                    }
                }
            }
            newContact.AccountId = accWithMinContacts.Id;
            newContact.LastName = name;
            newContact.Department = department;
            insert newContact;
            String newTable = getContacts();
            return newTable;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}