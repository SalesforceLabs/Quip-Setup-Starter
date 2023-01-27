@isTest
private class LiveDataFeedHandlerTest {
    
    @isTest static void deployLiveDataFeedTest() {
        Test.setMock(HttpCalloutMock.class, new ToolingAPIMetadataHttpCalloutMock());

        LiveDataFeedHandler.deployLiveDataFeed('Account', 'Account', 'https://quip.com/test', 'test', true, 'Name', true, 'EqualTo', 'test', true);
        LiveDataFeedHandler.deployLiveDataFeed('Account', 'Account', 'https://quip.com/test', 'test', false, 'Name', true, 'EqualTo', 'test', true);
        LiveDataFeedHandler.deployLiveDataFeed('Account', 'Account', 'https://quip.com/test', 'test', true, 'Name', true, 'EqualTo', 'test', false);
        LiveDataFeedHandler.deployLiveDataFeed('Account', 'Account', 'https://quip.com/test', 'test', false, 'Name', true, 'EqualTo', 'test', false);
        LiveDataFeedHandler.deployLiveDataFeed('Account', 'Account', 'https://quip.com/test', 'test', false, 'Name', false, 'EqualTo', 'test', false);

    }

    @isTest static void checkRunsTest() {
        LiveDataFeedHandler.storeRun('data-feed', 'Opportunity', 'https://quip.com/test', 'creation', '', 1234567890);
        LiveDataFeedHandler.getLastRun('data-feed');
    }

}