({
    fetchOpps : function(component, event) {
        component.set('v.mycolumns', [
            {label: 'Oportunidad', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Cuenta', fieldName: 'AccountName', type: 'text'},
            {label: 'Monto', fieldName: 'Amount', type: 'currency'},
            {label: 'Fecha Cierre', fieldName: 'CloseDate', type: 'Text'},
            {label: 'Etapa', fieldName: 'StageName', type: 'Text'},
            {label: 'Tipo', fieldName: 'Type', type: 'Text'}
        ]);



        var action = component.get("c.getOpportunities");
        action.setParams({
        	idAcc: component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                console.log(records);
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    record.AccountName = record.Account.Name;
                });
                component.set("v.mydata", records);
            }
        });
        $A.enqueueAction(action);
    }
})
