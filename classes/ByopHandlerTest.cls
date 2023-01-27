@isTest
private class ByopHandlerTest {
    
    @isTest static void checkTabPositioningOnPageTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ByopHandler.checkTabPositioningOnPage('', true, 'Apex__Test');
        ByopHandler.checkTabPositioningOnPage('00000000000000', true, 'Apex__Test2');
        ByopHandler.checkTabPositioningOnPage('00000000000000', false, 'Apex__Test2');
    }

    @isTest static void checkTabPositioningOnPageExistingTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIRecordHttpCalloutMock());
        ByopHandler.checkTabPositioningOnPage('', true, 'Apex__Test');
        ByopHandler.checkTabPositioningOnPage('00000000000000', true, 'Apex__Test');
        ByopHandler.checkTabPositioningOnPage('00000000000000', false, 'Apex__Test');
    }

    @isTest static void checkIfPageExistsTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ByopHandler.checkIfPageExists('', false, 'Apex__Test');
    }

    @isTest static void checkIfPageExistsExistingTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIRecordHttpCalloutMock());
        ByopHandler.checkIfPageExists('Test', false, 'Apex__Test');
        ByopHandler.checkIfPageExists('Test', true, 'Apex__Test');
    }

    @isTest static void deployFlowTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ByopHandler.deployFlow('Account', 'Website', 'https://quip.com/test', 'none', 'Apex__Test');
    }

    @isTest static void deployProcessTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ByopHandler.deployProcess('Account', 'Website', 'https://quip.com/test', 'test', false, 'Test', 'none');
        ByopHandler.deployProcess('Account', 'Website', 'https://quip.com/test', 'test', true, 'Test', 'none');
    }

    @isTest static void checkRunsTest() {
        ByopHandler.storeRun('Account', 'Name', 'creation', true, '0051234567890', 1234567890, 'Account Plan', 'https://quip.com/test');
        ByopHandler.getLastRun();
    }

}