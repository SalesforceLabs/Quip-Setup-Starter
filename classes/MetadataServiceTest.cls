@isTest
private class MetadataServiceTest {

    private class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			if(request instanceof MetadataService.retrieve_element)
				response.put('response_x', new MetadataService.retrieveResponse_element());
			else if(request instanceof MetadataService.updateMetadata_element)
                response.put('response_x', new MetadataService.updateMetadataResponse_element());
            else if(request instanceof  MetadataService.createMetadata_element)
                response.put('response_x', new MetadataService.createMetadataResponse_element());
            else if(request instanceof  MetadataService.readMetadata_element)
                response.put('response_x', new MetadataService.readPermissionSetResponse_element());
            return;
		}
	}
    
    @isTest static void MetadataServiceTest() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());

        new MetadataService.SaveResult();
        new MetadataService.ExtendedErrorDetails();
        new MetadataService.readMetadataResponse_element();
        new MetadataService.retrieve_element();
        new MetadataService.PermissionSetTabSetting();
        new MetadataService.PermissionSetUserPermission();
        new MetadataService.PermissionSetFieldPermissions();
        new MetadataService.RetrieveRequest();
        new MetadataService.AsyncResult();
        new MetadataService.retrieveResponse_element();
        new MetadataService.PermissionSetRecordTypeVisibility();
        new MetadataService.PermissionSet();
        new MetadataService.PermissionSetApexClassAccess();
        new MetadataService.Error();
        new MetadataService.updateMetadata_element();
        new MetadataService.updateMetadataResponse_element();
        new MetadataService.createMetadata_element();
        new MetadataService.createMetadataResponse_element();
        new MetadataService.PermissionSetApexPageAccess();
        new MetadataService.PermissionSetExternalDataSourceAccess();
        new MetadataService.PermissionSetCustomPermissions();
        new MetadataService.ReadPermissionSetResult();
        new MetadataService.readPermissionSetResponse_element();
        new MetadataService.readMetadata_element();
        new MetadataService.PermissionSetObjectPermissions();
        new MetadataService.SessionHeader_element();
        new MetadataService.DebuggingInfo_element();
        new MetadataService.LogInfo();
        new MetadataService.DebuggingHeader_element();
        new MetadataService.PackageTypeMembers();
        new MetadataService.ProfileObjectPermissions();
        new MetadataService.AllOrNoneHeader_element();
        new MetadataService.ReadResult();
        new MetadataService.CallOptions_element();
        new MetadataService.Package_x();
        new MetadataService.PermissionSetApplicationVisibility();
        MetadataService.MetadataPort port = new MetadataService.MetadataPort();

        port.updateMetadata(null);
        port.createMetadata(null);
        port.readMetadata(null, new String[] { null });
    }
}