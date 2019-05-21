// Async Apex Trigger on CaseChangeEvents
trigger CaseChangeAsyncTrigger on CaseChangeEvent (after insert) {
    System.debug('CaseChangeEventTrigger: ' + Trigger.new.size());

    List<CaseChangeEvent> changes = Trigger.new;
    
    Set<String> caseIds = new Set<String>();
    
    for (CaseChangeEvent change : changes) {
        // Get all RecordIds for this change and add to the set
        List<String> recordIds = change.ChangeEventHeader.getRecordIds();
        caseIds.addAll(recordIds);
    }
    
    // Perform heavy (slow) computation determining Red Account status based on these Case changes
    RedAccountPredictor predictor = new RedAccountPredictor();
    Map<String, boolean> accountsToRedAccountStatus = predictor.predictForCases(new List<String>(caseIds));
    
    // Publish PlatformEvents for Possible Red Accounts
    List<RedAccountEvent__e> redAccountEvents = new List<RedAccountEvent__e>();
    for (String acctId : accountsToRedAccountStatus.keySet()) {
        String rating = accountsToRedAccountStatus.get(acctId) ? 'Red' : 'Green';
		redAccountEvents.add(new RedAccountEvent__e(Account_Id__c=acctId, Rating__c=rating));
    }
    System.debug('RED_ACCT: ' + redAccountEvents);
    EventBus.publish(redAccountEvents);
}