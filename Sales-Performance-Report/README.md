# Project Data Analysis for Retail: Sales Performance Report

Repository ini berisi study case menggunakan dataset `dqlab_sales_store`. Tujuan dari project ini adalah untuk menganalisis dan mengeksplorasi berbagai aspek dari data penjualan, termasuk segmentasi pelanggan, performa penjualan, dan wawasan bisnis.

## Daftar Isi
1. [Deskripsi Project](#deskripsi-project)
2. [Deskripsi Dataset](#deskripsi-dataset)
3. [Case Study Questions](#case-study-questions)
4. [Kesimpulan](#kesimpulan)
   
## Deskripsi Project
Proyek ini adalah study case dari **DQLAB Academy** (academy.dqlab.id) yang bertujuan untuk melakukan analisis data dan business intelligence pada dataset `dqlab_sales_store`. Proyek ini mengajak peserta untuk memahami dan menganalisis berbagai aspek dari data penjualan yang diberikan, seperti segmentasi pelanggan, performa penjualan, serta dampak diskon dan kategori produk terhadap hasil penjualan.


## Deskripsi Dataset
Dataset `dqlab_sales_store` memiliki kolom-kolom sebagai berikut:

- **order_id**: Nomor unik untuk setiap order.
- **order_status**: Status dari order (misalnya selesai, dikembalikan).
- **customer**: Nama pelanggan.
- **order_date**: Tanggal ketika order dilakukan.
- **order_quantity**: Jumlah barang dalam order tersebut.
- **sales**: Total penjualan yang dihasilkan dari order (dalam IDR).
- **discount**: Persentase diskon yang diberikan pada order.
- **discount_value**: Nilai diskon dalam IDR.
- **product_category**: Kategori produk.
- **product_sub_category**: Subkategori dari produk.

# Case Study Questions

## Chapter 1 - DQLab Store Overall Performance
**1. Overall Performance by Year** \
Buatlah Query dengan menggunakan SQL untuk mendapatkan total penjualan (sales) dan jumlah order (number_of_order) dari tahun 2009 sampai 2012 (years). 

**Query**
~~~~sql
SELECT DISTINCT
	YEAR(order_date) AS years,
	SUM(sales) AS sales,
	COUNT(order_id) AS number_of_order
FROM dqlab_sales_store
WHERE order_status = "Order Finished"
GROUP BY 1
ORDER BY 1;
~~~~
**KEY STEPS**
- step 1
- step 2

**Result**
|years|sales|number_of_order|
|-----|-----|---------------|
|2009|4613872681|1244|
|2010|4059100607|1248|
|2011|4112036186|1178|
|2012|4482983158|1254|

**Insight**
- insight

**2. Overall Performance by Product Sub Category** \
Buatlah Query dengan menggunakan SQL untuk mendapatkan total penjualan (sales) berdasarkan sub category dari produk (product_sub_category) pada tahun 2011 dan 2012 saja (years). 

**Query**
~~~~sql
SELECT DISTINCT
	YEAR(order_date) AS years,
	product_sub_category,
	SUM(sales) AS sales
FROM dqlab_sales_store
WHERE order_status = "Order Finished"
GROUP BY 1,2
HAVING years = 2011 or years = 2012
ORDER BY 1,3 DESC
LIMIT 10; -- Membatasi hasil hanya 10 baris
~~~~
**KEY STEPS**
- step 1
- step 2

**Result**
|years|product_sub_category|sales|
|-----|--------------------|-----|
|2011|Chairs & Chairmats|622962720|
|2011|Office Machines|545856280|
|2011|Tables|505875008|
|2011|Copiers & Fax|404074080|
|2011|Telephones & Communication|392194658|
|2011|Binders & Binder Accessories|298023200|
|2011|Storage & Organization|285991820|
|2011|Appliances|272630020|
|2011|Computer Peripherals|232677960|
|2011|Bookcases|169304620|

**Insight**
- insight

## Chapter 2 - Promotion Effectiveness and Efficiency by Years
**1. DQLab Store Promotion Effectiveness and Efficiency** \
Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini. \
Efektifitas dan efisiensi dari promosi yang dilakukan akan dianalisa berdasarkan Burn Rate yaitu dengan membandigkan total value promosi yang dikeluarkan terhadap total sales yang diperoleh. \
DQLab berharap bahwa burn rate tetap berada diangka maskimum 4.5% \
**Formula untuk burn rate : (total discount / total sales) * 100** \
Buatkan Derived Tables untuk menghitung total sales (sales) dan total discount (promotion_value) berdasarkan tahun(years) dan formulasikan persentase burn rate nya (burn_rate_percentage).

**Query**
~~~~sql
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
~~~~
**KEY STEPS**
- step 1
- step 2

**Result**
|years|sales|promotion_value|burn_rate_percentage|
|-----|-----|---------------|--------------------|
|2009|4613872681|214330327|4.65|
|2010|4059100607|197506939|4.87|
|2011|4112036186|214611556|5.22|
|2012|4482983158|225867642|5.04|

**Insight**
- insight

**2. Promotion Effectiveness and Efficiency by Product Sub Category** \
Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini seperti pada bagian sebelumnya. 
Akan tetapi, ada kolom yang harus ditambahkan, yaitu : product_sub_category dan product_category.
- Data yang ditampilkan hanya untuk tahun 2012

**Query**
~~~~sql
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
LIMIT 100) year_sales
WHERE years = 2012
ORDER BY 4 DESC;
~~~~
**KEY STEPS**
- step 1
- step 2

**Result**
|years|product_sub_category|product_category|sales|promotion_value|burn_rate_percentage|
|-----|--------------------|----------------|-----|---------------|--------------------|
|2012|Office Machines|Technology|811427140|46616695|5.75|
|2012|Chairs & Chairmats|Furniture|654168740|26623882|4.07|
|2012|Telephones & Communication|Technology|422287514|18800188|4.45|
|2012|Tables|Furniture|388993784|16348689|4.20|
|2012|Binders & Binder Accessories|Office Supplies|363879200|22338980|6.14|
|2012|Storage & Organization|Office Supplies|356714140|18802166|5.27|
|2012|Computer Peripherals|Technology|308014340|15333293|4.98|
|2012|Copiers & Fax|Technology|292489800|14530870|4.97|
|2012|Appliances|Office Supplies|266131100|14393300|5.41|
|2012|Office Furnishings|Furniture|178927480|8233849|4.60|
|2012|Bookcases|Furniture|159984680|10024365|6.27|
|2012|Paper|Office Supplies|126896160|6224694|4.91|
|2012|Envelopes|Office Supplies|58629280|2334321|3.98|
|2012|Pens & Art Supplies|Office Supplies|43818480|2343501|5.35|
|2012|Scissors, Rulers & Trimmers|Office Supplies|36776400|2349280|6.39|
|2012|Labels|Office Supplies|10007040|452245|4.52|
|2012|Rubber Bands|Office Supplies|3837880|117324|3.06|

**Insight**
- insight

## Chapter 3 - Customer Analytics
**1. Customers Transactions per year** \
DQLab Store ingin mengetahui jumlah customer (number_of_customer) yang bertransaksi setiap tahun dari 2009 sampai 2012 (years). 

**Query**
~~~~sql
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
~~~~
**KEY STEPS**
- step 1
- step 2

**Result**
|years|number_of_customer|
|-----|------------------|
|2009|585|
|2010|593|
|2011|581|
|2012|594|


## Kesimpulan
- kesimpulan
