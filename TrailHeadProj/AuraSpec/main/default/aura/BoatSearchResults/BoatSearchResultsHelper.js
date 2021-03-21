({
    onSearch: function (component, event, helper) {
        var action = component.get("c.getBoatsByType");
        var type = component.get("v.boatType");
        action.setParams({ boatTypeId: type });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.boats", response.getReturnValue());
            }
            else {
                console.log(JSON.stringify(response));
            }
        });
        $A.enqueueAction(action);
    }
})