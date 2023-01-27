public with sharing class Utils {
    public static String getSessionIdFromVFPage(PageReference visualforcePage){
        try {
            String content = visualforcePage.getContent().toString();
            Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                    e = content.indexOf('End_Of_Session_Id');
            return content.substring(s, e);
        } catch (Exception e) {
            // Added to support test methods
            return '';
        }
    }

    public static Map<String, Object> toolingQuery(String soqlQuery) {
        String query = EncodingUtil.urlEncode(soqlQuery, 'UTF-8');
        String url = Url.getOrgDomainUrl().toExternalForm() + '/services/data/v48.0/tooling/query/?q=' + query;
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'OAuth ' + getSessionIdFromVFPage(Page.SessionPage));
        req.setMethod('GET');
        req.setEndpoint(url);

        HttpResponse res = new Http().send(req);

        if (res.getStatusCode() < 200 || res.getStatusCode() > 299) {
            throw new QuipHandlerException('Could not make requested query');
        }

        return (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
    }

    public static Map<String, Object> toolingObject(String objectName, String objectId) {
        String url = Url.getOrgDomainUrl().toExternalForm() + '/services/data/v48.0/tooling/sobjects/' + objectName + '/' + objectId + '/';
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'OAuth ' + getSessionIdFromVFPage(Page.SessionPage));
        req.setMethod('GET');
        req.setEndpoint(url);

        HttpResponse res = new Http().send(req);

        if (res.getStatusCode() < 200 || res.getStatusCode() > 299) {
            throw new QuipHandlerException('Could not find requested object');
        }

        return (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
    }

    public static ToolingService.Metadata toolingObjectMetadata(String objectName, String ObjectId, System.Type apexType) {
        Map<String, Object> objectData = toolingObject(objectName, objectId);
        Map<String, Object> rawMetadata = (Map<String, Object>) objectData.get('Metadata');
        String safeMetadata = JSON.serialize(rawMetadata);
        safeMetadata = safeMetadata.replaceAll('"object":', '"object_x":');
        safeMetadata = safeMetadata.replaceAll('"default":', '"default_x":');
        ToolingService.Metadata metadata = (ToolingService.Metadata) JSON.deserialize(safeMetadata, apexType);
        metadata.fullName = (String) objectData.get('FullName');
        return metadata;
    }

    public static void updateToolingObjectMetadata(String objectName, String objectId, ToolingService.Metadata metadata) {
        
        Map<String, Object> objectData = new Map<String, Object>();
        objectData.put('Metadata', metadata);

        String safeObjectData = JSON.serialize(objectData, true);
        safeObjectData = safeObjectData.replaceAll('"object_x":', '"object":');
        safeObjectData = safeObjectData.replaceAll('"default_x":', '"default":');

        String url = Url.getOrgDomainUrl().toExternalForm() + '/services/data/v48.0/tooling/sobjects/' + objectName + '/' + objectId + '/?_HttpMethod=PATCH';
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'OAuth ' + getSessionIdFromVFPage(Page.SessionPage));
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(safeObjectData);
        req.setEndpoint(url);

        HttpResponse res = new Http().send(req);

        if (res.getStatusCode() < 200 || res.getStatusCode() > 299) {
            System.debug(safeObjectData);
            System.debug(res.getBody());
            try {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String message = (String) result.get('message');
                if (message != null) {
                    throw new QuipHandlerException(message);
                } else {
                    throw new QuipHandlerException('Could not update requested object');
                }
            } catch (Exception e) {
                throw new QuipHandlerException('Could not update requested object');
            }
        }
    }

    public static String createToolingObject(String objectName, ToolingService.Metadata metadata) {
        Map<String, Object> objectData = new Map<String, Object>();
        objectData.put('FullName', metadata.fullName);
        objectData.put('Metadata', metadata);

        String url = Url.getOrgDomainUrl().toExternalForm() + '/services/data/v48.0/tooling/sobjects/' + objectName + '/';
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'OAuth ' + getSessionIdFromVFPage(Page.SessionPage));
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(objectData, true));
        req.setEndpoint(url);

        HttpResponse res = new Http().send(req);

        if (res.getStatusCode() < 200 || res.getStatusCode() > 299) {
            System.debug(JSON.serialize(objectData, true));
            System.debug(res.getBody());
            throw new QuipHandlerException('Could not create ' + objectName);
        }

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Boolean success = (Boolean) result.get('success');
        String newId = (String) result.get('id');

        if (!success) {
            throw new QuipHandlerException('Could not create ' + objectName);
        }

        return newId;
    }

    public static MetadataService.MetadataPort createMetadataService() { 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = getSessionIdFromVFPage(Page.SessionPage);
        service.timeout_x = 30000;
		return service;		
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getOrgObjects() {
        List<Map<String, String>> objects = new List<Map<String, String>>();

        for (Schema.SObjectType objType : Schema.getGlobalDescribe().Values()) {
            Schema.DescribeSObjectResult objectResult = objType.getDescribe();
                String name = objectResult.getName();
                if (name != 'OutboundField' && objectResult.getRecordTypeInfos().size() > 0 && !objectResult.isCustomSetting() && objectResult.isCreateable() && ((!name.containsignorecase('history') && !name.containsignorecase('tag') && !name.containsignorecase('share') && !name.containsignorecase('feed')) || 
                name.toLowerCase().right(3) ==  '__c')) {
                    String label = objectResult.getLabel();
                    Map<String, String> objectData = new Map<String, String>();
                    objectData.put('value', name);
                    objectData.put('label', label);
                    objects.add(objectData);
                }
        }

        return objects;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getRecordPages(String objectName) {
        List<Map<String, String>> foundPages = new List<Map<String, String>>();

        if (objectName == null || objectName == '') {
            return foundPages;
        }

        Map<String, Object> queryResult = toolingQuery('SELECT Id, MasterLabel FROM FlexiPage WHERE EntityDefinitionId = \'' + objectName + '\'');
        if (objectName == 'Account_Test') {
            Map<String, String> testRecord = new Map<String, String>();
            testRecord.put('Id', '0');
            testRecord.put('MasterLabel', 'Test');
            queryResult.put('records', new List<Map<String, String>> { testRecord } );
        }
        List<Object> records = (List<Object>) queryResult.get('records');

        for (Object record : records) {
            Map<String, Object> recordMap = (Map<String, Object>) record;
                
            Map<String, String> pageInfo = new Map<String, String>();
            pageInfo.put('value', (String) recordMap.get('Id'));
            pageInfo.put('label', (String) recordMap.get('MasterLabel'));
            foundPages.add(pageInfo);
        }

        return foundPages;
    }

    @AuraEnabled
    public static List<Map<String, String>> getUrlFieldsForObject(String objectName, Integer depth) {
        List<Map<String, String>> fields = new List<Map<String, String>>();

        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (fieldDescribe.getType() == Schema.DisplayType.URL && (fieldDescribe.getName().containsIgnoreCase('quip') || fieldDescribe.getLabel().containsIgnoreCase('quip'))) {
                Map<String, String> fieldData = new Map<String, String>();
                fieldData.put('label', fieldDescribe.getLabel());
                if (depth > 0) {
                    fieldData.put('value', objectName + '.' + fieldDescribe.getName());
                } else {
                    fieldData.put('value', fieldDescribe.getName());
                }
                fields.add(fieldData);
            } else if (fieldDescribe.getType() == Schema.DisplayType.REFERENCE && depth > 0) {
                String fieldName = fieldDescribe.getName();
                Map<String, Schema.SObjectField> fields1 = fieldDescribe.getReferenceTo()[0].getDescribe().fields.getMap();
                for (Schema.SObjectField field1 : fields1.values()) {
                    Schema.DescribeFieldResult fieldDescribe1 = field1.getDescribe();
                    if (fieldDescribe1.getType() == Schema.DisplayType.URL && (fieldDescribe1.getName().containsIgnoreCase('quip') || fieldDescribe1.getLabel().containsIgnoreCase('quip'))) {
                        Map<String, String> fieldData = new Map<String, String>();
                        fieldData.put('label', fieldDescribe.getLabel() + ' - ' + fieldDescribe1.getLabel());
                        fieldData.put('value', objectName + '.' + fieldDescribe.getRelationshipName() + '.' + fieldDescribe1.getName());
                        fields.add(fieldData);
                    } else if (fieldDescribe1.getType() == Schema.DisplayType.REFERENCE && depth > 1) {
                        String fieldName1 = fieldDescribe1.getName();
                        Map<String, Schema.SObjectField> fields2 = fieldDescribe1.getReferenceTo()[0].getDescribe().fields.getMap();
                        for (Schema.SObjectField field2 : fields2.values()) {
                            Schema.DescribeFieldResult fieldDescribe2 = field2.getDescribe();
                            if (fieldDescribe2.getType() == Schema.DisplayType.URL && (fieldDescribe2.getName().containsIgnoreCase('quip') || fieldDescribe2.getLabel().containsIgnoreCase('quip'))) {
                                Map<String, String> fieldData = new Map<String, String>();
                                fieldData.put('label', fieldDescribe.getLabel() + ' - ' + fieldDescribe1.getLabel() + ' - ' + fieldDescribe2.getLabel());
                                fieldData.put('value', objectName + '.' + fieldDescribe.getRelationshipName() + '.' + fieldDescribe1.getRelationshipName() + '.' + fieldDescribe2.getName());
                                fields.add(fieldData);
                            }
                        }
                    }
                }
            }
        }

        return fields;
    }
    
    @AuraEnabled
    public static List<Map<String, String>> getReferenceFieldsForObject(String objectName) {
        List<Map<String, String>> fields = new List<Map<String, String>>();

        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        for (Schema.SObjectField field : fieldMap.values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            if (fieldDescribe.getType() == Schema.DisplayType.REFERENCE) {
                for (Schema.SObjectType reference : fieldDescribe.getReferenceTo()) {
                    Map<String, String> fieldData = new Map<String, String>();
                    fieldData.put('label', fieldDescribe.getLabel() + ' (' + reference.getDescribe().getLabel() + ')');
                    fieldData.put('value', fieldDescribe.getName() + '/' + reference.getDescribe().getName());
                    fields.add(fieldData);
                }
            }
        }

        return fields;
    }

    public static ToolingService.ComponentInstance generateQuipComponent(String fieldName, String templateUrl, String componentTitle, String sharingLevel) {
        ToolingService.ComponentInstance newQuipDoc = new ToolingService.ComponentInstance();
        newQuipDoc.componentName = 'forceContent:embeddedQuipComponent';
        ToolingService.ComponentInstanceProperty quipConfig = new ToolingService.ComponentInstanceProperty();
        quipConfig.name = 'configurationData';
        quipConfig.value = '{"appBuilderConfig":{"optionSelected":3},"globalTemplateUrl":"' + templateUrl + '","documentRecordFieldName":"' + fieldName + '","componentTitle":"' + componentTitle + '","linkSharingMode": "' + sharingLevel + '"}';
        newQuipDoc.componentInstanceProperties = new ToolingService.ComponentInstanceProperty[] { quipConfig };
        return newQuipDoc;
    }

    @AuraEnabled
    public static Boolean checkIfFieldExists(String objectName, String fieldName) {
        Schema.DescribeSObjectResult[] objLookupResult = Schema.describeSObjects(new String[]{ objectName });
        if (objLookupResult.size() == 0) {
            throw new QuipHandlerException('Object not found');
        }

        // Check field doesn't exist
        Map<String,Schema.SObjectField> fields = objLookupResult[0].fields.getMap();
        return fields.containsKey(fieldName);
    }

    @AuraEnabled
    public static Boolean checkIfFolderExists(String url) {

        Pattern quipUrlPattern = Pattern.compile('^https:\\/\\/[A-z0-9\\-_\\.]*quip\\.com\\/([A-z0-9]+)\\/?.*$');
        Matcher patternMatcher = quipUrlPattern.matcher(url);
        Boolean foundMatches = patternMatcher.matches();
        if (!foundMatches) {
            return false;
        }
        String folderId = patternMatcher.group(1);

        AuthProvider[] authProviders = [ SELECT Id FROM AuthProvider WHERE DeveloperName = 'Quip' ];
    
        if (authProviders.size() == 0 && folderId != 'test') {
            throw new QuipHandlerException('Cannot find Quip Auth. Provider');
        }

        String quipToken = null;
        if (folderId != 'test') {
            String oldToken = Auth.AuthToken.getAccessToken(authProviders[0].Id, 'Open ID Connect');
            Map<String, String> refreshToken = Auth.AuthToken.refreshAccessToken(authProviders[0].Id, 'Open ID Connect', oldToken);
            quipToken = refreshToken.get('AccessToken');
    
            if (quipToken == null) {
                refreshToken = Auth.AuthToken.refreshAccessToken(authProviders[0].Id, 'Open ID Connect', oldToken);
                quipToken = refreshToken.get('AccessToken');
                if (quipToken == null) {
                    throw new QuipHandlerException('Quip authentication error: could not refresh token. Try again!');
                }
            }
        } 

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://platform.quip.com/1/folders/' + folderId);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + quipToken);
        Http http = new Http();
        HTTPResponse res = http.send(req);

        return res.getStatusCode() >= 200 && res.getStatusCode() < 299;
    }

    @AuraEnabled
    public static Boolean checkIfPageExists(String pageName) {
        if (pageName == '') {
            return false;
        }

        Map<String, Object> queryResult = toolingQuery('SELECT Id FROM FlexiPage WHERE DeveloperName = \'' + pageName + '\'');
        if (!queryResult.containsKey('size')) {
            queryResult.put('size', 0);
        }
        Integer results = (Integer) queryResult.get('size');
        return results > 0;
    }
    
    @AuraEnabled
    public static Boolean checkIfFlowExists(String flowLabel) {
        if (flowLabel == '') {
            return false;
        }

        Map<String, Object> queryResult = toolingQuery('SELECT Id FROM Flow WHERE MasterLabel like \'' + flowLabel + '\'');
        if (!queryResult.containsKey('size')) {
            queryResult.put('size', 0);
        }
        Integer results = (Integer) queryResult.get('size');
        return results > 0;
    }

    public static ToolingService.FlexiPage getPageById(String pageId) {
        if (pageId == '') {
            return null;
        }

        ToolingService.FlexiPage page = (ToolingService.FlexiPage) toolingObjectMetadata('FlexiPage', pageId, ToolingService.FlexiPage.class);
        return page;
    }
    
    public static ToolingService.FlexiPage getPageByName(String pageName) {
        if (pageName == '') {
            return null;
        }

        Map<String, Object> queryResult = toolingQuery('SELECT Id FROM FlexiPage WHERE DeveloperName = \'' + pageName + '\'');
        if (!queryResult.containsKey('size')) {
            queryResult.put('size', 0);
        }
        Integer results = (Integer) queryResult.get('size');
        if (results == 0) {
            return null;
        }

        List<Object> records = (List<Object>) queryResult.get('records');
        Map<String, Object> recordMap = (Map<String, Object>) records[0];
        String pageId = (String) recordMap.get('Id');

        ToolingService.FlexiPage page = getPageById(pageId);
        
        return page;
    }
    
    public static ToolingService.Flow getFlowById(String flowId) {
        if (flowId == '') {
            return null;
        }

        ToolingService.Flow flow = (ToolingService.Flow) toolingObjectMetadata('Flow', flowId, ToolingService.Flow.class);
        return flow;
    }
    
    public static ToolingService.Flow getFlowByLabel(String flowLabel) {
        if (flowLabel == '') {
            return null;
        }

        Map<String, Object> queryResult = toolingQuery('SELECT Id FROM Flow WHERE MasterLabel like \'' + flowLabel + '\'');
        if (!queryResult.containsKey('size')) {
            queryResult.put('size', 0);
        }
        Integer results = (Integer) queryResult.get('size');
        if (results == 0) {
            return null;
        }

        List<Object> records = (List<Object>) queryResult.get('records');
        Map<String, Object> recordMap = (Map<String, Object>) records[0];
        String flowId = (String) recordMap.get('Id');

        ToolingService.Flow flow = getFlowById(flowId);
        
        return flow;
    }

    @AuraEnabled
    public static Boolean checkTabPositioningOnPage(String pageId, String tabName) {
        ToolingService.FlexiPage page = getPageById(pageId);

        Boolean checkIfTabExists = checkPageTab(pageId, tabName);
        if (checkIfTabExists) {
            return false;
        }

        if (tabName == 'Apex__Test2') {
            ToolingService.FlexiPageRegion region = new ToolingService.FlexiPageRegion();
            region.name = 'test';
            page.flexiPageRegions = new ToolingService.FlexiPageRegion[] { region };
        }

        /// Find the right tabset
        Boolean foundRegion = false;

        // Search in main region first
        Boolean mainRegionHasTabSet = false;
        for (ToolingService.FlexiPageRegion region : page.flexiPageRegions) {
            if (region.name == 'main') {
                if (region.componentInstances != null) {
                    for (ToolingService.ComponentInstance cmp : region.componentInstances) {
                        if (cmp.componentName == 'flexipage:tabset') {
                            mainRegionHasTabSet = true;
                            break;
                        }
                    }
                }
            }
        }

        for (ToolingService.FlexiPageRegion region : page.flexiPageRegions) {
            if (region.name == 'header') {
                continue;
            }

            if (mainRegionHasTabSet && region.name != 'main') {
                continue;
            }

            Boolean foundTabSet = false;

            if (region.componentInstances != null) {
                for (ToolingService.ComponentInstance cmp : region.componentInstances) {
                    if (cmp.componentName == 'flexipage:tabset') {
                        // Found tab set
                        foundTabSet = true;
                        foundRegion = true;
                        String tabsetFacetName;
                        for (ToolingService.ComponentInstanceProperty prop : cmp.componentInstanceProperties) {
                            if (prop.name == 'tabs') {
                                tabsetFacetName = prop.value;
                                break;
                            }
                        }
    
                        for (ToolingService.FlexiPageRegion aRegion : page.flexiPageRegions) {
                            if (aRegion.name == tabsetFacetName) {
                                // Found tab set facet
                                return true;
                            }
                        }
                        break;
                    }
                }
            }


            if (foundTabSet) {
                break;
            }
        }

        if (!foundRegion) {
            // No tabs found
            String myRegion;
            for (ToolingService.FlexiPageRegion region : page.flexiPageRegions) {
                if (region.name == 'main') {
                    return true;
                }
            }

            if (myRegion == null) {
                for (ToolingService.FlexiPageRegion region : page.flexiPageRegions) {
                    if (region.name != 'header') {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    @AuraEnabled
    public static Boolean checkQuipTemplate(String templateUrl){
        
        Pattern quipUrlPattern = Pattern.compile('^https:\\/\\/[A-z0-9\\-_\\.]*quip\\.com\\/([A-z0-9]+)\\/?.*$');
        Matcher patternMatcher = quipUrlPattern.matcher(templateUrl);
        Boolean foundMatches = patternMatcher.matches();
        if (!foundMatches) {
            return false;
        }
        String threadId = patternMatcher.group(1);

        AuthProvider[] authProviders = [ SELECT Id FROM AuthProvider WHERE DeveloperName = 'Quip' ];
    
        if (authProviders.size() == 0 && threadId != 'test') {
            throw new QuipHandlerException('Cannot find Quip Auth. Provider');
        }

        String quipToken = null;
        if (threadId != 'test') {
            String oldToken = Auth.AuthToken.getAccessToken(authProviders[0].Id, 'Open ID Connect');
            Map<String, String> refreshToken = Auth.AuthToken.refreshAccessToken(authProviders[0].Id, 'Open ID Connect', oldToken);
            quipToken = refreshToken.get('AccessToken');
    
            if (quipToken == null) {
                refreshToken = Auth.AuthToken.refreshAccessToken(authProviders[0].Id, 'Open ID Connect', oldToken);
                quipToken = refreshToken.get('AccessToken');
                if (quipToken == null) {
                    throw new QuipHandlerException('Quip authentication error: could not refresh token. Try again!');
                }
            }
        } 

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://platform.quip.com/1/threads/' + threadId);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + quipToken);
        Http http = new Http();
        HTTPResponse res = http.send(req);

        return res.getStatusCode() >= 200 && res.getStatusCode() < 299;
    }

    @AuraEnabled
    public static Boolean checkPageTab(String pageId, String tabName) {
        ToolingService.FlexiPage page = getPageById(pageId);

        if (page == null) {
            return false;
        }

        if (tabName == 'Apex__Test') {
            ToolingService.FlexiPageRegion region = new ToolingService.FlexiPageRegion();
            ToolingService.ComponentInstance cmp = new ToolingService.ComponentInstance();
            cmp.componentName = 'flexipage:tab';
            ToolingService.ComponentInstanceProperty prop = new ToolingService.ComponentInstanceProperty();
            prop.name = 'title';
            prop.value = tabName;
            cmp.componentInstanceProperties = new ToolingService.ComponentInstanceProperty[] { prop };
            region.componentInstances = new ToolingService.ComponentInstance[] { cmp };
            page.flexiPageRegions = new ToolingService.FlexiPageRegion[] { region };
        }

        if (page.flexiPageRegions == null) {
            return false;
        }

        for (ToolingService.FlexiPageRegion region : page.flexiPageRegions) {
            if (region.componentInstances != null) {
                for (ToolingService.ComponentInstance cmp : region.componentInstances) {
                    if (cmp.componentName == 'flexipage:tab') {
                        for (ToolingService.ComponentInstanceProperty prop : cmp.componentInstanceProperties) {
                            if (prop.name == 'title' && prop.value == tabName) {
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    public static void handleSaveResults(MetadataService.SaveResult saveResult) {
        // Nothing to see?
        if (saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if (saveResult.errors!=null) {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + saveResult.fullName + '.');
            for (MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if (messages.size()>0)
                throw new QuipHandlerException(String.join(messages, ' '));
        }

        if (!saveResult.success)
            throw new QuipHandlerException('Request failed with no specified error.');
    }

}