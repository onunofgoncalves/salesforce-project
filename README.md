# Product List - LWC

## Overview  
The **ProductList** Lightning Web Component (LWC) fetches and displays products stored in the **Product__c** Salesforce object. It allows users to search, filter by brand and category, view stock details, and access individual product records in Salesforce.  

This component also integrates with an external API ([dummyjson.com/products](https://dummyjson.com/products)) to fetch product data, which is then stored in Salesforce.  

---

## Features  
✅ Fetches product data from the **Product__c** Salesforce object.  
✅ Search functionality to find products by name.  
✅ Filter options for **Brand** and **Category**.  
✅ Displays total stock count for all available products.  
✅ Click a product to navigate to its **Salesforce record**.  
✅ **Refresh button** to reload all products and reset filters.  
✅ Integration with an **external API** to store product data in Salesforce.  

---

## Installation & Deployment  

### Prerequisites  
- **Salesforce CLI**  
- **Developer Org or Sandbox** with API access  
- **Product__c Object:** The org must contain a custom object named **Product__c** with the following fields:  

| Field Name      | Type          | Notes |
|----------------|--------------|--------------------------|
| **Name__c**    | Text         | Product name |
| **Category__c** | Picklist/Text | Product category |
| **Brand__c**   | Picklist/Text | Product brand |
| **Price__c**   | Currency      | Product price |
| **Stock__c**   | Number        | Available stock quantity |
| **ImageUrl__c** | URL         | Image link of the product |
| **External_ID__c** | Text (Unique) | Unique identifier |

---

## Deployment Steps  

1. **Push the LWC to Salesforce**  

2. **Assign the LWC to a Lightning Page**  
 
3. **Ensure Apex Controller is Deployed**
	
---

## Usage  

Once deployed, the **ProductList** component will be available in the Salesforce org. Users can:  
🔍 **Search** for products using the search bar.  
📌 **Filter** products using the **Brand** and **Category** dropdowns.  
🖱️ **Click** a product to open its **Salesforce record**.  
🔄 **Refresh** the product list to reload from the database and reset filters.  

---

## Author Comment  

During the development of this LWC, I successfully integrated the external API ([dummyjson.com/products](https://dummyjson.com/products)) to retrieve and store product data in Salesforce.  

Since I haven't previously implemented authenticated API calls within a Salesforce LWC, I decided to proceed with an **open API connection** to ensure the core functionality of the component—such as product retrieval, filtering, and record navigation—was fully operational.  
This approach allowed me to focus on the **main requirements** of the exercise without introducing potential issues that could disrupt the component's performance.  

That said, I have reviewed the **authentication methods** provided by the API, including **Bearer Token authentication** via the `/auth/login` endpoint. Given more time or guidance, I would be eager to implement secure authentication properly, ensuring that API requests are **authorized** while maintaining best practices in Salesforce Apex and LWC security.  

I appreciate the opportunity to work on this and would be happy to discuss potential improvements or authentication implementation strategies in the future.  

**Best regards,**  
*Nuno Pinto Gonçalves*  
