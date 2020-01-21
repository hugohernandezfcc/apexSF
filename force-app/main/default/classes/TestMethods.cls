@isTest
private class TestMethods {

	private static final String FAKE_RESPONSE_JSON = '';

    private class Mock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {

            // You could assert the request content here

            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE_JSON);
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
    }

    @testSetup static void setup() {

        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<5;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i, Activa__c = 'Si' ));
        }
        insert testAccts;

        List<Contact> testConts = new List<Contact>();

        for(Integer i=0;i<5;i++) {
            testConts.add( new Contact(FirstName = 'TestAcct'+i, LastName = 'LastName'+i, Rol__c = 'Influyente', AccountId = testAccts[i].Id ) );
        }
        insert testConts;

        List<Opportunity> testOpps = new List<Opportunity>();

        for(Integer i=0;i<5;i++) {
            testOpps.add( new Opportunity(Name = 'TestAcct'+i, StageName = 'Prospecting', CloseDate = System.today(), AccountId = testAccts[i].Id ) );
        }
        insert testOpps;

    }

    @isTest static void testMethod1() {

        Account acct = [SELECT Id FROM Account WHERE Name='TestAcct0' LIMIT 1];
        acct.Activa__c = 'No';

        update acct;

        


        Test.setMock(HttpCalloutMock.class, new Mock());

        Test.startTest();
        	Opportunity opps = [SELECT Id FROM Opportunity WHERE Name='TestAcct0' LIMIT 1];
	        opps.StageName = 'Closed Won';

	        update opps;

	        OpportunitiesVf vfs = new OpportunitiesVf();
	        vfs.exportToExcel();
	        vfs.exportToExcelPageRef();
	        String str = vfs.header;
	        List<Opportunity> oppsLocal = OpportunitiesVf.getOpportunities(acct.Id);

	        try {
	        	PageReference pageRef = Page.OpportunitiesDetail; // Add your VF page Name here
				pageRef.getParameters().put('recordId', String.valueOf(opps.Id));

				vfs.showDetailsPdf();
				Test.setCurrentPage(pageRef);
	        } catch(Exception e) {
	        	System.debug(e.getMessage());
	        }

	        

        Test.stopTest();


        
    }
}
