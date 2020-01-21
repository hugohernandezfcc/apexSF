trigger manageRelatedInfo on Account (after update) {

	if(trigger.new[0].Activa__c != trigger.old[0].Activa__c){

		Account acc = [SELECT (
								SELECT Id, Description 
								FROM Opportunities
								WHERE (StageName != 'Closed Lost' OR StageName != 'Closed Won')
							),
							(
								SELECT Id, Rol__c 
								FROM Contacts
								WHERE Rol__c = 'Influyente' 
							)
							FROM Account 
							WHERE Id =: trigger.new[0].Id ]; 

		List<sObject> allObjects = new List<sObject>();
		if(trigger.new[0].Activa__c == 'No'){
			for(Opportunity sObj: acc.Opportunities ) {
				sObj.StageName = 'Closed Lost';
				sObj.Description = 'Cerrada por Cuenta Inactiva';
				allObjects.add(sObj);
			}


		    update allObjects;
		    allObjects = new List<sObject>();
			
			for(Contact sObj: acc.Contacts ) {
				ExCliente__c exc = new ExCliente__c();
				exc.Contact__c = sObj.Id;
				exc.Generado_automaticamente__c = true;
				allObjects.add(exc);	
			}


		    insert allObjects;
			
					            
		}
	}
}