@isTest
private class AutoFolderHandlerTest {
    
    @isTest static void setupFolderOrganizationTest() {

        Test.setMock(HttpCalloutMock.class, new QuipAPIHttpCalloutMock());
        AutoFolderHandler.setupFolderOrganization('Account', 'Website', true, 'Apex__Test', 'Account', 'Website', false);
        AutoFolderHandler.setupFolderOrganization('Account', 'Website', false, 'https://quip.com/Apex__Test', 'Account', 'Website', false);
        AutoFolderHandler.setupFolderOrganization('Account', 'Website', true, 'Apex__Test', 'Account', 'Website', true);
        AutoFolderHandler.setupFolderOrganization('Account', 'Website', false, 'https://quip.com/Apex__Test', 'Account', 'Website', true);

    }

    @isTest static void checkRunsTest() {
        AutoFolderHandler.storeRun('Account', 'Name', 'Account Plan', 'https://quip.com/test', '', '', 1234567890);
        AutoFolderHandler.getLastRun();
    }

}