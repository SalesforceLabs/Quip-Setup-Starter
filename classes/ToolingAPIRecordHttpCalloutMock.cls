@isTest
global class ToolingAPIRecordHttpCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');

        String body = request.getBody();
        if (body.length() == 0) {
            body = '{"size": 1, "records": [{"FullName": "Test"}]}';
        }
        response.setBody(body);
        response.setStatusCode(200);
        return response; 
    }

}