({
    doSearch: function (component, event, helper) {
        helper.onSearch(component, event, helper);
    },
    onBoatSelect: function (component, event, helper) {
        var boatId = event.getParam("boatId");
        component.set("v.selectedBoatId", boatId);
    },
    search: function (component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            component.set("v.boatType", params.boatType);

            helper.onSearch(component);
            return "Done";
        }
    }
})