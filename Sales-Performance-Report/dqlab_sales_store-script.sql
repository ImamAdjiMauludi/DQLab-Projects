USE dqlab;

/* BAB 1:  DQLab Store Overall Performance --- */
/* -- Overall Performance by Year -- Buatlah Query dengan menggunakan SQL untuk mendapatkan total penjualan (sales) dan jumlah order (number_of_order) dari tahun 2009 sampai 2012 (years).  */

SELECT DISTINCT
	YEAR(order_date) AS years,
	SUM(sales) AS sales,
	COUNT(order_id) AS number_of_order
FROM dqlab_sales_store
WHERE order_status = "Order Finished"
GROUP BY 1
ORDER BY 1;

/* -- Overall Performance by Product Sub Category -- Buatlah Query dengan menggunakan SQL untuk mendapatkan total penjualan (sales) berdasarkan sub category dari produk (product_sub_category) pada tahun 2011 dan 2012 saja (years) */

SELECT DISTINCT
	YEAR(order_date) AS years,
	product_sub_category,
	SUM(sales) AS sales
FROM dqlab_sales_store
WHERE order_status = "Order Finished"
GROUP BY 1,2
HAVING years = 2011 or years = 2012
ORDER BY 1,3 DESC;

/* BAB 2:  DQLab Store Promotion Effectiveness and Efficiency --- */
/* -- Promotion Effectiveness and Efficiency by Years -- Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini
Efektifitas dan efisiensi dari promosi yang dilakukan akan dianalisa berdasarkan Burn Rate yaitu dengan membandigkan total value promosi yang dikeluarkan terhadap total sales yang diperoleh
DQLab berharap bahwa burn rate tetap berada diangka maskimum 4.5%
Formula untuk burn rate : (total discount / total sales) * 100
Buatkan Derived Tables untuk menghitung total sales (sales) dan total discount (promotion_value) berdasarkan tahun(years) dan formulasikan persentase burn rate nya (burn_rate_percentage).*/

SELECT
	*,
ROUND((promotion_value/sales)*100,2) AS burn_rate_percentage
FROM
(SELECT
	YEAR(order_date) AS years,
	SUM(sales) AS sales,
	SUM(discount_value) AS promotion_value
FROM 
	dqlab_sales_store
WHERE
	order_status = "Order Finished"
GROUP BY 1
ORDER by years
LIMIT 10) year_sales;

/* -- Promotion Effectiveness and Efficiency by Product Sub Category -- Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini seperti pada bagian sebelumnya. 
Akan tetapi, ada kolom yang harus ditambahkan, yaitu : product_sub_category dan product_category */

SELECT
	*,
ROUND((promotion_value/sales)*100,2) AS burn_rate_percentage
FROM
(SELECT
	YEAR(order_date) AS years,
	product_sub_category,
	product_category,
	SUM(sales) AS sales,
	SUM(discount_value) AS promotion_value
FROM 
	dqlab_sales_store
WHERE
	order_status = "Order Finished"
GROUP BY 1,2,3
LIMIT 100) AS year_sales
WHERE years = 2012 and ROUND((promotion_value/sales)*100,2) <= 4.5
ORDER BY 4 desc;

/* BAB 3:  Customer Analytics --- */
/* --- Customers Transactions per year --- DQLab Store ingin mengetahui jumlah customer (number_of_customer) yang bertransaksi setiap tahun dari 2009 sampai 2012 (years). */
SELECT 
	YEAR(order_date) AS years,
	COUNT(DISTINCT customer) AS number_of_customer
FROM 
	dqlab_sales_store
WHERE
	order_status = "Order Finished"
GROUP BY 1
ORDER BY 1
LIMIT 100;
