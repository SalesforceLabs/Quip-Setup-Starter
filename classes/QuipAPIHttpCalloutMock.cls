@isTest
global class QuipAPIHttpCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');

        String body = '{"folder": {"id": "1"}, "success": true}';
        response.setBody(body);
        response.setStatusCode(200);
        return response;
    }

}