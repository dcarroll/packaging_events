@isTest
public with sharing class TestCaseChangeTrigger {
    @isTest static void testChangeEventTrigger() {
        // Enable all Change Data Capture entities for notifications.
        Test.enableChangeDataCapture();
    
        // Insert one or more test records
        Case c = new Case();
        insert c;
        
        // Deliver test change events
        Test.getEventBus().deliver();
        
        // Verify the change event trigger’s execution
        // ...
    }
}
