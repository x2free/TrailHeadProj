public with sharing class Constants {
    public final static Integer DEFAULT_ROWS = 5;
    public final static String SELECT_ONE = System.Label.Select_One;
    public final static String INVENTORY_LEVEL_LOW = System.Label.Inventory_Level_Low;
    public final static List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPicklistValues();
    public final static String DRAFT_ORDER_STATUS = 'Draft';
    public final static String ACTIVATED_ORDER_STATUS = 'Activated';
    public final static String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    public final static String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
    public final static String STANDARD_PRICEBOOK_ID = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
}
