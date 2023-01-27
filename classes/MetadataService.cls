public class MetadataService {
	
	public static String SOAP_M_URI = 'http://soap.sforce.com/2006/04/metadata';
    
    public virtual class Metadata {
        public String fullName;
    }
    public class SaveResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors',SOAP_M_URI,null,'0','-1','false'};
        private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'1','1','false'};
        private String[] success_type_info = new String[]{'success',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'errors','fullName','success'};
    }
    public class ExtendedErrorDetails {
        public String extendedErrorCode;
        private String[] extendedErrorCode_type_info = new String[]{'extendedErrorCode',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorCode'};
    }
    public class readMetadataResponse_element {
        public MetadataService.ReadResult result;
        private String[] result_type_info = new String[]{'result',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class retrieve_element {
        public MetadataService.RetrieveRequest retrieveRequest;
        private String[] retrieveRequest_type_info = new String[]{'retrieveRequest',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'retrieveRequest'};
    }
    public class PermissionSetTabSetting {
        public String tab;
        public String visibility;
        private String[] tab_type_info = new String[]{'tab',SOAP_M_URI,null,'1','1','false'};
        private String[] visibility_type_info = new String[]{'visibility',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'tab','visibility'};
    }
    public class PermissionSetUserPermission {
        public Boolean enabled;
        public String name;
        private String[] enabled_type_info = new String[]{'enabled',SOAP_M_URI,null,'1','1','false'};
        private String[] name_type_info = new String[]{'name',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'enabled','name'};
    }
    public class PermissionSetFieldPermissions {
        public Boolean editable;
        public String field;
        public Boolean readable;
        private String[] editable_type_info = new String[]{'editable',SOAP_M_URI,null,'1','1','false'};
        private String[] field_type_info = new String[]{'field',SOAP_M_URI,null,'1','1','false'};
        private String[] readable_type_info = new String[]{'readable',SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'editable','field','readable'};
    }
    public class RetrieveRequest {
        public Double apiVersion;
        public String[] packageNames;
        public Boolean singlePackage;
        public String[] specificFiles;
        public MetadataService.Package_x unpackaged;
        private String[] apiVersion_type_info = new String[]{'apiVersion',SOAP_M_URI,null,'1','1','false'};
        private String[] packageNames_type_info = new String[]{'packageNames',SOAP_M_URI,null,'0','-1','false'};
        private String[] singlePackage_type_info = new String[]{'singlePackage',SOAP_M_URI,null,'1','1','false'};
        private String[] specificFiles_type_info = new String[]{'specificFiles',SOAP_M_URI,null,'0','-1','false'};
        private String[] unpackaged_type_info = new String[]{'unpackaged',SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'apiVersion','packageNames','singlePackage','specificFiles','unpackaged'};
    }
    public class AsyncResult {
        public Boolean done;
        public String id;
        public String message;
        public String state;
        public String statusCode;
        private String[] done_type_info = new String[]{'done',SOAP_M_URI,null,'1','1','false'};
        private String[] id_type_info = new String[]{'id',SOAP_M_URI,null,'1','1','false'};
        private String[] message_type_info = new String[]{'message',SOAP_M_URI,null,'0','1','false'};
        private String[] state_type_info = new String[]{'state',SOAP_M_URI,null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode',SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'done','id','message','state','statusCode'};
    }
    public class retrieveResponse_element {
        public MetadataService.AsyncResult result;
        private String[] result_type_info = new String[]{'result',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class PermissionSetRecordTypeVisibility {
        public String recordType;
        public Boolean visible;
        private String[] recordType_type_info = new String[]{'recordType',SOAP_M_URI,null,'1','1','false'};
        private String[] visible_type_info = new String[]{'visible',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'recordType','visible'};
    }
    public class PermissionSet extends Metadata {
        public String type = 'PermissionSet';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'0','1','false'};
        public MetadataService.PermissionSetApplicationVisibility[] applicationVisibilities;
        public MetadataService.PermissionSetApexClassAccess[] classAccesses;
        public MetadataService.PermissionSetCustomPermissions[] customPermissions;
        public String description;
        public MetadataService.PermissionSetExternalDataSourceAccess[] externalDataSourceAccesses;
        public MetadataService.PermissionSetFieldPermissions[] fieldPermissions;
        public Boolean hasActivationRequired;
        public String label;
        public String license;
        public MetadataService.PermissionSetObjectPermissions[] objectPermissions;
        public MetadataService.PermissionSetApexPageAccess[] pageAccesses;
        public MetadataService.PermissionSetRecordTypeVisibility[] recordTypeVisibilities;
        public MetadataService.PermissionSetTabSetting[] tabSettings;
        public MetadataService.PermissionSetUserPermission[] userPermissions;
        private String[] applicationVisibilities_type_info = new String[]{'applicationVisibilities',SOAP_M_URI,null,'0','-1','false'};
        private String[] classAccesses_type_info = new String[]{'classAccesses',SOAP_M_URI,null,'0','-1','false'};
        private String[] customPermissions_type_info = new String[]{'customPermissions',SOAP_M_URI,null,'0','-1','false'};
        private String[] description_type_info = new String[]{'description',SOAP_M_URI,null,'0','1','false'};
        private String[] externalDataSourceAccesses_type_info = new String[]{'externalDataSourceAccesses',SOAP_M_URI,null,'0','-1','false'};
        private String[] fieldPermissions_type_info = new String[]{'fieldPermissions',SOAP_M_URI,null,'0','-1','false'};
        private String[] hasActivationRequired_type_info = new String[]{'hasActivationRequired',SOAP_M_URI,null,'0','1','false'};
        private String[] label_type_info = new String[]{'label',SOAP_M_URI,null,'1','1','false'};
        private String[] license_type_info = new String[]{'license',SOAP_M_URI,null,'0','1','false'};
        private String[] objectPermissions_type_info = new String[]{'objectPermissions',SOAP_M_URI,null,'0','-1','false'};
        private String[] pageAccesses_type_info = new String[]{'pageAccesses',SOAP_M_URI,null,'0','-1','false'};
        private String[] recordTypeVisibilities_type_info = new String[]{'recordTypeVisibilities',SOAP_M_URI,null,'0','-1','false'};
        private String[] tabSettings_type_info = new String[]{'tabSettings',SOAP_M_URI,null,'0','-1','false'};
        private String[] userPermissions_type_info = new String[]{'userPermissions',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'applicationVisibilities','classAccesses','customPermissions','description','externalDataSourceAccesses','fieldPermissions','hasActivationRequired','label','license','objectPermissions','pageAccesses','recordTypeVisibilities','tabSettings','userPermissions'};
    }
    public class PermissionSetApexClassAccess {
        public String apexClass;
        public Boolean enabled;
        private String[] apexClass_type_info = new String[]{'apexClass',SOAP_M_URI,null,'1','1','false'};
        private String[] enabled_type_info = new String[]{'enabled',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'apexClass','enabled'};
    }
    public class Error {
        public MetadataService.ExtendedErrorDetails[] extendedErrorDetails;
        public String[] fields;
        public String message;
        public String statusCode;
        private String[] extendedErrorDetails_type_info = new String[]{'extendedErrorDetails',SOAP_M_URI,null,'0','-1','false'};
        private String[] fields_type_info = new String[]{'fields',SOAP_M_URI,null,'0','-1','false'};
        private String[] message_type_info = new String[]{'message',SOAP_M_URI,null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorDetails','fields','message','statusCode'};
    }
    public class updateMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'metadata'};
    }
    public class updateMetadataResponse_element {
        public MetadataService.SaveResult[] result;
        private String[] result_type_info = new String[]{'result',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class createMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'metadata'};
    }
    public class createMetadataResponse_element {
        public MetadataService.SaveResult[] result;
        private String[] result_type_info = new String[]{'result',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class PermissionSetApexPageAccess {
        public String apexPage;
        public Boolean enabled;
        private String[] apexPage_type_info = new String[]{'apexPage',SOAP_M_URI,null,'1','1','false'};
        private String[] enabled_type_info = new String[]{'enabled',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'apexPage','enabled'};
    }
    public class PermissionSetExternalDataSourceAccess {
        public Boolean enabled;
        public String externalDataSource;
        private String[] enabled_type_info = new String[]{'enabled',SOAP_M_URI,null,'1','1','false'};
        private String[] externalDataSource_type_info = new String[]{'externalDataSource',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'enabled','externalDataSource'};
    }
    public class PermissionSetCustomPermissions {
        public Boolean enabled;
        public String name;
        private String[] enabled_type_info = new String[]{'enabled',SOAP_M_URI,null,'1','1','false'};
        private String[] name_type_info = new String[]{'name',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'enabled','name'};
    }
    public interface IReadResult {
        MetadataService.Metadata[] getRecords();
    }
    public interface IReadResponseElement {
        IReadResult getResult();
    }
    public class ReadPermissionSetResult implements IReadResult {
        public MetadataService.PermissionSet[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public class readPermissionSetResponse_element implements IReadResponseElement {
        public MetadataService.ReadPermissionSetResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class readMetadata_element {
        public String type_x;
        public String[] fullNames;
        private String[] type_x_type_info = new String[]{'type',SOAP_M_URI,null,'1','1','false'};
        private String[] fullNames_type_info = new String[]{'fullNames',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fullNames'};
    }
    public class PermissionSetObjectPermissions {
        public Boolean allowCreate;
        public Boolean allowDelete;
        public Boolean allowEdit;
        public Boolean allowRead;
        public Boolean modifyAllRecords;
        public String object_x;
        public Boolean viewAllRecords;
        private String[] allowCreate_type_info = new String[]{'allowCreate',SOAP_M_URI,null,'1','1','false'};
        private String[] allowDelete_type_info = new String[]{'allowDelete',SOAP_M_URI,null,'1','1','false'};
        private String[] allowEdit_type_info = new String[]{'allowEdit',SOAP_M_URI,null,'1','1','false'};
        private String[] allowRead_type_info = new String[]{'allowRead',SOAP_M_URI,null,'1','1','false'};
        private String[] modifyAllRecords_type_info = new String[]{'modifyAllRecords',SOAP_M_URI,null,'1','1','false'};
        private String[] object_x_type_info = new String[]{'object',SOAP_M_URI,null,'1','1','false'};
        private String[] viewAllRecords_type_info = new String[]{'viewAllRecords',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object_x','viewAllRecords'};
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category',SOAP_M_URI,null,'1','1','false'};
        private String[] level_type_info = new String[]{'level',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
    public class DebuggingHeader_element {
        public MetadataService.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories',SOAP_M_URI,null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
    public class PackageTypeMembers {
        public String[] members;
        public String name;
        private String[] members_type_info = new String[]{'members',SOAP_M_URI,null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'members','name'};
    }
    public class ProfileObjectPermissions {
        public Boolean allowCreate;
        public Boolean allowDelete;
        public Boolean allowEdit;
        public Boolean allowRead;
        public Boolean modifyAllRecords;
        public String object_x;
        public Boolean viewAllRecords;
        private String[] allowCreate_type_info = new String[]{'allowCreate',SOAP_M_URI,null,'0','1','false'};
        private String[] allowDelete_type_info = new String[]{'allowDelete',SOAP_M_URI,null,'0','1','false'};
        private String[] allowEdit_type_info = new String[]{'allowEdit',SOAP_M_URI,null,'0','1','false'};
        private String[] allowRead_type_info = new String[]{'allowRead',SOAP_M_URI,null,'0','1','false'};
        private String[] modifyAllRecords_type_info = new String[]{'modifyAllRecords',SOAP_M_URI,null,'0','1','false'};
        private String[] object_x_type_info = new String[]{'object',SOAP_M_URI,null,'1','1','false'};
        private String[] viewAllRecords_type_info = new String[]{'viewAllRecords',SOAP_M_URI,null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object_x','viewAllRecords'};
    }
    public class AllOrNoneHeader_element {
        public Boolean allOrNone;
        private String[] allOrNone_type_info = new String[]{'allOrNone',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'allOrNone'};
    }
    public class ReadResult {
        public MetadataService.Metadata[] records;
        private String[] records_type_info = new String[]{'records',SOAP_M_URI,null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }
    public class Package_x extends Metadata {
        public String type = 'Package_x';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName',SOAP_M_URI,null,'0','1','false'};
        public String apiAccessLevel;
        public String description;
        public String namespacePrefix;
        public MetadataService.ProfileObjectPermissions[] objectPermissions;
        public String packageType;
        public String postInstallClass;
        public String setupWeblink;
        public MetadataService.PackageTypeMembers[] types;
        public String uninstallClass;
        public String version;
        private String[] apiAccessLevel_type_info = new String[]{'apiAccessLevel',SOAP_M_URI,null,'0','1','false'};
        private String[] description_type_info = new String[]{'description',SOAP_M_URI,null,'0','1','false'};
        private String[] namespacePrefix_type_info = new String[]{'namespacePrefix',SOAP_M_URI,null,'0','1','false'};
        private String[] objectPermissions_type_info = new String[]{'objectPermissions',SOAP_M_URI,null,'0','-1','false'};
        private String[] packageType_type_info = new String[]{'packageType',SOAP_M_URI,null,'0','1','false'};
        private String[] postInstallClass_type_info = new String[]{'postInstallClass',SOAP_M_URI,null,'0','1','false'};
        private String[] setupWeblink_type_info = new String[]{'setupWeblink',SOAP_M_URI,null,'0','1','false'};
        private String[] types_type_info = new String[]{'types',SOAP_M_URI,null,'0','-1','false'};
        private String[] uninstallClass_type_info = new String[]{'uninstallClass',SOAP_M_URI,null,'0','1','false'};
        private String[] version_type_info = new String[]{'version',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'apiAccessLevel','description','namespacePrefix','objectPermissions','packageType','postInstallClass','setupWeblink','types','uninstallClass','version'};
    }
    public class PermissionSetApplicationVisibility {
        public String application;
        public Boolean visible;
        private String[] application_type_info = new String[]{'application',SOAP_M_URI,null,'1','1','false'};
        private String[] visible_type_info = new String[]{'visible',SOAP_M_URI,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{SOAP_M_URI,'true','false'};
        private String[] field_order_type_info = new String[]{'application','visible'};
    }
    public class MetadataPort {
        public String endpoint_x = URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/m/48.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public MetadataService.SessionHeader_element SessionHeader;
        public MetadataService.DebuggingInfo_element DebuggingInfo;
        public MetadataService.DebuggingHeader_element DebuggingHeader;
        public MetadataService.CallOptions_element CallOptions;
        public MetadataService.AllOrNoneHeader_element AllOrNoneHeader;
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        private String AllOrNoneHeader_hns = 'AllOrNoneHeader=http://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{SOAP_M_URI, 'MetadataService'};
        public MetadataService.SaveResult[] updateMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.updateMetadata_element request_x = new MetadataService.updateMetadata_element();
            request_x.metadata = metadata;
            MetadataService.updateMetadataResponse_element response_x;
            Map<String, MetadataService.updateMetadataResponse_element> response_map_x = new Map<String, MetadataService.updateMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              SOAP_M_URI,
              'updateMetadata',
              SOAP_M_URI,
              'updateMetadataResponse',
              'MetadataService.updateMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.SaveResult[] createMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.createMetadata_element request_x = new MetadataService.createMetadata_element();
            request_x.metadata = metadata;
            MetadataService.createMetadataResponse_element response_x;
            Map<String, MetadataService.createMetadataResponse_element> response_map_x = new Map<String, MetadataService.createMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              SOAP_M_URI,
              'createMetadata',
              SOAP_M_URI,
              'createMetadataResponse',
              'MetadataService.createMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.IReadResult readMetadata(String type_x,String[] fullNames) {
            MetadataService.readMetadata_element request_x = new MetadataService.readMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            MetadataService.IReadResponseElement response_x;
            Map<String, MetadataService.IReadResponseElement> response_map_x = new Map<String, MetadataService.IReadResponseElement>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              SOAP_M_URI,
              'readMetadata',
              SOAP_M_URI,
              'readMetadataResponse',
              'MetadataService.read' + type_x + 'Response_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getResult();
        }
    }
}