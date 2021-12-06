public class Section8Task1 {
    public List<Region_Code__mdt> listRegionSettings {get;set;}
    public String numberForCar {get; set;}
    public String lettersFromCustomSettings {get; set;}
    public Boolean isCheckedUser;
    public Boolean isCheckedCustomSettings;
    public Integer lastNumberForCarRegion {get; set;}
    public User user {get; set;}
    public String error {get; set;}
    public String error2 {get; set;}
    public String savedNumberToUser {get; set;}
    public List<User> allUsersWithoutNumber {get; set;}
    public String userCity {get; set;}
    
    public Section8Task1() {
        listRegionSettings = [SELECT MasterLabel, NumberOfRegion__c, Region__c,  Region__r.Label FROM Region_Code__mdt ORDER BY NumberOfRegion__c ASC];
    }
    
    public void singleGenerateNumber(){
        userCity();
        generateNumber(); 
    }
    
    public void generateNumber(){
        if (checkCustomSettings() == true && userRegion() != null) {
            numberForCar = createRandomNumber() + ' ' + lettersFromCustomSettings + '-' + userRegion(); //'0000 AA-0';
        }else{
            numberForCar = createRandomNumber() + ' ' + generateRandomString() + '-' + userRegion();
        }
    }
    
    public void saveNumber() {
        List <User> usersAutoNumber = [
            SELECT FirstName, LastName, CarNumber__c, City
            FROM User
            WHERE CarNumber__c =: numberForCar];
        if (numberForCar != null && usersAutoNumber.size() == 0 && userRegion() != null) {
            user.CarNumber__c = numberForCar;
            savedNumberToUser = numberForCar;
            update user;
        } else {
            error2 = 'SORRY THIS NUMBER IS NOT AVAILABLE, PLEASE CHECK the DATA and GENERATE NUMBER AGAIN';
        }
    }
    
    public Integer createRandomNumber() {
        Integer randomNumber = Integer.valueOf(Math.floor(Math.random() * (9999 - 1000 + 1)) + 1000);
        return randomNumber;
    }
    
    public Boolean checkCustomSettings(){
        Hierarchy__c customSet = Hierarchy__c.getInstance();
        if (customSet.LettersForNumber__c != null) {
            isCheckedCustomSettings = true;
            lettersFromCustomSettings = customSet.LettersForNumber__c;
        } else {
            isCheckedCustomSettings = false;
        }
        return isCheckedCustomSettings;
    }
    
    
    public static String generateRandomString() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String randomTwoLetters = '';
        while (randomTwoLetters.length() < 2) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randomTwoLetters += chars.substring(idx, idx+1);
        }
        return randomTwoLetters; 
    }
    
    public String userCity(){
        String userId =  UserInfo.getUserId();
        user = [SELECT Id, FirstName, LastName, City
                FROM User
                WHERE Id =: userId
               ];
        return userCity = user.City;
    }
    
    public Integer userRegion() {
        List<RegionCity__mdt> currentCityList = [SELECT Id, MasterLabel, Region__c 
                                                 FROM RegionCity__mdt
                                                 WHERE  MasterLabel =: userCity 
                                                ];    
        if (currentCityList.size() != 0 ) {   
            for (Region_Code__mdt numberOfRegion : Region_Code__mdt.getall().values()){
                for (RegionCity__mdt listOfCity : currentCityList){
                    if (numberOfRegion.Region__c == listOfCity.Region__c) {
                        lastNumberForCarRegion = Integer.valueOf(numberOfRegion.NumberOfRegion__c);  
                    }
                }
            }
            return lastNumberForCarRegion;
        } else {
            error = 'BE ATTENTIVE: NOT FOUND THE CITY FROM USER';
            return null;
        }
    }
    
    public void generateNumberForAllUsers(){
        List<String> cities = new List<String>();
        for (RegionCity__mdt listOfCity : RegionCity__mdt.getall().values()){
            cities.add(listOfCity.MasterLabel);   
        }
        allUsersWithoutNumber = [
            SELECT Id, FirstName, LastName, CarNumber__c, City
            FROM User
            WHERE CarNumber__c = null AND City != null AND City =: cities
        ];
        
        for (User user : allUsersWithoutNumber) {
            userCity = user.City;
            generateNumber();
            if (numberForCar != null) {
                user.CarNumber__c = numberForCar;
                savedNumberToUser = numberForCar;
                update allUsersWithoutNumber;
            } else {
                error2 = 'SORRY THIS NUMBER IS NOT AVAILABLE, PLEASE CHECK the DATA and GENERATE NUMBER AGAIN';
            }
        }
    }
}    


//SELECT Id, Region__c, Region__r.Label, NumberOfRegion__c, MasterLabel, Label, QualifiedApiName, FROM Region_Code__mdt
/*List<Region_Code__mdt> mcs = Region_Code__mdt.getall().values(); System.debug('mcs ' + mcs);
for (Region_Code__mdt item : mcs){
System.debug(item.Region__r.MasterLabel);
System.debug(item.QualifiedApiName);
System.debug(item.Region__c);
System.debug(item.NumberOfRegion__c);
}

String userId =  UserInfo.getUserId();
public User user = [SELECT Id, FirstName, LastName, City
FROM User
WHERE Id =: userId
];
System.debug(user.City);       
List<RegionCity__mdt> regions = [SELECT Id, MasterLabel, Region__c
FROM RegionCity__mdt
WHERE  MasterLabel =: user.City
];    

System.debug(regions);
style="color:red; text-decoration:underline; padding:20px;"
*/