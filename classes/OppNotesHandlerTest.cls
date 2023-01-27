@isTest
private class OppNotesHandlerTest {
    
    @isTest static void checkTabPositioningOnPageTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        OppNotesHandler.checkTabPositioningOnPage('', true, 'Apex__Test');
        OppNotesHandler.checkTabPositioningOnPage('00000000000000', true, 'Apex__Test2');
        OppNotesHandler.checkTabPositioningOnPage('00000000000000', false, 'Apex__Test2');
    }

    @isTest static void checkTabPositioningOnPageExistingTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIRecordHttpCalloutMock());
        OppNotesHandler.checkTabPositioningOnPage('', true, 'Apex__Test');
        OppNotesHandler.checkTabPositioningOnPage('00000000000000', true, 'Apex__Test');
        OppNotesHandler.checkTabPositioningOnPage('00000000000000', false, 'Apex__Test');
    }

    @isTest static void checkIfPageExistsTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        OppNotesHandler.checkIfPageExists('', false);
    }

    @isTest static void checkIfPageExistsExistingTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIRecordHttpCalloutMock());
        OppNotesHandler.checkIfPageExists('Test', false);
        OppNotesHandler.checkIfPageExists('Test', true);
    }

    @isTest static void deployFlowTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        OppNotesHandler.deployFlow('Account', 'Website', 'https://quip.com/test', 'none');
    }

    @isTest static void deployOppNotesTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        OppNotesHandler.deployOppNotes('Account', 'Website', true, 'https://quip.com/test', 'test', false, 'Test', 'none');
        OppNotesHandler.deployOppNotes('Account', 'Website', true, 'https://quip.com/test', 'test', true, 'Test', 'none');
    }

    @isTest static void checkRunsTest() {
        OppNotesHandler.storeRun('Opportunity', 'Name', 'creation', true, '0051234567890', 1234567890, true, 'Account Plan', 'https://quip.com/test');
        OppNotesHandler.getLastRun();
    }

}