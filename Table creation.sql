CREATE TABLE bm_stores(
	store_id		numeric,
	store_name		varchar(50),
	city			varchar(50),
	store_type		varchar(50)
);

CREATE TABLE bm_skus(
	sku_id			numeric,
	sku_name		varchar(100),
	category		varchar(50),
	subcategory		varchar(50),
	unit_price		numeric,
	cost_price		numeric,
	brand			varchar(50)
);

CREATE TABLE bm_customers(
	cust_id			numeric,
	age				int,
	gender			varchar(10),
	city			varchar(25),
	loyalty_segment	varchar(25),	
	preferred_channel	varchar(25),
	registration_date	date
);

CREATE TABLE bm_inventory(
	store_id		numeric,
	sku_id			numeric,
	stock_on_hand	int,
	reorder_point	int,
	safety_stock	int,
	last_restock_date	date,
	snapshot_date		date
);

CREATE TABLE bm_sales(
	date			date,
	store_id		numeric,
	sku_id			numeric,
	customer_id		numeric,
	quantity		int,
	unit_price		decimal,
	total_value		decimal,
	channel			varchar(50),
	discount_pct	decimal
);











