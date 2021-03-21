({
	onBoatClick : function(component, event, helper) {
		var cmpEvent = component.getEvent("BoatSelect");
        var boatId = event.getSource().get("v.name");
        
        cmpEvent.setParams({"boatId" : boatId});
        cmpEvent.fire();
        
        var appEvent=$A.get("e.c:BoatSelected");
        var boat=component.get("v.boat");

        appEvent.setParams({"boat" : boat});
        
        appEvent.fire();
        
        var mapEvent=$A.get("e.c:PlotMapMarker");

        mapEvent.setParams({"lat": boat.Geolocation__Latitude__s,"lng": boat.Geolocation__Longitude__s});
        mapEvent.fire();
    }
})