({
    doInit:function(component, event, helper){
      helper.onInit(component, event);  
    },
	onSave : function(component, event, helper) {        
        component.set("v.boatReview.Boat__c", component.get("v.boat").Id);
        
        component.find("service").saveRecord(function(saveResult){
            if(saveResult.state === "SUCCESS" || saveResult.state === "DRAFT")
            {
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast){
                    resultsToast.setParams({
                        "title":"Submitted",
                        "message":"The review was saved."
                    });
                    resultsToast.fire();
                } else {
                    alert("The review was saved.");
                }
            }
             
            var boatReviewAddedEvent = component.getEvent("boatReviewAdded");
            boatReviewAddedEvent.fire();            
            //helper.onInit(component, event);
        });
	},
    onRecordUpdated : function(component, event, helper) {
		var eventParams=event.getParams();
        if(eventParams.changeType==="CHANGED"){
            var changedFields = eventParams.changedFields;
            var saveResultsToast = $A.get("e.force:showToast");
            if(saveResultsToast != 'undefined')
            {
                saveResutlsToast.setParams({
                    "title":"Saved",
                    "message":"Boat Review Saved"
                });
                saveResultsToast.fire();
            }
            else {
                alert("Boat Review Saved");
            }
        }
	}
})