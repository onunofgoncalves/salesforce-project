import { LightningElement, wire, track } from 'lwc';
import getProducts from '@salesforce/apex/ProductController.getProducts';

export default class ProductList extends LightningElement {
    @track products = [];
    @track brandOptions = [];
    @track categoryOptions = [];
    @track selectedBrand = null;
    @track selectedCategory = null;
    searchTerm = '';
    totalStock = 0;

    // Wire the products based on filters
    @wire(getProducts, { searchTerm: '$searchTerm', brandFilter: '$selectedBrand', categoryFilter: '$selectedCategory' })
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data.map(product => ({
                ...product,
                totalStockValue: (product.Stock__c * product.Price__c).toFixed(2),
                productUrl: `/lightning/r/Product__c/${product.Id}/view` // Correct Salesforce URL format
            }));

            this.totalStock = this.products.reduce((sum, product) => sum + product.Stock__c, 0);

            // Populate brand and category filters dynamically
            const uniqueCategories = new Set();
            const uniqueBrands = new Set();

            this.products.forEach(product => {
                if (product.Category__c) uniqueCategories.add(product.Category__c);
                if (product.Brand__c) uniqueBrands.add(product.Brand__c);
            });

            this.categoryOptions = [...uniqueCategories].map(cat => ({ label: cat, value: cat }));
            this.brandOptions = [...uniqueBrands].map(brand => ({ label: brand, value: brand }));
        } else if (error) {
            console.error('Error fetching products:', error);
        }
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    handleBrandChange(event) {
        this.selectedBrand = event.target.value;
        this.loadProducts();
    }

    handleCategoryChange(event) {
        this.selectedCategory = event.target.value;
        this.loadProducts();
    }

    handleRefresh() {
        // Reset filters and reload all products
        this.selectedBrand = null;
        this.selectedCategory = null;
        this.loadProducts();
    }

    loadProducts() {
        // Fetch the products with or without filters based on selected Brand and selected Category
        getProducts({
            searchTerm: this.searchTerm,
            brandFilter: this.selectedBrand,
            categoryFilter: this.selectedCategory
        })
        .then(data => {
            this.products = data.map(product => ({
                ...product,
                totalStockValue: (product.Stock__c * product.Price__c).toFixed(2),
                productUrl: `/lightning/r/Product__c/${product.Id}/view` // Correct Salesforce URL format
            }));
            this.totalStock = this.products.reduce((sum, product) => sum + product.Stock__c, 0);
        })
        .catch(error => {
            console.error('Error loading products:', error);
        });
    }
}
