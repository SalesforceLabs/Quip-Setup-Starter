public with sharing class LiveDataFeedHandler {
    
    @AuraEnabled
    public static void deployLiveDataFeed(String objectName, String objectLabel, String documentUrl, String message, Boolean criteriaNewRecord, String criteriaName, Boolean criteriaCondition, String criteriaOperator, String criteriaValue, Boolean staticDestination) {
        
        // Ensure object exists
        Schema.DescribeSObjectResult[] objLookupResult = Schema.describeSObjects(new String[]{ objectName });
        if (objLookupResult.size() == 0) {
            throw new QuipHandlerException('Object not found');
        }

        String safeObjectCriteriaName = objectName + '_' + criteriaName;
        if (criteriaNewRecord) {
            safeObjectCriteriaName = objectName + '_New';
        }
        safeObjectCriteriaName = safeObjectCriteriaName.replaceAll('_+', '_');

        String flowName = safeObjectCriteriaName + '_Quip_Live_Data_Feed';
        String flowLabel = 'Quip - ' + objLookupResult[0].getLabel() + ' - New - Live Data Feed';
        if (!criteriaNewRecord) {
            flowLabel = 'Quip - ' + objLookupResult[0].getLabel() + ' - ' + criteriaName + ' - Live Data Feed';
        }
        if (!staticDestination) {
            flowName = safeObjectCriteriaName + '_Quip_Doc_Notifications';
            flowLabel = 'Quip - ' + objLookupResult[0].getLabel() + ' - New - Document Notifications';
            if (!criteriaNewRecord) {
                flowLabel = 'Quip - ' + objLookupResult[0].getLabel() + ' - ' + criteriaName + ' - Document Notifications';
            }
        }

        ToolingService.Flow flow = FlowCreator.createOrGetObjectProcess(flowName, flowLabel, objectName, criteriaNewRecord);

        if (!staticDestination || !criteriaNewRecord) {
            // reset default decision
            flow.decisions = new ToolingService.FlowDecision[] {};
            flow.startElementReference = null;
        }

        String safeCriteriaName = criteriaName.replaceAll('_+', '_');
        if (!criteriaNewRecord) {
            flow = FlowCreator.addDecisionToProcess(flow, new String[] { 'myVariable_old', 'myVariable_old.' + criteriaName }, new String[] { 'IsNull', 'NotEqualTo' }, new String[] { 'false', 'myVariable_current.' + criteriaName }, new String[] { null, null }, 'isChangedDecision2_myRule_1_' + safeCriteriaName, 'isChangedDecision2_myRule_1_' + safeCriteriaName, 'isChangedRule_2_myRule_1_' + safeCriteriaName);
        }


        if (staticDestination) {
            if (!criteriaNewRecord) {
                // Field has changed
                
                SObjectType r = ((SObject)(Type.forName('Schema.' + objectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                String dataType = d.fields.getMap().get(criteriaName).getDescribe().getType().name();
                dataType = dataType.substring(0, 1).toUpperCase() + dataType.substring(1).toLowerCase();
                
                String[] conditionNames = new String[]{ 'isChangedRule_2_myRule_1_' + safeCriteriaName };
                String[] conditionOperators = new String[]{ 'EqualTo' };
                String[] conditionValues = new String[]{ 'true' };
                String[] conditionDataTypes = new String[]{ dataType };
                if (criteriaCondition) {
                    conditionNames.add('myVariable_current.' + criteriaName);
                    conditionOperators.add(criteriaOperator);
                    conditionValues.add(criteriaValue);
                    conditionDataTypes.add(dataType);
                }
                flow = FlowCreator.addDecisionToProcess(flow, conditionNames, conditionOperators, conditionValues, conditionDataTypes, 'myDecision', 'Check Conditions', 'myRule_1');
            }
        } else {
            if (!criteriaNewRecord) {
                SObjectType r = ((SObject)(Type.forName('Schema.' + objectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                String dataType = d.fields.getMap().get(criteriaName).getDescribe().getType().name();
                dataType = dataType.substring(0, 1).toUpperCase() + dataType.substring(1).toLowerCase();

                String docRef = documentUrl.replaceFirst(objectName, 'myVariable_current');

                String[] conditionNames = new String[]{ 'isChangedRule_2_myRule_1_' + safeCriteriaName, docRef };
                String[] conditionOperators = new String[]{ 'EqualTo', 'IsNull' };
                String[] conditionValues = new String[]{ 'true', 'false' };
                String[] conditionDataTypes = new String[]{ dataType, 'String' };
                if (criteriaCondition) {
                    conditionNames.add('myVariable_current.' + criteriaName);
                    conditionOperators.add(criteriaOperator);
                    conditionValues.add(criteriaValue);
                    conditionDataTypes.add(dataType);
                }
                flow = FlowCreator.addDecisionToProcess(flow, conditionNames, conditionOperators, conditionValues, conditionDataTypes, 'myDecision', 'Check Conditions', 'myRule_1');
            } else {
                String docRef = documentUrl.replaceFirst(objectName, 'myVariable_current');
                String[] conditionNames = new String[]{ docRef };
                String[] conditionOperators = new String[]{ 'IsNull' };
                String[] conditionValues = new String[]{ 'false' };
                String[] conditionDataTypes = new String[]{ 'String' };
                flow = FlowCreator.addDecisionToProcess(flow, conditionNames, conditionOperators, conditionValues, conditionDataTypes, 'myDecision', 'Check Conditions', 'myRule_1');
            }
        }

        if (staticDestination) {
            flow = FlowCreator.addSendMessageInDocumentActionToProcess(flow, documentUrl, message, 'myRule_1_A1', 'Send Notification', staticDestination);
        } else {
            String docRef = documentUrl.replaceFirst(objectName, 'myVariable_current');
            flow = FlowCreator.addSendMessageInDocumentActionToProcess(flow, docRef, message, 'myRule_1_A1', 'Send Notification', staticDestination);
        }

        FlowCreator.saveFlow(flow, true);
    }

    @AuraEnabled
    public static Map<String, Object> getLastRun(String type) {
        try {
            Live_Data_Feed_Run__c pastRun = [SELECT Object__c, Type__c, Criteria_Field__c, Criteria_Type__c, Destination_URL__c, Run_Time__c FROM Live_Data_Feed_Run__c WHERE Type__c = :type ORDER BY Run_Time__c DESC LIMIT 1];
            Map<String, Object> response = new Map<String, Object>();
            response.put('objectName', pastRun.Object__c);
            response.put('destinationUrl', pastRun.Destination_URL__c);
            response.put('criteriaType', pastRun.Criteria_Type__c);
            response.put('criteriaFieldName', pastRun.Criteria_Field__c);
            response.put('timestamp', pastRun.Run_Time__c);
            return response;
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled
    public static void storeRun(String type, String objectName, String destinationUrl, String criteriaType, String criteriaFieldName, Integer timestamp) {
        Live_Data_Feed_Run__c newRun = new Live_Data_Feed_Run__c();
        newRun.Name = String.valueOf(timestamp);
        newRun.Type__c = type;
        newRun.Object__c = objectName;
        newRun.Destination_URL__c = destinationUrl;
        newRun.Criteria_Type__c = criteriaType;
        newRun.Criteria_Field__c = criteriaFieldName;
        newRun.Run_Time__c = timestamp;

        insert newRun;
    }

}