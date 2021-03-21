({
	doInit : function(component, event, helper) {        
        var eventParams = event.getParams();
    
        helper.getBoatTypes(component);
        helper.checkAble2CreateRecord(component);
	},
    onBoatTypeChange : function(component, event, helper){
        var boatTypeId = component.find("boatTypes").get("v.value");
        component.set("v.selectedBoatType",boatTypeId);
    },
	onFormSubmit : function(component, event, helper){
		var boatTypeId = component.get("v.selectedBoatType"); 
		var formSubmit = component.getEvent("formSubmit");
        
		formSubmit.setParams(
			{"formData": 
				{"boatTypeId": boatTypeId}
			});
		formSubmit.fire();
	},
	createBoat : function(component, event, helper){
		var boatTypeId = component.find("boatTypes").get("v.value");
		
        if(!boatTypeId){
			boatTypeId = null;
		}		
	
		var createRecordEvent = $A.get("e.force:createRecord");
		createRecordEvent.setParams({
			"entityApiName":"Boat__c",
			"defaultFieldValues": {
				'BoatType__c': boatTypeId
				}
			});
		createRecordEvent.fire();
	}
})