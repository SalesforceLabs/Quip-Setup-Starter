public with sharing class QuipSetupHandler {
    @AuraEnabled
    public static Map<String, Boolean> isQuipAuthOkay() {
        AuthProvider[] authProviders = [ SELECT Id FROM AuthProvider WHERE DeveloperName = 'Quip' ];

        if (authProviders.size() == 0) {
            throw new QuipHandlerException('Auth provider not found');
        }

        String token = Auth.AuthToken.getAccessToken(authProviders[0].Id, 'Open ID Connect');

        Map<String, Boolean> response = new Map<String, Boolean>();

        response.put('valid', token != null);

        if (token != null) {
            Connection_Check__c[] pastRun = [SELECT Viewed__c FROM Connection_Check__c];
            response.put('viewed', pastRun.size() > 0);
            if (pastRun.size() == 0) {
                Connection_Check__c newRun = new Connection_Check__c();
                newRun.Name = 'Check';
                newRun.Viewed__c = false;
                insert newRun;
            }
        }
        
        return response;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean checkMetadataApiAccess() {
        try {
            MetadataService.MetadataPort service = Utils.createMetadataService();
            String permSetName = 'Quip';
            MetadataService.PermissionSet[] permSets = (MetadataService.PermissionSet[]) service.readMetadata('PermissionSet', new String[] { permSetName }).getRecords();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Boolean> checkPermissionSet() {
        Map<String, Boolean> results = new Map<String,Boolean>();
        
        PermissionSet[] permSets = [SELECT Id FROM PermissionSet WHERE Name = 'Quip'];

        if (permSets.size() == 0) {
            results.put('exists', false);
            results.put('assigned', false);
        } else {
            results.put('exists', true);

            String userId = UserInfo.getUserId();
            PermissionSetAssignment[] assignments = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :permSets[0].Id AND AssigneeId = :userId];
            if (assignments.size() == 0) {
                results.put('assigned', false);
            } else {
                results.put('assigned', true);
            }
        }

        return results;
    }

    @AuraEnabled
    public static boolean checkNoApexTriggers() {
        Integer size = 0;
        for (ApexTrigger t : [SELECT Id, Name FROM ApexTrigger WHERE Name LIKE '%Quip%']) {
            if (t.Name.containsIgnoreCase('equip') == false) {
                size++;
            }
        }
        return size == 0;
    }
}