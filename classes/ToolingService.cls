public class ToolingService {

    public virtual class Metadata {
        public String fullName;
    }
    
    public class FlexiPage extends Metadata {
        public String type = 'FlexiPage';
        public String description;
        public ToolingService.FlexiPageRegion[] flexiPageRegions;
        public String masterLabel;
        public String parentFlexiPage;
        public ToolingService.PlatformActionList platformActionlist;
        public ToolingService.QuickActionList quickActionList;
        public String sobjectType;
        public ToolingService.FlexiPageTemplateInstance template;
    }

    public class FlexiPageRegion {
        public String appendable;
        public ToolingService.ComponentInstance[] componentInstances;
        public String mode;
        public String name;
        public String prependable;
        public String replaceable;
        public String type;
    }

    public class ComponentInstance {
        public ToolingService.ComponentInstanceProperty[] componentInstanceProperties;
        public String componentName;
        public ToolingService.UiFormulaRule visibilityRule;
    }

    public class ComponentInstanceProperty {
        public String name;
        public String type;
        public String value;
    }

    public class UiFormulaRule {
        public String booleanFilter;
        public ToolingService.UiFormulaCriterion[] criteria;
    }

    public class UiFormulaCriterion {
        public String leftValue;
        public String operator;
        public String rightValue;
    }

    public class PlatformActionList {
        public String actionListContext;
        public ToolingService.PlatformActionListItem[] platformActionListItems;
        public String relatedSourceEntity;
    }

    public class PlatformActionListItem {
        public String actionName;
        public String actionType;
        public Integer sortOrder;
        public String subtype;
    }

    public class QuickActionList {
        public ToolingService.QuickActionListItem[] quickActionListItems;
    }

    public class QuickActionListItem {
        public String quickActionName;
    }

    public class FlexiPageTemplateInstance {
        public String name;
        public ToolingService.ComponentInstanceProperty[] properties;
    }

    public class CustomField extends Metadata {
        public String type = 'CustomField';
        public String businessOwnerGroup;
        public String businessOwnerUser;
        public String businessStatus;
        public Boolean caseSensitive;
        public String customDataType;
        public String defaultValue;
        public String deleteConstraint;
        public Boolean deprecated;
        public String description;
        public String displayFormat;
        public Boolean displayLocationInDecimal;
        public Boolean encrypted;
        public Boolean escapeMarkup;
        public String externalDeveloperName;
        public Boolean externalId;
        public String fieldManageability;
        public String formula;
        public String formulaTreatBlanksAs;
        public String inlineHelpText;
        public Boolean isConvertLeadDisabled;
        public Boolean isFilteringDisabled;
        public Boolean isNameField;
        public Boolean isSortingDisabled;
        public String label;
        public Integer length;
        public ToolingService.LookupFilter lookupFilter;
        public String maskChar;
        public String maskType;
        public String metadataRelationshipControllingField;
        public Boolean populateExistingRows;
        public Integer precision;
        public String referenceTargetField;
        public String referenceTo;
        public String relationshipLabel;
        public String relationshipName;
        public Integer relationshipOrder;
        public Boolean reparentableMasterDetail;
        public Boolean required;
        public Boolean restrictedAdminField;
        public Integer scale;
        public String securityClassification;
        public Integer startingNumber;
        public Boolean stripMarkup;
        public String summarizedField;
        public ToolingService.FilterItem[] summaryFilterItems;
        public String summaryForeignKey;
        public String summaryOperation;
        public Boolean trackFeedHistory;
        public Boolean trackHistory;
        public Boolean trackTrending;
        public String type_x;
        public Boolean unique;
        public ToolingService.ValueSet valueSet;
        public Integer visibleLines;
        public Boolean writeRequiresMasterRead;
    }

    public class LookupFilter {
        public Boolean active;
        public String booleanFilter;
        public String description;
        public String errorMessage;
        public ToolingService.FilterItem[] filterItems;
        public String infoMessage;
        public Boolean isOptional;
    }

    public class FilterItem {
        public String field;
        public String operation;
        public String value;
        public String valueField;
    }

    public class ValueSet {
        public String controllingField;
        public Boolean restricted;
        public ToolingService.ValueSetValuesDefinition valueSetDefinition;
        public String valueSetName;
        public ToolingService.ValueSettings[] valueSettings;
    }

    public class ValueSetValuesDefinition {
        public Boolean sorted;
        public ToolingService.CustomValue[] value;
    }

    public virtual class CustomValue extends Metadata {
        public String color;
        public Boolean default_x;
        public String description;
        public Boolean isActive;
        public String label;
    }

    public class StandardValue extends CustomValue {
        public String type = 'StandardValue';
        public Boolean allowEmail;
        public Boolean closed;
        public Boolean converted;
        public Boolean cssExposed;
        public String forecastCategory;
        public String groupingString;
        public Boolean highPriority;
        public Integer probability;
        public String reverseRole;
        public Boolean reviewed;
        public Boolean won;
    }

    public class ValueSettings {
        public String[] controllingFieldValue;
        public String valueName;
    }
    
    public class Flow extends Metadata {
        public ToolingService.FlowActionCall[] actionCalls;
        public ToolingService.FlowApexPluginCall[] apexPluginCalls;
        public ToolingService.FlowAssignment[] assignments;
        public ToolingService.FlowChoice[] choices;
        public ToolingService.FlowConstant[] constants;
        public ToolingService.FlowDecision[] decisions;
        public String description;
        public ToolingService.FlowDynamicChoiceSet[] dynamicChoiceSets;
        public ToolingService.FlowFormula[] formulas;
        public String interviewLabel;
        public Boolean isAdditionalPermissionRequiredToRun;
        public Boolean isTemplate;
        public String label;
        public ToolingService.FlowLoop[] loops;
        public ToolingService.FlowMetadataValue[] processMetadataValues;
        public String processType;
        public ToolingService.FlowRecordCreate[] recordCreates;
        public ToolingService.FlowRecordDelete[] recordDeletes;
        public ToolingService.FlowRecordLookup[] recordLookups;
        public ToolingService.FlowRecordUpdate[] recordUpdates;
        public String runInMode;
        public ToolingService.FlowScreen[] screens;
        public ToolingService.FlowStage[] stages;
        public ToolingService.FlowStart start;
        public String startElementReference;
        public String status;
        public ToolingService.FlowStep[] steps;
        public ToolingService.FlowSubflow[] subflows;
        public ToolingService.FlowTextTemplate[] textTemplates;
        public ToolingService.FlowVariable[] variables;
        public ToolingService.FlowWait[] waits;
    }

    public virtual class FlowBaseElement {
        public ToolingService.FlowMetadataValue[] processMetadataValues;
    }

    public virtual class FlowElement extends FlowBaseElement {
        public String description;
        public String name;
    }

    public virtual class FlowNode extends FlowElement {
        public String label;
        public Integer locationX;
        public Integer locationY;
    }

    public class FlowActionCall extends FlowNode {
        public String actionName;
        public String actionType;
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowDataTypeMapping[] dataTypeMappings;
        public ToolingService.FlowConnector faultConnector;
        public ToolingService.FlowActionCallInputParameter[] inputParameters;
        public ToolingService.FlowActionCallOutputParameter[] outputParameters;
        public Boolean storeOutputAutomatically;
    }

    public class FlowMetadataValue {
        public String name;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowElementReferenceOrValue {
        public Boolean booleanValue;
        public DateTime dateTimeValue;
        public Date dateValue;
        public String elementReference;
        public Double numberValue;
        public String stringValue;
    }

    public class FlowConnector extends FlowBaseElement {
        public String targetReference;
    }

    public class FlowDataTypeMapping extends FlowBaseElement {
        public String typeName;
        public String typeValue;
    }

    public class FlowActionCallInputParameter extends FlowBaseElement {
        public String name;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowActionCallOutputParameter extends FlowBaseElement {
        public String assignToReference;
        public String name;
    }

    public class FlowApexPluginCall extends FlowNode {
        public String apexClass;
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowConnector faultConnector;
        public ToolingService.FlowApexPluginCallInputParameter[] inputParameters;
        public ToolingService.FlowApexPluginCallOutputParameter[] outputParameters;
    }

    public class FlowApexPluginCallInputParameter extends FlowBaseElement {
        public String name;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowApexPluginCallOutputParameter extends FlowBaseElement {
        public String assignToReference;
        public String name;
    }

    public class FlowAssignment extends FlowNode {
        public ToolingService.FlowAssignmentItem[] assignmentItems;
        public ToolingService.FlowConnector connector;
    }

    public class FlowAssignmentItem extends FlowBaseElement {
        public String assignToReference;
        public String operator;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowChoice extends FlowElement {
        public String choiceText;
        public String dataType;
        public ToolingService.FlowChoiceUserInput userInput;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowChoiceUserInput extends FlowBaseElement {
        public Boolean isRequired;
        public String promptText;
        public ToolingService.FlowInputValidationRule validationRule;
    }

    public class FlowInputValidationRule {
        public String errorMessage;
        public String formulaExpression;
    }

    public class FlowConstant extends FlowElement {
        public String dataType;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowDecision extends FlowNode {
        public ToolingService.FlowConnector defaultConnector;
        public String defaultConnectorLabel;
        public ToolingService.FlowRule[] rules;
    }

    public class FlowRule extends FlowElement {
        public String conditionLogic;
        public ToolingService.FlowCondition[] conditions;
        public ToolingService.FlowConnector connector;
        public String label;
    }

    public class FlowCondition extends FlowBaseElement {
        public String leftValueReference;
        public String operator;
        public ToolingService.FlowElementReferenceOrValue rightValue;
    }

    public class FlowDynamicChoiceSet extends FlowElement {
        public String dataType;
        public String displayField;
        public ToolingService.FlowRecordFilter[] filters;
        public Integer limit_x;
        public String object_x;
        public ToolingService.FlowOutputFieldAssignment[] outputAssignments;
        public String picklistField;
        public String picklistObject;
        public String sortField;
        public String sortOrder;
        public String valueField;
    }

    public class FlowRecordFilter extends FlowBaseElement {
        public String field;
        public String operator;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowOutputFieldAssignment extends FlowBaseElement {
        public String assignToReference;
        public String field;
    }

    public class FlowFormula extends FlowElement {
        public String dataType;
        public String expression;
        public Integer scale;
    }

    public class FlowLoop extends FlowNode {
        public String assignNextValueToReference;
        public String collectionReference;
        public String iterationOrder;
        public ToolingService.FlowConnector nextValueConnector;
        public ToolingService.FlowConnector noMoreValuesConnector;
    }

    public class FlowRecordCreate extends FlowNode {
        public String assignRecordIdToReference;
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowConnector faultConnector;
        public ToolingService.FlowInputFieldAssignment[] inputAssignments;
        public String inputReference;
        public String object_x;
    }

    public class FlowInputFieldAssignment extends FlowBaseElement {
        public String field;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowRecordDelete extends FlowNode {
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowConnector faultConnector;
        public ToolingService.FlowRecordFilter[] filters;
        public String inputReference;
        public String object_x;
    }

    public class FlowRecordLookup extends FlowNode {
        public Boolean assignNullValuesIfNoRecordsFound;
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowConnector faultConnector;
        public ToolingService.FlowRecordFilter[] filters;
        public Boolean getFirstRecordOnly;
        public String object_x;
        public ToolingService.FlowOutputFieldAssignment[] outputAssignments;
        public String outputReference;
        public String[] queriedFields;
        public String sortField;
        public String sortOrder;
        public Boolean storeOutputAutomatically;
    }

    public class FlowRecordUpdate extends FlowNode {
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowConnector faultConnector;
        public ToolingService.FlowRecordFilter[] filters;
        public ToolingService.FlowInputFieldAssignment[] inputAssignments;
        public String inputReference;
        public String object_x;
    }

    public class FlowScreen extends FlowNode {
        public Boolean allowBack;
        public Boolean allowFinish;
        public Boolean allowPause;
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowScreenField[] fields;
        public String helpText;
        public String pausedText;
        public ToolingService.FlowScreenRule[] rules;
        public Boolean showFooter;
        public Boolean showHeader;
    }

    public class FlowScreenField extends FlowElement {
        public String[] choiceReferences;
        public String dataType;
        public String defaultSelectedChoiceReference;
        public ToolingService.FlowElementReferenceOrValue defaultValue;
        public String extensionName;
        public String fieldText;
        public String fieldType;
        public String helpText;
        public ToolingService.FlowScreenFieldInputParameter[] inputParameters;
        public Boolean isRequired;
        public Boolean isVisible;
        public ToolingService.FlowScreenFieldOutputParameter[] outputParameters;
        public Integer scale;
        public ToolingService.FlowInputValidationRule validationRule;
    }

    public class FlowScreenFieldInputParameter {
        public String name;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowScreenFieldOutputParameter {
        public String assignToReference;
        public String name;
    }

    public class FlowScreenRule {
        public String conditionLogic;
        public ToolingService.FlowCondition[] conditions;
        public String label;
        public ToolingService.FlowScreenRuleAction[] ruleActions;
    }

    public class FlowScreenRuleAction {
        public String attribute;
        public String fieldReference;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowStage {
        public Boolean isActive;
        public String label;
        public Integer stageOrder;
    }

    public class FlowStart extends FlowNode {
        public ToolingService.FlowConnector connector;
        public ToolingService.FlowRecordFilter[] filters;
        public String object_x;
        public String recordTriggerType;
        public ToolingService.FlowSchedule schedule;
        public String triggerType;
    }

    public class FlowSchedule {
        public String frequency;
        public Date startDate;
        public DateTime startTime;
    }

    public class FlowStep extends FlowNode {
        public ToolingService.FlowConnector[] connectors;
    }

    public class FlowSubflow extends FlowNode {
        public ToolingService.FlowConnector connector;
        public String flowName;
        public ToolingService.FlowSubflowInputAssignment[] inputAssignments;
        public ToolingService.FlowSubflowOutputAssignment[] outputAssignments;
    }

    public class FlowSubflowInputAssignment extends FlowBaseElement {
        public String name;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowSubflowOutputAssignment extends FlowBaseElement {
        public String assignToReference;
        public String name;
    }

    public class FlowTextTemplate extends FlowElement {
        public String text;
    }

    public class FlowVariable extends FlowElement {
        public String dataType;
        public Boolean isCollection;
        public Boolean isInput;
        public Boolean isOutput;
        public String objectType;
        public Integer scale;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowWait extends FlowNode {
        public ToolingService.FlowConnector defaultConnector;
        public String defaultConnectorLabel;
        public ToolingService.FlowConnector faultConnector;
        public ToolingService.FlowWaitEvent[] waitEvents;
    }

    public class FlowWaitEvent extends FlowElement {
        public String conditionLogic;
        public ToolingService.FlowCondition[] conditions;
        public ToolingService.FlowConnector connector;
        public String eventType;
        public ToolingService.FlowWaitEventInputParameter[] inputParameters;
        public String label;
        public ToolingService.FlowWaitEventOutputParameter[] outputParameters;
    }

    public class FlowWaitEventInputParameter extends FlowBaseElement {
        public String name;
        public ToolingService.FlowElementReferenceOrValue value;
    }

    public class FlowWaitEventOutputParameter extends FlowBaseElement {
        public String assignToReference;
        public String name;
    }

}