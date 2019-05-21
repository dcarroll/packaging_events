trigger RedAccountEventTrigger on RedAccountEvent__e (after insert) {

    System.debug('Just heard a red account was triggered.');
    List<RedAccountEvent__e> events = trigger.new;
    List<String> messages = new List<String>();
    List<Id> acctIds = new List<Id>();
    for (RedAccountEvent__e event : events) {
        acctIds.add(event.Account_Id__c);
    }
    Map<Id, Account> accts = new Map<Id, Account>([Select Id, Name, Industry From Account Where Id IN :acctIds]);
    for (RedAccountEvent__e event : events) {
        Account acct = accts.get(event.Account_Id__c);
        String emoji = (event.Rating__c == 'Red') ? ':fire:' : ':white_check_mark:';
        String msg = 'The {0} account status is {1}. \nAs a reminder, this account is in the *_{2}_* industry.';
        messages.add(String.format(msg, new List<Object> {acct.Name, emoji, acct.Industry}));
    }
    SlackNotification.sendSlackNotification(messages);
}