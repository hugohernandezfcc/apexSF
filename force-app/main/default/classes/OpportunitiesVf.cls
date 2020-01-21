/**
 * Clase responsable de manejar exportación, visualización y redirección de los registros
 * de oportunidad.
 */
public with sharing class OpportunitiesVf {

	public String header{
		get{
			return 'Id, Name, Account Name, Amount, CloseDate, Stage Name, Type';
		}
	}
	public List<Opportunity> currentOpportunities{
		get;set;
	}
	public Opportunity currentOpportunity{
		get;set;
	}


	/**
	 * Método responsable de obtener las oportunidades creadas del mes en curso.
	 */
    public void exportToExcel(){
    	currentOpportunities = [SELECT Id, Name, Account.Name, Amount, CloseDate, StageName, Type 
    							FROM Opportunity 
    							WHERE CreatedDate = THIS_MONTH];
    	
    }

    /**
     * Método encargado de proveer los detalles de la oportunidad al PDF.
     */
    public void showDetailsPdf(){

    	currentOpportunity = [SELECT Id, Name, Account.Name, Amount, CloseDate, StageName, Type 
    							FROM Opportunity 
    							WHERE Id =: Apexpages.currentpage().getparameters().get('recordId')];
    }

    /**
     * Método responsable de ejecutar la descarga del excel aprovechando el formato de la misma.
     *
     * @return     The page reference.
     */
    public PageReference exportToExcelPageRef(){
    	PageReference target = new PageReference('/apex/OpportunitiesToExcel');
        return target;
    }

    /**
     * Lista de oportunidades para el componente
     *
     * @return     Oportunidades.
     */
    @AuraEnabled
    public static List<Opportunity> getOpportunities(String idAcc){

        List<Opportunity> opps = new List<Opportunity>();
        opps = [SELECT Id, Name, Account.Name, Amount, CloseDate, StageName, Type 
                FROM Opportunity
                    WHERE CreatedDate = THIS_MONTH AND AccountId =: idAcc AND (StageName = 'Closed Lost' OR StageName = 'Closed Won')];

        return opps;
    }

}
