@isTest
private class UtilsTest {

    @isTest static void getSessionIdFromVFPageTest() {
        String sessionId = Utils.getSessionIdFromVFPage(Page.SessionPage);
        System.assertEquals('', sessionId);
    }

    @isTest static void toolingQueryTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());

        Map<String, Object> results = Utils.toolingQuery('SELECT Id FROM FlexiPage');
        System.assert(results.isEmpty());
    }

    @isTest static void toolingObjectTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());

        Map<String, Object> results = Utils.toolingObject('Account', '001123456789012');
        System.assert(results.isEmpty());
    }

    @isTest static void toolingObjectMetadataTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());

        ToolingService.Flow results = (ToolingService.Flow) Utils.toolingObjectMetadata('Flow', '301123456789012', ToolingService.Flow.class);
        System.assertEquals('Test', results.fullName);
    }

    @isTest static void updateToolingObjectMetadataTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());

        ToolingService.Flow flow = new ToolingService.Flow();
        flow.fullName = 'Test_Flow';

        Utils.updateToolingObjectMetadata('Flow', '301123456789012', flow);
        
    }
    
    @isTest static void createToolingObjectTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());

        ToolingService.Flow flow = new ToolingService.Flow();
        flow.fullName = 'Test_Flow';

        String newId = Utils.createToolingObject('Flow', flow);
        System.assertEquals('301123456789012', newId);
    }

    @isTest static void createMetadataServiceTest() {
        MetadataService.MetadataPort service = Utils.createMetadataService();
    }

    @isTest static void getOrgObjectsTest() {
        List<Map<String, String>> orgObjects = Utils.getOrgObjects();
        
        Boolean foundAccount = false;
        for (Map<String, String> obj : orgObjects) {
            if (obj.get('value') == 'Account') {
                foundAccount = true;
                break;
            }
        }

        System.assert(foundAccount);
    }

    @isTest static void getRecordPagesTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());

        List<Map<String, String>> pages = Utils.getRecordPages('Account_Test');
        System.assertEquals(1, pages.size());
    }

    @isTest static void getReferenceFieldsForObjectTest() {
        List<Map<String, String>> fields = Utils.getReferenceFieldsForObject('Opportunity');
    }
    
    @isTest static void getUrlFieldsForObjectTest() {
        List<Map<String, String>> fields = Utils.getUrlFieldsForObject('Opportunity', 2);
    }

    @isTest static void generateQuipComponentTest() {
        ToolingService.ComponentInstance component = Utils.generateQuipComponent('test', 'https://quip.com/xxx', 'Test', 'none');
    }

    @isTest static void checkIfFieldExistsTest() {
        Boolean exists = Utils.checkIfFieldExists('Account', 'Name');
        System.assert(exists);
    }
    
    @isTest static void checkIfFieldNotExistsTest() {
        Boolean exists = Utils.checkIfFieldExists('Account', 'Name_Invalid');
        System.assertEquals(false, exists);
    }

    @isTest static void checkIfFolderExistsTest() {
        Test.setMock(HttpCalloutMock.class, new QuipAPIHttpCalloutMock());
        Boolean exists = Utils.checkIfFolderExists('https://quip.com/test');
        System.assert(exists);
    }

    @isTest static void checkIfPageNotExistsTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        Boolean exists = Utils.checkIfPageExists('');
        System.assertEquals(false, exists);
    }

    @isTest static void checkIfPageExistsTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        Boolean exists = Utils.checkIfPageExists('Test');
        System.assertEquals(false, exists);
    }
    
    @isTest static void checkIfFlowNotExistsTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        Boolean exists = Utils.checkIfFlowExists('');
        System.assertEquals(false, exists);
    }

    @isTest static void checkIfFlowExistsTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        Boolean exists = Utils.checkIfFlowExists('Test');
        System.assertEquals(false, exists);
    }
    
    // @isTest static void checkIfTriggerNotExistsTest() {
    //     Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
    //     Boolean exists = Utils.checkIfApexTriggerExists('');
    //     System.assertEquals(false, exists);
    // }

    // @isTest static void checkIfTriggerExistsTest() {
    //     Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
    //     Boolean exists = Utils.checkIfApexTriggerExists('Test');
    //     System.assertEquals(false, exists);
    // }
    
    @isTest static void getPageByIdNoneTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ToolingService.FlexiPage page = Utils.getPageById('');
        System.assertEquals(null, page);
    }

    @isTest static void getPageByIdTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ToolingService.FlexiPage page = Utils.getPageById('301123456789012');
        System.assertEquals('Test', page.fullName);
    }
    
    @isTest static void getPageByNameNoneTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        ToolingService.FlexiPage page = Utils.getPageByName('');
        System.assertEquals(null, page);
    }

    @isTest static void getPageByNameTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        ToolingService.FlexiPage page = Utils.getPageByName('Test');
        System.assertEquals(null, page);
    }

    @isTest static void getFlowByIdNoneTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ToolingService.Flow flow = Utils.getFlowById('');
        System.assertEquals(null, flow);
    }

    @isTest static void getFlowByIdTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ToolingService.Flow flow = Utils.getFlowById('301123456789012');
        System.assertEquals('Test', flow.fullName);
    }

    @isTest static void getFlowByLabelNoneTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        ToolingService.Flow flow = Utils.getFlowByLabel('');
        System.assertEquals(null, flow);
    }

    @isTest static void getFlowByLabelTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        ToolingService.Flow flow = Utils.getFlowByLabel('Test');
        System.assertEquals(null, flow);
    }

    @isTest static void checkQuipTemplateWrongUrlTest() {
        Boolean exists = Utils.checkQuipTemplate('https://google.com/');
        System.assertEquals(false, exists);
    }
    
    @isTest static void checkQuipTemplateTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIHttpCalloutMock());
        Boolean exists = Utils.checkQuipTemplate('https://quip.com/test');
        System.assert(exists);
    }

    @isTest static void checkPageTabNoTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        Boolean exists = Utils.checkPageTab('', 'Test');
        System.assertEquals(false, exists);
    }

    @isTest static void checkPageTabTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        Boolean exists = Utils.checkPageTab('00000000000000', 'Apex__Test');
        System.assert(exists);
    }

    @isTest static void handleSaveResultsTest() {
        Utils.handleSaveResults(null);

        MetadataService.SaveResult result = new MetadataService.SaveResult();
        result.success = true;
        Utils.handleSaveResults(result);

        MetadataService.SaveResult err = new MetadataService.SaveResult();
        err.success = false;
        MetadataService.Error error = new MetadataService.Error();
        error.message = 'Test error';
        error.statusCode = '500';
        err.errors = new MetadataService.Error[] { error };
        try {
            Utils.handleSaveResults(err);
        } catch (Exception e) {
            System.assert(true);
        }
    }

    @isTest static void checkTabPositioningOnPageExistingTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        Boolean exists = Utils.checkTabPositioningOnPage('00000000000000', 'Apex__Test');

        System.assertEquals(false, exists);
    }
    
    @isTest static void checkTabPositioningOnPageTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        Boolean exists = Utils.checkTabPositioningOnPage('00000000000000', 'Apex__Test2');

        System.assert(exists);
    }

}