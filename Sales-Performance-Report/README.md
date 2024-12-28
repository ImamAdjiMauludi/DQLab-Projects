# Project Data Analysis for Retail: Sales Performance Report 📊💸

Repository ini berisi study case menggunakan dataset `dqlab_sales_store`. Tujuan dari project ini adalah untuk menganalisis dan mengeksplorasi berbagai aspek dari data penjualan, termasuk segmentasi pelanggan, performa penjualan, dan wawasan bisnis.

## Daftar Isi 📃
- [Project Data Analysis for Retail: Sales Performance Report 📊💸](#project-data-analysis-for-retail-sales-performance-report-)
  - [Daftar Isi 📃](#daftar-isi-)
  - [Deskripsi Project 📄](#deskripsi-project-)
  - [Deskripsi Dataset 💾](#deskripsi-dataset-)
- [Case Study Questions and Insight 💡](#case-study-questions-and-insight-)
  - [Chapter 1 - DQLab Store Overall Performance](#chapter-1---dqlab-store-overall-performance)
  - [Chapter 2 - Promotion Effectiveness and Efficiency by Years](#chapter-2---promotion-effectiveness-and-efficiency-by-years)
  - [Chapter 3 - Customer Analytics](#chapter-3---customer-analytics)
   
## Deskripsi Project 📄
Proyek ini adalah study case dari **DQLAB Academy** (academy.dqlab.id) yang bertujuan untuk melakukan analisis data dan business intelligence pada dataset `dqlab_sales_store`. Proyek ini mengajak peserta untuk memahami dan menganalisis berbagai aspek dari data penjualan yang diberikan, seperti segmentasi pelanggan, performa penjualan, serta dampak diskon dan kategori produk terhadap hasil penjualan.

## Deskripsi Dataset 💾
![image](https://github.com/user-attachments/assets/15390881-04bc-46a6-9dbd-ac2db4972a72)

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

# Case Study Questions and Insight 💡

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
- Ambil tahun pada kolom `order_date` menggunakan **YEAR()**, jumlah semua **SUM()** kolom `sales`, hitung banyaknya data pada kolom `order_id`.
- Filter untuk memilih `order_status` dengan kondisi "Order Finished".
- **GROUP BY** `years` untuk mengelompokkan berdasarkan tahun.

**Result**
|years|sales|number_of_order|
|-----|-----|---------------|
|2009|4613872681|1244|
|2010|4059100607|1248|
|2011|4112036186|1178|
|2012|4482983158|1254|

**Insight**
- Sales terbanyak ada pada tahun 2009 yaitu sebesar Rp 4.613.872.681.
- Order terbanyak ada pada tahun 2012 yaitu sebanyak 1254 order.

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
LIMIT 10; -- Membatasi hasil hanya 10 baris, karena terlalu banyak
~~~~
**KEY STEPS**
- Menjumlahkan seluruh `sales` lalu mengelompokkan berdasarkan kolom `years` dan `product_sub_category`.
- Filter kondisi dengan `HAVING` dimana hanya pada tahun 2011 dan 2012.

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
- Pada tahun 2011, sales terbanyak berasal dari sub-produk-kategori Chairs & Chairmats, sebanyak 622962720.
- Pada tahun 2012, sales terbanyak berasal dari sub-produk-kategori Office Machines, sebanyak 811427140.

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
- Buat Derived Tables untuk mengetahui jumlah sales dan jumlah promotion value berdasarkan tiap tahunnya.
- Membuat kueri untuk mengetahui burn rate percentage tiap tahunnya dengan cara membagi `promotion_value` dengan `sales` lalu dikali 100.
- **ROUND()** digunakan untuk membulatkan desimal ke 2 angka dibelakang koma.

**Result**
|years|sales|promotion_value|burn_rate_percentage|
|-----|-----|---------------|--------------------|
|2009|4613872681|214330327|4.65|
|2010|4059100607|197506939|4.87|
|2011|4112036186|214611556|5.22|
|2012|4482983158|225867642|5.04|

**Insight**
- Burn rate terendah ada pada tahun 2009 yaitu 4.65%.
- Burn rate tertinggi ada pada tahun 2011 yaitu 5.22%.
- Namun, dari tahun 2009 hingga tahun 2012 tidak ada satupun tahun yang memenuhi ekspektasi DQLab yaitu burn rate dibawah 4.5%.

**2. Promotion Effectiveness and Efficiency by Product Sub Category** \
Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini seperti pada bagian sebelumnya. 
Akan tetapi, ada kolom yang harus ditambahkan, yaitu : product_sub_category dan product_category.
- Data yang ditampilkan hanya untuk tahun 2012.

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
- Buat Derived Tables untuk mengabil tahun, product_sub_category, product_sub_category, jumlah seluruh sales, jumlah seluruh promotion value.
- Lalu, mencaritahu kembali burn rate percentage nya dengan kueri **ROUND((promotion_value/sales)*100,2) AS burn_rate_percentage**.
- **ROUND()** digunakan untuk membulatkan desimal ke 2 angka dibelakang koma.

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
- Jika melihat burn rate hanya pada tiap tahun, tidak ada satupun yang memenuhi. Namun kondisi menarik ketika burn rate diketahui untuk setiap kategori.
- Terdapat 3 kategori yang kategori burn rate dibawah 4.5%.
- Pada kategori Furniture, burn rate pada sub kategori Chairs & Chairmats ada pada angka 4.07%, sementara itu kategori Tables ada di angka 4.2%
- Pada kategori Technology, burn rate pada sub kategori Telephones & Communication ada pada angka 4.45%.
- Pada kategori Office Supplies, burn rate pada sub kategori Envelopes ada di angka 3.98% dan kategori 3.06% ada di Rubber Bands.

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
- Hitung data yang unik agar tidak menghitung duplikasi pada kolom `customer` untuk mengitung banyak customer.
- Lalu kembali menggunakan filter kondisi dimana **order_status = "Order Finished"**, untuk memilih order yang berhasil saja.
- **GROUP BY** `years` untuk mengetahui banyak customer tiap tahunnya.

**Result**
|years|number_of_customer|
|-----|------------------|
|2009|585|
|2010|593|
|2011|581|
|2012|594|

**Insight**
- Pada tiap tahunnya, jumlah customer yang bertransaksi tidak menentu, namun terlihat sedikit pola yang naik turun.
- Puncaknya terjadi pada tahun 2012 yaitu sebanyak 594 customer, hanya tipis 1 customer dari tahun 2010 yaitu sebanyak 593 customer.
