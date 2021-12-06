trigger ContactTrigger on Contact (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        if (ContactTriggerHandler.isFirstTime) {
            ContactTriggerHandler.isFirstTime = false;
            ContactTriggerHandler.updateDepartment(Trigger.new);
        }
    }
}