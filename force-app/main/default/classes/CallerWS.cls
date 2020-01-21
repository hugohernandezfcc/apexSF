
public with sharing class CallerWS {
    public class OppsObj {
		public String opportunityName;
		public String opportunityId;
		public String closeDate;
		public Decimal amount;
		public String accountName;
	}
	/**
	 * Método responsable de ejecutar las solicitudes para mandar la lista de oportunidades.
	 *
	 * @param      recordIds  The record identifiers
	 */
	@future(callout=true)
    public static void caller(List<ID> recordIds){

    	List<OppsObj> sOp = new List<OppsObj>();

    	for(Opportunity sObj: [SELECT Id, Name, Account.Name, Amount, CloseDate, StageName, Type 
    							FROM Opportunity 
    							WHERE Id IN: recordIds]) {
    		OppsObj record = new OppsObj();
    		record.opportunityName = sObj.Name;
    		record.opportunityId = sObj.Id;
    		record.closeDate = String.valueOf(sObj.CloseDate);
    		record.amount = sObj.Amount;
    		record.accountName = sObj.Account.Name;

    		sOp.add(record);
    	}
    	String bodyStr = JSON.serialize(sOp);

    	HttpRequest req = new HttpRequest();
		req.setEndpoint('https://opportunities.free.beeceptor.com');
		req.setHeader('Accept', 'application/json');
		req.setHeader('Content-Type', 'application/json;charset=UTF-8');
		req.setMethod('POST');
		req.setbody(bodyStr);

		Http http = new Http();
		HTTPResponse res = http.send(req);


		System.debug(res.getStatusCode());
		System.debug(res.getStatus());
		System.debug(res.getBody());



		List<Opportunity> toUpdate = new List<Opportunity>();
		for(OppsObj sObj: sOp) {
			Opportunity localOpp = new Opportunity();
			localOpp.Id = sObj.opportunityId;
			if(res.getStatus() == 'OK')
				localOpp.StageName = 'Enviado';
			else if(res.getStatus() != 'OK')
					localOpp.StageName = 'Reenviar';

			toUpdate.add(localOpp);
		}
		update toUpdate;

    }

}
