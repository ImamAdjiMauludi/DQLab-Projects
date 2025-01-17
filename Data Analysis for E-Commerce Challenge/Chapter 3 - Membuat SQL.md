# Chapter 3 - Membuat SQL 💾

## Pengantar

Dataset berasal dari DQLab. Ini adalah bagian ketiga dari project Data Analysis for E-Commerce Challenge.

## Daftar Isi 📃

- [Chapter 3 - Membuat SQL 💾](#chapter-3---membuat-sql-)
  - [Pengantar](#pengantar)
  - [Daftar Isi 📃](#daftar-isi-)
  - [1. Mencari pembeli high value](#1-mencari-pembeli-high-value)
  - [2. Mencari Dropshipper](#2-mencari-dropshipper)
  - [3. Mencari Reseller Offline](#3-mencari-reseller-offline)
  - [4. Pembeli sekaligus penjual](#4-pembeli-sekaligus-penjual)
  - [5. Lama transaksi dibayar](#5-lama-transaksi-dibayar)

## 1. Mencari pembeli high value

Buatlah SQL query untuk mencari pembeli yang sudah bertransaksi lebih dari 5 kali, dan setiap transaksi lebih dari 2,000,000.

```sql
SELECT
	nama_user AS nama_pembeli,
	COUNT(1) AS jumlah_transaksi,
	SUM(total) AS total_nilai_transaksi,
	MIN(total) AS min_nilai_transaksi
FROM
	orders
INNER JOIN users
ON
	buyer_id = user_id
GROUP BY
	nama_user,
	user_id
HAVING
	COUNT(1) > 5
	AND min(total) > 2000000
ORDER BY
	3 DESC;
```

**Result:**
|nama_pembeli|jumlah_transaksi|total_nilai_transaksi|min_nilai_transaksi|
|------------|----------------|---------------------|-------------------|
|R. Tirta Nasyidah|6|25117800|2308800|
|Martani Laksmiwati|6|24858000|2144000|

**Insight:** \
Pembeli an R. Tirta Nasyidah dan Martani Laksmiwati memiliki jumlah transaksi yang sama yaitu 6x serta total nilai transaksi yang tidak begitu jauh.

## 2. Mencari Dropshipper

Pada soal kali ini kamu diminta untuk mencari tahu pengguna yang menjadi dropshipper, yakni pembeli yang membeli barang akan tetapi dikirim ke orang lain. Ciri-cirinya yakni transaksinya banyak, dengan alamat yang berbeda-beda.

```sql
SELECT
	nama_user AS nama_pembeli,
	COUNT(1) AS jumlah_transaksi,
	COUNT(DISTINCT orders.kodepos) AS distinct_kodepos,
	SUM(total) AS total_nilai_transaksi,
	AVG(total) AS avg_nilai_transaksi
FROM
	orders
INNER JOIN users
ON
	buyer_id = user_id
GROUP BY
	nama_user,
	user_id
HAVING
	COUNT(1) >= 10
	AND COUNT(1) = COUNT(DISTINCT orders.kodepos)
ORDER BY
	2 DESC;
```

**Result:**
|nama_pembeli|jumlah_transaksi|distinct_kodepos|total_nilai_transaksi|avg_nilai_transaksi|
|------------|----------------|----------------|---------------------|-------------------|
|Anastasia Gunarto|10|10|7899000|789900.0000|
|R.M. Setya Waskita|10|10|30595000|3059500.0000|

**Insight:** \
Pembeli an R.M. Setya Waskita sudah melakukan 10x transaksi dengan mengirim ke 10 alamat yang berbeda. Total nilai transaksinya paling besar dibanding pembeli lain dengan jumlah Rp 30.595.000.

## 3. Mencari Reseller Offline

Selanjutnya, akan dicari tahu jenis pengguna yang menjadi reseller offline atau punya toko offline, yakni pembeli yang sering sekali membeli barang dan seringnya dikirimkan ke alamat yang sama. Pembelian juga dengan quantity produk yang banyak. Sehingga kemungkinan barang ini akan dijual lagi.

```sql
SELECT
	nama_user AS nama_pembeli,
	COUNT(1) AS jumlah_transaksi,
	SUM(total) AS total_nilai_transaksi,
	AVG(total) AS avg_nilai_transaksi,
	AVG(total_quantity) AS avg_quantity_per_transaksi
FROM
	orders
INNER JOIN users ON
	buyer_id = user_id
INNER JOIN (
	SELECT
		order_id,
		SUM(quantity) AS total_quantity
	FROM
		order_details
	GROUP BY
		1) AS summary_order
		USING(order_id)
WHERE
	orders.kodepos = users.kodepos
GROUP BY
	user_id,
	nama_user
HAVING
	COUNT(1) >= 8
	AND AVG(total_quantity) > 10
ORDER BY
	3 DESC;
```

**Result:**
|nama_pembeli|jumlah_transaksi|total_nilai_transaksi|avg_nilai_transaksi|avg_quantity_per_transaksi|
|------------|----------------|---------------------|-------------------|--------------------------|
|R. Prima Laksmiwati, S.Gz|8|17269000|2158625.0000|50.1250|
|Dt. Radika Winarno|8|16320000|2040000.0000|45.2500|
|Kayla Astuti|12|15953250|1329437.5000|40.3333|
|Ajiman Haryanti|8|15527000|1940875.0000|47.5000|
|Luhung Pradipta|8|11272000|1409000.0000|65.6250|

**Insight:** \

- Pembeli an Kayla Astuti menjadi pembeli dengan jumlah transaksi terbanyak yaitu 12x.
- Namun, pembeli an R. Prima Laksmiwati, S.Gz menjadi pembeli dengan total nilai transaksi terbesar sebanyak Rp 17.269.000 walau hanya melakukan 8x transaksi.

## 4. Pembeli sekaligus penjual

Selanjutnya, akan dicari tahu jenis pengguna yang menjadi reseller offline atau punya toko offline, yakni pembeli yang sering sekali membeli barang dan seringnya dikirimkan ke alamat yang sama. Pembelian juga dengan quantity produk yang banyak. Sehingga kemungkinan barang ini akan dijual lagi.

```sql
SELECT
	nama_user AS nama_pengguna,
	jumlah_transaksi_beli,
	jumlah_transaksi_jual
FROM
	users
INNER JOIN (
	SELECT
		buyer_id,
		COUNT(1) AS jumlah_transaksi_beli
	FROM
		orders
	GROUP BY
		1) AS buyer ON
	buyer_id = user_id
INNER JOIN (
	SELECT
		seller_id,
		COUNT(1) AS jumlah_transaksi_jual
	FROM
		orders
	GROUP BY
		1) AS seller ON
	seller_id = user_id
WHERE
	jumlah_transaksi_beli >= 7
ORDER BY
	1;
```

**Result:**
|nama_pengguna|jumlah_transaksi_beli|jumlah_transaksi_jual|
|-------------|---------------------|---------------------|
|Bahuwirya Haryanto|8|1032|
|Dr. Adika Kusmawati, S.Pt|7|1098|
|Gandi Rahmawati|8|1078|
|Jaka Hastuti|7|1094|
|R.M. Prayogo Damanik, S.Pt|8|1044|

**Insight:** \
Dr. Adika Kusmawati, S.Pt menjadi pengguna dengan jumlah transaksi jual terbanyak yaitu sebanyak 1098x transaksi. Ia juga melakukan 7x transaksi.

## 5. Lama transaksi dibayar

Terakhir, bagaimana trend lama waktu transaksi dibayar sejak dibuat?

```sql
SELECT
	EXTRACT(YEAR_MONTH FROM created_at) AS tahun_bulan,
	COUNT(1) AS jumlah_transaksi,
	AVG(DATEDIFF(paid_at, created_at)) AS avg_lama_dibayar,
	MIN(DATEDIFF(paid_at, created_at)) AS min_lama_dibayar,
	MAX(DATEDIFF(paid_at, created_at)) AS max_lama_dibayar
FROM
	orders
GROUP BY
	1
ORDER BY
	1;
```

**Result:**
|tahun_bulan|jumlah_transaksi|avg_lama_dibayar|min_lama_dibayar|max_lama_dibayar|
|-----------|----------------|----------------|----------------|----------------|
|201901|117|7.0467|1|14|
|201902|354|7.5399|1|14|
|201903|668|7.4602|1|14|
|201904|984|7.2910|1|14|
|201905|1462|7.3692|1|14|
|201906|1913|7.5729|1|14|
|201907|2667|7.4549|1|14|
|201908|3274|7.6216|1|14|
|201909|4327|7.5021|1|14|
|201910|5577|7.4706|1|14|
|201911|7162|7.5188|1|14|
|201912|10131|7.4980|1|14|
|202001|5062|7.4152|1|14|
|202002|5872|7.5092|1|14|
|202003|7323|7.4674|1|14|
|202004|7955|7.4792|1|14|
|202005|10026|7.4549|1|14|

**Insight:**

- Sepanjang data, seluruh transaksi paling cepat dibayar dalam 1 hari dan paling lama dibayar dalam 14 hari.
- Jumlah transaksi juga mengalami kenaikan dari bulan ke bulan, walau ada penurunan di beberapa bulan tetapi tetap meingkat pada bulan selanjutnya.
