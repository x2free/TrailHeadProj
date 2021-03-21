public without sharing class BoatSearchResults {
    @AuraEnabled
	public static List<Boat__c> getBoats(String boatTypeId){
		List<Boat__c> boats = new List<Boat__c>();

		try{
            String strQuery = 'SELECT Id, Name, Picture__c, contact__r.Name, Geolocation__Latitude__s, Geolocation__Longitude__s '
                + ' FROM Boat__c ';
			if (String.isNotBlank(boatTypeId)){
                strQuery += 'WHERE BoatType__c = :boatTypeId';
			}

            boats = (List<Boat__c>)Database.query(strQuery);
		} catch (Exception e){
			return boats;
		}

		return boats;
	}
}