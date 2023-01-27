@isTest
private class FlowCreatorTest {
    
    @isTest static void flowTests() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());
        ToolingService.Flow flow = FlowCreator.createOrGetObjectFlow('test', 'test', 'Account', true);
        FlowCreator.createOrGetObjectFlow('test', 'test', 'Account', false);
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        flow = FlowCreator.addCreateFolderToFlow(flow, 'Test', 'Test', 'Add_To_Folder', 'Add to Folder', false);
        flow = FlowCreator.addCreateFolderToFlow(flow, 'Test', 'Test', 'Add_To_Folder', 'Add to Folder', true);
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        flow = FlowCreator.addAddQuipDocumentToFolder(flow, 'Account.Website', 'Test', 'Add_Doc_Folder', 'Add Doc Folder', true, false);
        flow = FlowCreator.addAddQuipDocumentToFolder(flow, 'Account.Website', 'Test', 'Add_Doc_Folder', 'Add Doc Folder', true, true);
        flow = FlowCreator.addAddQuipDocumentToFolder(flow, 'Account.Website', 'Account.Website', 'Add_Doc_Folder', 'Add Doc Folder', false, true);
        flow = FlowCreator.addAddQuipDocumentToFolder(flow, 'Account.Website', 'Account.Website', 'Add_Doc_Folder', 'Add Doc Folder', false, false);
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        flow = FlowCreator.addUpdateRecordToFlow(flow, 'Account', 'Id', 'Website', 'Account.Name', 'Update_Rec', 'Update Rec', false);
        flow = FlowCreator.addUpdateRecordToFlow(flow, 'Account', 'Id', 'Website', 'Account.Name', 'Update_Rec', 'Update Rec', true);
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        flow = FlowCreator.addDecisionToFlow(flow, new String[] { 'Name', 'Active', 'Active', 'Name', 'Employees' }, new String[] { 'EqualsTo', 'EqualsTo', 'EqualsTo', 'EqualsTo', 'EqualsTo' }, new String[] { 'Test', 'true', 'false', 'Old_Account.Test', '123.45' }, 'Check_Conditions', 'Check Conditions');
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);
        
        flow = FlowCreator.createOrGetObjectProcess('test', 'test', 'Account', true);
        FlowCreator.createOrGetObjectProcess('test', 'test', 'Account', false);
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        flow = FlowCreator.addCreateAccountPlanToProcess(flow, 'Account', 'Website', 'https://quip.com/test', 'none');
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);
        
        flow = FlowCreator.addCreateOpportunityNotesToProcess(flow, 'Account', 'Website', 'https://quip.com/test', 'none');
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        flow = FlowCreator.addSendMessageInDocumentActionToProcess(flow, 'https://quip.com/test', 'Test', 'Send_Notification', 'Send Notification', true);
        flow = FlowCreator.addSendMessageInDocumentActionToProcess(flow, 'Account.Website', 'Test', 'Send_Notification_2', 'Send Notification', false);
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        flow = FlowCreator.addDecisionToProcess(flow, new String[] { 'Name', 'Active', 'Active', 'Name', 'Employees' }, new String[] { 'EqualsTo', 'EqualsTo', 'EqualsTo', 'EqualsTo', 'EqualsTo' }, new String[] { 'Test', 'true', 'false', 'Old_Account.Test', '123.45' }, new String[] { 'String', 'Boolean', 'Boolean', 'String', 'Number' }, 'Check_Conditions', 'Check Conditions', 'Rule_name');
        flow = FlowCreator.addVariableToProcess(flow, 'Apex__Test', 'Number', true, false, 2);
        FlowCreator.getLastNode(flow, false);
        FlowCreator.getLastNode(flow, true);

        String flowId = FlowCreator.saveFlow(flow, true);  
    }

}