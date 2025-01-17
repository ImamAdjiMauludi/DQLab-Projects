# Chapter 2 - Melengkapi SQL 💾

## Pengantar

Dataset berasal dari DQLab. Ini adalah bagian kedua dari project Data Analysis for E-Commerce Challenge.

## Daftar Isi 📃

- [Chapter 2 - Melengkapi SQL 💾](#chapter-2---melengkapi-sql-)
  - [Pengantar](#pengantar)
  - [Daftar Isi 📃](#daftar-isi-)
  - [1. 10 Transaksi terbesar user 12476.](#1-10-transaksi-terbesar-user-12476)
  - [2. Summary transaksi per bulan di tahun 2020.](#2-summary-transaksi-per-bulan-di-tahun-2020)
  - [3. 10 pembeli dengan rata-rata nilai transaksi terbesar yang bertransaksi minimal 2 kali di Januari 2020.](#3-10-pembeli-dengan-rata-rata-nilai-transaksi-terbesar-yang-bertransaksi-minimal-2-kali-di-januari-2020)
  - [4. Transaksi besar di Desember 2019 dengan nilai transaksi minimal 20,000,000.](#4-transaksi-besar-di-desember-2019-dengan-nilai-transaksi-minimal-20000000)
  - [5. Kategori dengan total quantity terbanyak di tahun 2020, hanya untuk transaksi yang sudah terkirim ke pembeli.](#5-kategori-dengan-total-quantity-terbanyak-di-tahun-2020-hanya-untuk-transaksi-yang-sudah-terkirim-ke-pembeli)

## 1. 10 Transaksi terbesar user 12476.

```sql
SELECT
	seller_id,
	buyer_id,
	total AS nilai_transaksi,
	created_at AS tanggal_transaksi
FROM
	orders
WHERE
	buyer_id = 12476
ORDER BY
	3 DESC
LIMIT 10;
```

**Result:**
|seller_id|buyer_id|nilai_transaksi|tanggal_transaksi|
|---------|--------|---------------|-----------------|
|61|12476|12014000|2019-12-23|
|53|12476|9436000|2019-12-05|
|64|12476|4951000|2019-12-19|
|57|12476|4854000|2019-12-01|
|22|12476|4010000|2019-11-29|
|48|12476|1440000|2020-02-27|
|61|12476|1053000|2019-10-17|
|35|12476|816000|2020-05-12|
|60|12476|740000|2019-09-26|
|3|12476|399000|2019-09-26|

**Insight:** \
Transaksi terbesar user_id 12476 sejumlah Rp 1.2014.000 yang dibeli di seller_id 61 pada tanggal 2019-12-23.

## 2. Summary transaksi per bulan di tahun 2020.

```sql
SELECT
	EXTRACT(YEAR_MONTH FROM created_at) AS tahun_bulan,
	count(1) AS jumlah_transaksi,
	sum(total) AS total_nilai_transaksi
FROM
	orders
WHERE
	created_at >= '2020-01-01'
GROUP BY
	1
ORDER BY
	1;
```

**Result:**
|tahun_bulan|jumlah_transaksi|total_nilai_transaksi|
|-----------|----------------|---------------------|
|202001|5062|9941756800|
|202002|5872|12665113550|
|202003|7323|17189378400|
|202004|7955|21219233750|
|202005|10026|31288823000|

**Insight:**

- Transaksi terbesar terjadi pada bulan Mei sebanyak 10026 transaksi dengan total RP 31.288.823.000.
- Terjadi peningkatan jumlah transaksi dan total nilai transaksi tiap bulannya pada tahun 2020.

## 3. 10 pembeli dengan rata-rata nilai transaksi terbesar yang bertransaksi minimal 2 kali di Januari 2020.

```sql
SELECT
	buyer_id,
	count(1) AS jumlah_transaksi,
	avg(total) AS avg_nilai_transaksi
FROM
	orders
WHERE
	created_at >= '2020-01-01'
	AND created_at<'2020-02-01'
GROUP BY
	1
HAVING
	count(1)>= 2
ORDER BY
	3 DESC
LIMIT 10;
```

**Result:**
|buyer_id|jumlah_transaksi|avg_nilai_transaksi|
|--------|----------------|-------------------|
|11140|2|11719500.0000|
|7905|2|10440000.0000|
|12935|2|8556500.0000|
|12916|2|7747000.0000|
|17282|2|6797500.0000|
|1418|2|6741000.0000|
|5418|2|5336000.0000|
|11906|2|5309500.0000|
|12533|2|5218500.0000|
|841|2|5052500.0000|

**Insight:**\
Buyer dengan ID 11140 memiliki nilai transaksi sepanjang Januari 2020 paling besar yaitu sebanyak RP 11.719.500.

## 4. Transaksi besar di Desember 2019 dengan nilai transaksi minimal 20,000,000.

```sql
SELECT
	nama_user AS nama_pembeli,
	total AS nilai_transaksi,
	created_at AS tanggal_transaksi
FROM
	orders
INNER JOIN users ON
	buyer_id = user_id
WHERE
	created_at >= '2019-12-01'
	AND created_at<'2020-01-01'
	AND total >= 20000000
ORDER BY
	1;
```

**Result:**
|nama_pembeli|nilai_transaksi|tanggal_transaksi|
|------------|---------------|-----------------|
|Diah Mahendra|21142000|2019-12-24|
|Dian Winarsih|22966000|2019-12-21|
|dr. Yulia Waskita|29930000|2019-12-28|
|drg. Kajen Siregar|27893500|2019-12-10|
|Drs. Ayu Lailasari|22300000|2019-12-09|
|Hendri Habibi|21815000|2019-12-19|
|Kartika Habibi|25760000|2019-12-22|
|Lasmanto Natsir|22845000|2019-12-27|
|R.A. Betania Suryono|20523000|2019-12-07|
|Syahrini Tarihoran|29631000|2019-12-05|
|Tgk. Hamima Sihombing, M.Kom.|29351400|2019-12-25|
|Tgk. Lidya Lazuardi, S.Pt|20447000|2019-12-16|

**Insight:**\
Pembeli atas nama Diah Mahendra menjadi pembeli dengan nilai transaksi terbesar pada Desember 2019 dengan nilai transaksi Rp 21.142.000.

## 5. Kategori dengan total quantity terbanyak di tahun 2020, hanya untuk transaksi yang sudah terkirim ke pembeli.

```sql
SELECT
	category,
	SUM(quantity) AS total_quantity,
	SUM(price) AS total_price
FROM
	orders
INNER JOIN order_details
		USING(order_id)
INNER JOIN products
		USING(product_id)
WHERE
	created_at >= '2020-01-01'
	AND delivery_at IS NOT NULL
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT 5;
```

**Result:**
|category|total_quantity|total_price|
|--------|--------------|-----------|
|Kebersihan Diri|823226|1166490000|
|Fresh Food|259998|691360000|
|Makanan Instan|243790|59101000|
|Bahan Makanan|188211|103167000|
|Minuman Ringan|184747|54682000|

**Insight:**\
Produk dengan kategori Kebersihan Diri menjadi produk yang paling diminati selama tahun 2020 yaitu ada sejumlah 823226 qty yang terjual dengan nilai transaksi sebanyak Rp 1.166.490.000.
