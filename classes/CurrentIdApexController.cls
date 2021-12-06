public with sharing class CurrentIdApexController {

    @AuraEnabled
  public static String getContactsCurrentAccountBack(String currentAccountId) {
    Id currentId = (Id)
 JSON.deserialize(currentAccountId, Id.class);

    List<Account> currentAccounts = [
      SELECT (SELECT FirstName, LastName, Phone FROM Contacts)
      FROM Account
      WHERE Id = :currentId
    ];

    List<Contact> listContacts = new List<Contact>();
    for (Account i : currentAccounts) {
      for (Contact item : i.Contacts) {
        listContacts.add(item);
      }
    }

    return JSON.serialize(listContacts);
  }
}