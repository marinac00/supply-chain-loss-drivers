-- 1. Renaming imported table
--ALTER TABLE "datacosupplychaindataset" RENAME TO staging_supply_chain;

-- 2. Rename colunms: snake_case  (bulk rename)
--
ALTER TABLE staging_supply_chain RENAME COLUMN "Type" TO type;
ALTER TABLE staging_supply_chain RENAME COLUMN "Days for shipping (real)" TO days_for_shipping_real;
ALTER TABLE staging_supply_chain RENAME COLUMN "Days for shipment (scheduled)" TO days_for_shipping_scheduled; -- Aquí estaba el error
ALTER TABLE staging_supply_chain RENAME COLUMN "Benefit per order" TO benefit_per_order;
ALTER TABLE staging_supply_chain RENAME COLUMN "Sales per customer" TO sales_per_customer;
ALTER TABLE staging_supply_chain RENAME COLUMN "Delivery Status" TO delivery_status;
ALTER TABLE staging_supply_chain RENAME COLUMN "Late_delivery_risk" TO late_delivery_risk;
ALTER TABLE staging_supply_chain RENAME COLUMN "Category Id" TO category_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Category Name" TO category_name;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer City" TO customer_city;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Country" TO customer_country;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Email" TO customer_email;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Fname" TO customer_fname;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Id" TO customer_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Lname" TO customer_lname;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Password" TO customer_password;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Segment" TO customer_segment;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer State" TO customer_state;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Street" TO customer_street;
ALTER TABLE staging_supply_chain RENAME COLUMN "Customer Zipcode" TO customer_zipcode;
ALTER TABLE staging_supply_chain RENAME COLUMN "Department Id" TO department_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Department Name" TO department_name;
ALTER TABLE staging_supply_chain RENAME COLUMN "Latitude" TO latitude;
ALTER TABLE staging_supply_chain RENAME COLUMN "Longitude" TO longitude;
ALTER TABLE staging_supply_chain RENAME COLUMN "Market" TO market;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order City" TO order_city;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Country" TO order_country;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Customer Id" TO order_customer_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "order date (DateOrders)" TO order_date;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Id" TO order_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Cardprod Id" TO order_item_cardprod_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Discount" TO order_item_discount;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Discount Rate" TO order_item_discount_rate;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Id" TO order_item_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Product Price" TO order_item_product_price;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Profit Ratio" TO order_item_profit_ratio;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Quantity" TO order_item_quantity;
ALTER TABLE staging_supply_chain RENAME COLUMN "Sales" TO sales;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Item Total" TO order_item_total;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Profit Per Order" TO order_profit_per_order;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Region" TO order_region;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order State" TO order_state;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Status" TO order_status;
ALTER TABLE staging_supply_chain RENAME COLUMN "Order Zipcode" TO order_zipcode;
ALTER TABLE staging_supply_chain RENAME COLUMN "Product Card Id" TO product_card_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Product Category Id" TO product_category_id;
ALTER TABLE staging_supply_chain RENAME COLUMN "Product Description" TO product_description;
ALTER TABLE staging_supply_chain RENAME COLUMN "Product Image" TO product_image;
ALTER TABLE staging_supply_chain RENAME COLUMN "Product Name" TO product_name;
ALTER TABLE staging_supply_chain RENAME COLUMN "Product Price" TO product_price;
ALTER TABLE staging_supply_chain RENAME COLUMN "Product Status" TO product_status;
ALTER TABLE staging_supply_chain RENAME COLUMN "shipping date (DateOrders)" TO shipping_date;
ALTER TABLE staging_supply_chain RENAME COLUMN "Shipping Mode" TO shipping_mode;