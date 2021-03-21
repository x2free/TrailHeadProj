public inherited sharing class BoatSearchResult{
	@AuraEnabled
	public static List<Boat__c> getBoatsByType(String boatType){
		List<Boat__c> boats = new List<Boat__c>();

		try{
            String strQuery = 'SELECT Id, Name, Picture__c, contact__r.Name, Geolocation__Latitude__s, Geolocation__Longitude__s '
                + ' FROM Boat__c ';
			if (String.isNotBlank(boatType)){
                strQuery += 'WHERE BoatType__c = :boatType';
			}

            boats = (List<Boat__c>)Database.query(strQuery);
		} catch (Exception e){
			return boats;
		}

		return boats;
	}
}