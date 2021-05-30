/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cgroup = new CollaborationGroup();
        cgroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cgroup.CanHaveGuests = false;
        cgroup.CollaborationType = 'Public';
        cgroup.IsArchived = false;
        cgroup.IsAutoArchiveDisabled = false;
        return cgroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Schema.PicklistEntry> lstFamily = Product2.getSObjectType().getDescribe().fields.getMap().get('Family').getDescribe().getPicklistValues();
        List<Product2> lstProd = new List<Product2>();
        for (Integer idx = 0; idx < cnt; idx++) {
            lstProd.add(new Product2(
                Name = 'Prod ' + idx,
                IsActive = true,
                Initial_Inventory__c = 10,
                Family = lstFamily[Math.Mod(idx, lstFamily.size())].getValue()
            ));
        }

        return lstProd;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook

        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 product: prods) {
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbe.Product2Id = product.Id;
            pbe.IsActive = true;
            pbe.UnitPrice = 1;
            pbes.add(pbe);
        }
        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.

        List<Account> accts = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            Account acct = new Account();
            acct.Name = 'Account ' + i;
            accts.add(acct);
        }
        return accts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.

        Integer listSize = accts.size();
        
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            Contact c = new Contact();
            c.LastName = 'Contact ' + i;
            c.AccountId = accts[Math.mod(i, listSize)].Id;
            contactList.add(c);
        }
        
        return contactList;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.

        Integer listSize = accts.size();
        
        List<Order> orders = new List<Order>();
        
        for (Integer i = 0; i < cnt; i++) {
            Order o = new Order(
                Name = 'Order ' + i,
                AccountId = accts[Math.mod(i, listSize)].Id,
                EffectiveDate = Date.today(),
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                Status = 'Draft');
            orders.add(o);
        }
        
        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge

        Integer pbeListSize = pbes.size();
        Integer orderListSize = ords.size();
        
        List<OrderItem> orderItemList = new List<OrderItem>();
        
        for (Integer i = 0; i < cnt; i++) {
            OrderItem oi = new OrderItem(
                OrderId = ords[Math.mod(i, orderListSize)].Id,
                PriceBookEntryId = pbes[Math.mod(i, pbeListSize)].Id,
                Quantity = Constants.DEFAULT_ROWS,
                UnitPrice = 1);
            orderItemList.add(oi);
        }
        
        return orderItemList;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.

        insert constructCollaborationGroup();
        
        List<Product2> productList = constructProducts(cnt);
        insert productList;
        
        List<PricebookEntry> pbes = constructPricebookEntries(productList);
        insert pbes;
        
        List<Account> accts = constructAccounts(cnt);
        insert accts;
        insert constructContacts(cnt, accts);
        
        List<Order> ords = constructOrders(cnt, accts);
        insert ords;
        
        insert constructOrderItems(cnt, pbes, ords);
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        Integer sumQuantity = Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;
        System.assertEquals(updatedProduct.Quantity_Ordered__c, sumQuantity);
    }
}