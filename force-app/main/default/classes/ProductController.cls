public with sharing class ProductController {
    private static final String API_URL = 'https://dummyjson.com/products';

    //Retrieves a filtered list of Product__c records from the database.
    @AuraEnabled(cacheable=true)
    public static List<Product__c> getProducts(String searchTerm, List<String> brandFilter, List<String> categoryFilter) {
        String query = 'SELECT Name__c, Category__c, Brand__c, Price__c, Stock__c, ImageUrl__c FROM Product__c WHERE Id != null';

        if (searchTerm != null && searchTerm != '') {
            query += ' AND Name__c LIKE \'%' + searchTerm + '%\'';
        }

        if (brandFilter != null && !brandFilter.isEmpty()) {
            query += ' AND Brand__c IN :brandFilter';
        }

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            query += ' AND Category__c IN :categoryFilter';
        }

        query += ' ORDER BY Category__c, Price__c ASC';
        return Database.query(query);
    }

    //Fetches product data from an external API and stores it in Salesforce.
    @AuraEnabled
    public static void fetchAndStoreProducts() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(API_URL);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> productsList = (List<Object>) jsonResponse.get('products');
            List<Map<String, Object>> products = new List<Map<String, Object>>();

            for (Object obj : productsList) {
                products.add((Map<String, Object>) obj);
            }

            Map<String, List<Product__c>> categoryMap = new Map<String, List<Product__c>>();
            List<Product__c> productRecords = new List<Product__c>();

            for (Map<String, Object> product : products) {
                String category = String.valueOf(product.get('category'));
                Decimal price = Decimal.valueOf(String.valueOf(product.get('price')));
                
                // Check and enforce business logic limits
                if (!categoryMap.containsKey(category)) {
                    categoryMap.put(category, new List<Product__c>());
                }
                
                List<Product__c> categoryProducts = categoryMap.get(category);
                Decimal totalPrice = 0;
                for (Product__c p : categoryProducts) {
                    totalPrice += p.Price__c;
                }

                // Ensure the category does not exceed 100 products or a total price of 10,000
                if (categoryProducts.size() < 100 && (totalPrice + price) < 10000) {
                    Product__c p = new Product__c(
                        External_ID__c = String.valueOf(product.get('id')),
                        Name__c = String.valueOf(product.get('title')),
                        Category__c = category,
                        Brand__c = String.valueOf(product.get('brand')),
                        Price__c = price,
                        Stock__c = Integer.valueOf(product.get('stock')),
                        ImageUrl__c = String.valueOf(product.get('thumbnail'))
                    );

                    categoryProducts.add(p);
                    productRecords.add(p);
                }
            }

            // Insert or update records using External_ID__c to avoid duplicates
            if (!productRecords.isEmpty()) {
                upsert productRecords Product__c.External_ID__c;
            }
        }
    }
}