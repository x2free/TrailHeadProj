public class Product2Extension {
    public List<Product2> productsToInsert {get;set;}
    public List<ProductWrapper> lstProdWrapper {get; set;}

    public Product2Extension(){
        productsToInsert = new List<Product2>();
        lstProdWrapper = new List<ProductWrapper>();

        addRows();
    }

    public void AddRows(){
        for ( Integer i = 0; i < Constants.DEFAULT_ROWS; i++ ){
            // productsToInsert.add( new Product2() );
            ProductWrapper wrapper = new ProductWrapper();
            wrapper.productRecord = new Product2();
            wrapper.pricebookEntryRecord = new PricebookEntry();

            lstProdWrapper.add(wrapper);
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

            for (ProductWrapper wrapper : lstProdWrapper) {
                lstProd.add(wrapper.productRecord);
            }

            insert lstProd;

            for (ProductWrapper wrapper : lstProdWrapper) {
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
            // productsToInsert.clear();   //Do not remove
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
    }
}