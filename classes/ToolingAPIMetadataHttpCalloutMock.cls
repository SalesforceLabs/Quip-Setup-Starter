@isTest
global class ToolingAPIMetadataHttpCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');

        response.setBody('{"FullName": "Test", "Metadata": {}, "success": true, "id": "301123456789012"}');
        response.setStatusCode(200);
        return response; 
    }

}