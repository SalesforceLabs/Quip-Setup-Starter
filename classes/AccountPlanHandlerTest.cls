@isTest
private class AccountPlanHandlerTest {
    
    @isTest static void checkTabPositioningOnPageTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        AccountPlanHandler.checkTabPositioningOnPage('', true, 'Apex__Test');
        AccountPlanHandler.checkTabPositioningOnPage('00000000000000', true, 'Apex__Test2');
        AccountPlanHandler.checkTabPositioningOnPage('00000000000000', false, 'Apex__Test2');
    }

    @isTest static void checkTabPositioningOnPageExistingTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIRecordHttpCalloutMock());
        AccountPlanHandler.checkTabPositioningOnPage('', true, 'Apex__Test');
        AccountPlanHandler.checkTabPositioningOnPage('00000000000000', true, 'Apex__Test');
        AccountPlanHandler.checkTabPositioningOnPage('00000000000000', false, 'Apex__Test');
    }

    @isTest static void checkIfPageExistsTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        AccountPlanHandler.checkIfPageExists('', false);
    }

    @isTest static void checkIfPageExistsExistingTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIRecordHttpCalloutMock());
        AccountPlanHandler.checkIfPageExists('Test', false);
        AccountPlanHandler.checkIfPageExists('Test', true);
    }

    @isTest static void deployFlowTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        AccountPlanHandler.deployFlow('Account', 'Website', 'https://quip.com/test', 'none');
    }

    @isTest static void deployAccountPlanTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        AccountPlanHandler.deployAccountPlan('Account', 'Website', true, 'https://quip.com/test', 'test', false, 'Test', 'none');
        AccountPlanHandler.deployAccountPlan('Account', 'Website', true, 'https://quip.com/test', 'test', true, 'Test', 'none');
    }

    @isTest static void checkRunsTest() {
        AccountPlanHandler.storeRun('Account', 'Name', 'creation', true, '0051234567890', 1234567890, true, 'Account Plan', 'https://quip.com/test');
        AccountPlanHandler.getLastRun();
    }

}