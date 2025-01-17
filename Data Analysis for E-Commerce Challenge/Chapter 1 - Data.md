# Chapter 1 - Data 💾

## Pengantar

Dataset berasal dari DQLab. Pada Chapter ini data akan di-eksplorasi lebih lanjut dalam 10 pertanyaan untuk mendapat insight dari dataset yang tersedia.

## Daftar Isi 📃

- [Chapter 1 - Data 💾](#chapter-1---data-)
  - [Pengantar](#pengantar)
  - [Daftar Isi 📃](#daftar-isi-)
  - [1. Products](#1-products)
  - [2. Orders](#2-orders)
  - [3. Transaksi Bulanan](#3-transaksi-bulanan)
  - [4. Status Transaksi](#4-status-transaksi)
  - [5. Pengguna Bertransaksi](#5-pengguna-bertransaksi)
  - [6. Top Buyer all time](#6-top-buyer-all-time)
  - [7. Frequent Buyer](#7-frequent-buyer)
  - [8. Big Frequent Buyer 2020](#8-big-frequent-buyer-2020)
  - [9. Domain email dari penjual](#9-domain-email-dari-penjual)
  - [10. Top 5 Product Desember 2019](#10-top-5-product-desember-2019)

## 1. Products

```sql
SELECT *
FROM  products p
LIMIT 5;

SELECT COUNT(*)
FROM  products p
LIMIT 5;
```

**Result:**
|product_id|desc_product|category|base_price|
|----------|------------|--------|----------|
|1|OLIVIA KULOT OLV03 |Pakaian Wanita|110000|
|2|BLANIK BLOUSE BL304 |Pakaian Wanita|100000|
|3|NEW DAY BY RIX DRESS ND01 |Pakaian Wanita|85000|
|4|BLANIK BLOUSE BL023 |Pakaian Wanita|85000|
|5|BLANIK BLAZER BL031 |Pakaian Wanita|99000|

| COUNT(\*) |
| --------- |
| 1145      |

**Insight:** \
Terdapat 4 column dan 1145 row pada tabel `product`.

## 2. Orders

```sql
SELECT *
FROM  orders o
LIMIT 5;

SELECT COUNT(*)
FROM  orders o
LIMIT 5;
```

**Result:**
|order_id|seller_id|buyer_id|kodepos|subtotal|discount|total|created_at|paid_at|delivery_at|
|--------|---------|--------|-------|--------|--------|-----|----------|-------|-----------|
|3|5|4769|32610|900000|0|900000|2019-06-01|2019-06-04|2019-06-12|
|5|23|4276|2674|220000|0|220000|2019-04-02|2019-04-05|2019-04-09|
|8|4|14110|48577|1248000|0|1248000|2019-08-02|2019-08-13|2019-08-20|
|19|5|3831|91235|1074000|0|1074000|2020-05-16|||
|31|46|5318|96740|253000|0|253000|2019-03-12|2019-03-17|2019-03-20|

| COUNT(\*) |
| --------- |
| 74874     |

**Insight:** \
Pada tabel `orders` terdapat 10 kolom, 74874 baris, dan 3 variabel yang berisi data amount (rupiah) serta tanggal.

## 3. Transaksi Bulanan

```sql
SELECT
	COUNT(order_id)
FROM orders o
WHERE DATE_FORMAT(created_at, '%Y%m') = "201909";

SELECT
	COUNT(order_id)
FROM orders o
WHERE DATE_FORMAT(created_at, '%Y%m') = "202001";

SELECT
	COUNT(order_id)
FROM orders o
WHERE DATE_FORMAT(created_at, '%Y%m') = "202005";
```

**Result:**
|COUNT(order_id)|
|---------------|
|4327|

| COUNT(order_id) |
| --------------- |
| 5062            |

| COUNT(order_id) |
| --------------- |
| 10026           |

**Insight:** \
Terdapat 4,327 transaksi di bulan September 2019, 5,062 transaksi di bulan Januari 2020, 7,323 transaksi di bulan Maret 2020, dan 10,026 transaksi di bulan Mei 2020.

## 4. Status Transaksi

```sql
SELECT COUNT(*)
FROM  orders o
WHERE
	paid_at IS NULL;

SELECT COUNT(*)
FROM  orders o
WHERE
	delivery_at IS NULL;
```

**Result:**
|COUNT(\*)|
|--------|
|5046|

| COUNT(\*) |
| --------- |
| 9790      |

**Insight:** \
Terdapat 5,046 transaksi yang tidak dibayar dan total 9,790 transaksi yang tidak dikrim, baik sudah dibayar maupun belum.

## 5. Pengguna Bertransaksi

```sql
SELECT
	COUNT(DISTINCT buyer_id) AS pembeli
FROM orders o;

SELECT
	COUNT(DISTINCT seller_id) AS penjual
FROM orders o;

SELECT
	COUNT(DISTINCT buyer_id) AS pembeli_dan_penjual
FROM orders o
WHERE buyer_id IN (SELECT DISTINCT seller_id FROM orders o);
```

**Result:**
|pembeli|
|-------|
|17877|

| penjual |
| ------- |
| 69      |

| pembeli_dan_penjual |
| ------------------- |
| 69                  |

**Insight:** \
Ada 17,877 pengguna yang pernah bertransaksi sebagai pembeli, 69 pengguna yang pernah bertransaksi sebagai penjual, dan 69 pengguna yang pernah bertransaksi sebagai pembeli dan pernah sebagai penjual.

## 6. Top Buyer all time

```sql
SELECT
	u.user_id,
	u.nama_user,
	SUM(o.total) AS total
FROM orders o
INNER JOIN users u
ON o.buyer_id = u.user_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;
```

**Result:**
|user_id|nama_user|total|
|-------|---------|-----|
|14411|Jaga Puspasari|54102250|
|11140|R.A. Yulia Padmasari, S.I.Kom|52743200|
|15915|Sutan Agus Ardianto, S.Kom|49141800|
|2908|Septi Melani, S.Ked|49033000|
|10355|Kartika Habibi|48868000|

**Insight:** \
Dari daftar user_id dan nama pengguna tersebut merupakan 5 pembeli dengan dengan total pembelian terbesar (berdasarkan total harga barang setelah diskon).

## 7. Frequent Buyer

```sql
SELECT
	u.user_id,
	u.nama_user,
	COUNT(o.order_id) AS total_order
FROM orders o
INNER JOIN users u
ON o.buyer_id = u.user_id
WHERE o.discount = "0"
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;
```

**Result:**
|user_id|nama_user|total_order|
|-------|---------|-----------|
|12476|Yessi Wibisono|13|
|10977|Drs. Pandu Mansur, M.TI.|12|
|12577|Umay Latupono|12|
|7543|Laras Puspasari|11|
|1251|Septi Sinaga|11|

**Insight:** \
Dari daftar nama pengguna tersebut pengguna yang tidak pernah menggunakan diskon ketika membeli barang dan merupakan 5 pembeli dengan transaksi terbanyak.

## 8. Big Frequent Buyer 2020

```sql
SELECT
	u.user_id,
	email,
	COUNT(DISTINCT MONTH(created_at)) AS freq_bulan
FROM orders o
INNER JOIN users u
ON o.buyer_id = u.user_id
WHERE
	YEAR(o.created_at) = "2020"
GROUP BY
	1,2
HAVING
	SUM(total) > 1000000
	AND
	freq_bulan >= 5
ORDER BY 3 DESC
LIMIT 5;
```

**Result:**
|user_id|email|freq_bulan|
|-------|-----|----------|
|12011|kuswoyobakda@gmail.com|5|
|2424|maryadiviolet@ud.mil.id|5|
|302|pharyanto@perum.or.id|5|
|13973|amiwibisono@cv.my.id|5|
|10569|karmanpurnawati@hotmail.com|5|

**Insight:** \
Dari daftar email pengguna tersebut merupakan pengguna yang bertransaksi setidaknya 1 kali setiap bulan di tahun 2020 dengan rata-rata total amount per transaksi lebih dari 1 Juta

## 9. Domain email dari penjual

```sql
SELECT DISTINCT
	SUBSTRING(email, LOCATE("@", email)+1) AS domain,
	email_category
FROM
	(SELECT DISTINCT
		o.seller_id,
		u.email,
		CASE
			WHEN u.email LIKE "%@cv.web.id" THEN "E-mail Seller"
			WHEN u.email LIKE "%@cv.com" THEN "E-mail Seller"
			WHEN u.email LIKE "%@cv.net.id" THEN "E-mail Seller"
			WHEN u.email LIKE "%@cv.web.id" THEN "E-mail Seller"
			WHEN u.email LIKE "%@pt.net.id" THEN "E-mail Seller"
			WHEN u.email LIKE "%@ud.co.id" THEN "E-mail Seller"
			ELSE "Buyer"
		END AS email_category
	FROM orders o
	INNER JOIN users u
	ON o.seller_id = u.user_id
	) AS sellers
WHERE NOT email_category LIKE "Buyer";
```

**Result:**
|domain|email_category|
|------|--------------|
|pt.net.id|E-mail Seller|
|cv.web.id|E-mail Seller|

**Insight:** \
Hasil tersebut merupakan sebagian domain email dari penjual di DQLab Store.

## 10. Top 5 Product Desember 2019

```sql
SELECT
	p.desc_product,
	SUM(od.quantity) AS total_qty
FROM order_details od
RIGHT JOIN products p
ON od.product_id = p.product_id
INNER JOIN orders o
ON od.order_id = o.order_id
WHERE
	DATE_FORMAT(o.created_at, "%Y%m") = 201912
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Result:**
|desc_product|total_qty|
|------------|---------|
|QUEEN CEFA BRACELET LEATHER |2550|
|SHEW SKIRTS BREE |1423|
|ANNA FAITH LEGGING GLOSSY |1323|
|Cdr Vitamin C 10'S |1242|
|RIDER CELANA DEWASA SPANDEX ANTI BAKTERI R325BW |1186|

**Insight:** \
Hasil tersebut menunjukkan top 5 produk yang dibeli di bulan desember 2019 berdasarkan total quantity.
