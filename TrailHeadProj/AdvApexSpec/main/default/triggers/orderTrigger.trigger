/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (after update) {
    // try {
    if (Trigger.isAfter && Trigger.isUpdate) {
        OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
    }
    // }catch ( Exception e ){
    
    // }
}