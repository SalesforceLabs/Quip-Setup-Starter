@isTest
private class ToolingServiceTest {
    
    @isTest static void flexiPageTest() {
        ToolingService.FlexiPage page = new ToolingService.FlexiPage();
        System.assertEquals('FlexiPage', page.type);
    }
    
    @isTest static void customFieldTest() {
        ToolingService.CustomField field = new ToolingService.CustomField();
        System.assertEquals('CustomField', field.type);
    }
    
    @isTest static void standardValueTest() {
        ToolingService.StandardValue value = new ToolingService.StandardValue();
        System.assertEquals('StandardValue', value.type);
    }

}