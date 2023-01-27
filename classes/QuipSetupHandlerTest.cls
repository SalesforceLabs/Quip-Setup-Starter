@isTest
private class QuipSetupHandlerTest {

    @isTest static void isQuipAuthOkayTest() {
        try {
            QuipSetupHandler.isQuipAuthOkay();
        } catch (Exception e) {
            return;
        }
    }

    @isTest static void checkApexTriggersTest() {
        QuipSetupHandler.checkNoApexTriggers();
    }
    
}