public class Product2Extension{
	public List<ProductWrapper> productsToInsert{ get; set; }

	public Product2Extension(ApexPages.StandardController controller){
		productsToInsert = new List<ProductWrapper>();
		AddRows();
	}

	public void AddRows(){
		for (Integer i = 0; i < Constants.DEFAULT_ROWS; i + +){
			productsToInsert.add(new ProductWrapper());
		}
	}

	public List<ChartHelper.ChartData> GetInventory(){
		return ChartHelper.GetInventory();
	}

	public PageReference Save(){
		SavePoint sp = Database.setSavepoint();

		try{
			List<Product2> prodToInsert = new List<Product2>();
			List<PriceBookEntry> pbeToInsert = new List<PriceBookEntry>();
			List<ProductWrapper> filteredProductWrappers = new List<ProductWrapper>();

			for (ProductWrapper pwLoopVar : productsToInsert){
				filteredProductWrappers.add(pwLoopVar);

				/*if (!String.isBlank(pwLoopVar.productRecord.Name) &&
				 !String.isBlank(pwLoopVar.productRecord.Family) &&
				 pwLoopVar.productRecord.Family != Constants.SELECT_ONE &&
				 pwLoopVar.productRecord.isActive &&
				 pwLoopVar.pricebookEntryRecord.UnitPrice != null &&
				 pwLoopVar.productRecord.Initial_Inventory__c != null &&
				 pwLoopVar.productRecord.Initial_Inventory__c != 0 &&
				 pwLoopVar.pricebookEntryRecord.UnitPrice != 0 ) {

				 filteredProductWrappers.add(pwLoopVar);
				 }*/
			}

			for (ProductWrapper pwLoopVarNew : filteredProductWrappers){
				prodToInsert.add(pwLoopVarNew.productRecord);
			}
			Database.SaveResult[] productSaveResults = Database.INSERT(prodToInsert, false);

			for (Integer i = 0; i < productSaveResults.size(); i++){
				if (productSaveResults[i].isSuccess()){
					PriceBookEntry pbe = filteredProductWrappers[i].pricebookEntryRecord;
					pbe.Product2Id = productSaveResults[i].getId();
					pbe.IsActive = true;
					pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
					pbeToInsert.add(pbe);
				}
			}
			Database.SaveResult[] pbeSaveResults = Database.INSERT(pbeToInsert, false);

			//If successful clear the list and display an informational message
			apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, pbeToInsert.size()+' Records Inserted'));

			productsToInsert.clear();   //Do not remove
			AddRows();  //Do not remove

		} catch (Exception e){
			System.debug('Exception occured:' + e.getMessage());
			Database.rollback(sp);
			apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
		}
		return null;
	}

	//method to be used by the Family picklist on the VF page
	public List<SelectOption> GetFamilyOptions(){
		List<SelectOption> vfPicklistOptions = new List<SelectOption>();

		//Set first option value and label from the Constants class which fetches from Custom Label
		vfPicklistOptions.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));

		//Add rest options from the Family picklist by fetching it through Constants class
		for (PickListEntry eachPicklistVal : Constants.PRODUCT_FAMILY)
			vfPicklistOptions.add(new SelectOption(eachPicklistVal.getValue(), eachPicklistVal.getLabel()));
		return vfPicklistOptions;
	}

	public class ProductWrapper{
		public Product2 productRecord{ get; set; }

		public PriceBookEntry pricebookEntryRecord{ get; set; }

		public ProductWrapper(){
			productRecord = new Product2();
			pricebookEntryRecord = new PricebookEntry();
		}
	}
}