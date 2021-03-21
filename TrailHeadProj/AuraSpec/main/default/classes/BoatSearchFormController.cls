public with sharing class BoatSearchFormController {
	@AuraEnabled
    public static List<BoatType__c> getBoatTypes() {
        List<BoatType__c> btList = [SELECT Id, Name FROM BoatType__c];
        return btList;
    }
}