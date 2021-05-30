public class Product2Extension {
    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController stdController){
        productsToInsert = new List<ProductWrapper>();

        addRows();
    }

    public void AddRows(){
        for ( Integer i = 0; i < Constants.DEFAULT_ROWS; i++ ){
            // productsToInsert.add( new Product2() );
            ProductWrapper wrapper = new ProductWrapper();
            wrapper.productRecord = new Product2();
            wrapper.pricebookEntryRecord = new PricebookEntry();

            productsToInsert.add(wrapper);
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public List<SelectOption> GetFamilyOptions(){
        List<Selectoption> lstFamily = new List<Selectoption>();
        lstFamily.add(new SelectOption('--', Constants.SELECT_ONE));
        for (Schema.PicklistEntry entry : Constants.PRODUCT_FAMILY) {
            lstFamily.add(new SelectOption(entry.value, entry.label));
        }

        return lstFamily;
    }

    public PageReference Save(){
        Savepoint sp = Database.SetSavePoint();
        try {
            List<Product2> lstProd = new List<Product2>();
            List<PricebookEntry> lstPBE = new List<PricebookEntry>();

            for (ProductWrapper wrapper : productsToInsert) {
                // if (String.isNotBlank(wrapper.productRecord.Name)
                //     && String.isNotBlank(wrapper.productRecord.Family)
                //     && wrapper.pricebookEntryRecord.UnitPrice != null
                //     && wrapper.productRecord.Initial_Inventory__c != null
                //     && wrapper.productRecord.IsActive) {
                    lstProd.add(wrapper.productRecord);
                // }
            }

            insert lstProd;

            for (ProductWrapper wrapper : productsToInsert) {
                if (String.isBlank(wrapper.productRecord.Id)) {
                    continue;
                }
                
                wrapper.pricebookEntryRecord.Product2Id = wrapper.productRecord.Id;
                wrapper.pricebookEntryRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                wrapper.pricebookEntryRecord.IsActive = true;

                lstPBE.add(wrapper.pricebookEntryRecord);
            }

            insert lstPBE;

            // insert productsToInsert;

            // // Map<Id+price, PricebookEntry> mapProdId2PBE = new Map<Id, PricebookEntry>();
            // List<PricebookEntry> lstPBE = new List<PricebookEntry>();
            // for (Product2 prod : productsToInsert) {
            //     lstPBE.add(new PricebookEntry(
            //         IsActive = true,
            //         // UnitPrice = prod.
            //         Product2Id = prod.Id,
            //         Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
            //         UseStandardPrice = true
            //     ));
            // }

            // insert lstPBE;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, lstProd.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public without sharing class ProductWrapper{
        public Product2 productRecord {get; set;}
        public PricebookEntry pricebookEntryRecord {get; set;}

        public ProductWrapper() {
            productRecord = new Product2(Initial_Inventory__c = 0, Name = 'Test Product', IsActive = true);
            pricebookEntryRecord = new PricebookEntry(Unitprice = 0.0);
        }
    }
}