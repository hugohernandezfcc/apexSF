trigger callerWsOpportunities on Opportunity (after update) {

	List<Id> ids = new List<Id>();

	for(Opportunity sObj: trigger.new) {
		if(sObj.StageName == 'Closed Won'){
			ids.add(sObj.Id); 
		}
	}

	if(ids.size() > 0)
		CallerWS.caller(ids);
}