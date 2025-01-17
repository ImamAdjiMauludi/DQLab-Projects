# Data Analysis for E-Commerce Challenge 💻🛍️

Dataset yang digunakan merupakan data dari DQLab Store yang merupakan e-commerce dimana pembeli dan penjual saling bertemu. Pengguna bisa membeli barang dari pengguna lain yang berjualan. Setiap pengguna bisa menjadi pembeli sekaligus penjual.

## Daftar Isi 📃

- [Data Analysis for E-Commerce Challenge 💻🛍️](#data-analysis-for-e-commerce-challenge-️)
  - [Daftar Isi 📃](#daftar-isi-)
  - [Deskripsi Project 📄](#deskripsi-project-)
  - [Deskripsi Dataset 💾](#deskripsi-dataset-)
- [Data Preparation ⚙️](#data-preparation-️)
  - [Preprocessing: Cleaning and Formating](#preprocessing-cleaning-and-formating)
- [Case Study Task and Insight 💡](#case-study-task-and-insight-)
  - [Chapter 1 - Data](#chapter-1---data)
  - [Chapter 2 - Melengkapi SQL](#chapter-2---melengkapi-sql)
  - [Chapter 3 - Membuat SQL](#chapter-3---membuat-sql)

## Deskripsi Project 📄

Pada tugas kali ini, soal dibagi menjadi 3 chapter, yakni chapter data, melengkapi kode SQL dan membuat kode SQL.

Pada chapter data, soal diselesaikan dengan memilih pilihan ganda dimana jawaban benar bisa lebih dari 1, pastikan semua jawaban yang benar sudah terpilih untuk bisa mendapatkan score dan lanjut ke soal selanjutnya.

Chapter melengkapi dan membuat kode SQL dikerjakan dengan menulis kode SQL agar mendapatkan hasil sesuai petunjuk, lalu mengirimnya untuk memastikan kode yang dibuat sudah benar. Jenis database yang digunakan adalah MySQL.

## Deskripsi Dataset 💾

![image](https://github.com/user-attachments/assets/7a097d16-6638-4bca-a911-dc51a96a54b4)

Ada 4 tabel yang tersedia:

- `users`, berisi detail data pengguna. Berisi,
  - user_id : ID pengguna
  - nama_user : nama pengguna
  - kodepos : kodepos alamat utama dari pengguna
  - email : email dari pengguna
- `products`, berisi detail data dari produk yang dijual. Berisi,
  - product_id : ID produk
  - desc_product : nama produk
  - category : kategori produk
  - base_price : harga asli dari produk
- `orders`, berisi transaksi pembelian dari pembeli ke penjual. Berisi,
  - order_id : ID transaksi
  - seller_id : ID dari pengguna yang menjual
  - buyer_id : ID dari pengguna yang membeli
  - kodepos : kodepos alamat pengirimian transaksi (bisa beda dengan alamat utama)
  - subtotal : total harga barang sebelum diskon
  - discount : diskon dari transaksi
  - total : total harga barang setelah dikurangi diskon, yang dibayarkan pembeli
  - created_at : tanggal transaksi
  - paid_at : tanggal dibayar
  - delivery_at : tanggal pengiriman
- `order_details`, berisi detail barang yang dibeli saat transaksi. Berisi,
  - order_detail_id : ID table ini
  - order_id : ID dari transaksi
  - product_id : ID dari masing-masing produk transaksi
  - price : harga barang masing-masing produk
  - quanti ty : jumlah barang yang dibeli dari masing-masing produk

# Data Preparation ⚙️

## Preprocessing: Cleaning and Formating

**1. Cleaning null value**

```sql
SELECT COUNT(*)
FROM  orders o
WHERE
	created_at LIKE "NA" OR
	paid_at LIKE "NA" OR
	delivery_at  LIKE "NA";
```

**Result:**
|COUNT(\*)|
|--------|
|9790|

**Insight:** \
Terdapat 9790 row yang berisi null value, pada 3 kolom date.

**2. Membuat temporary table untuk merubah data-type**

```sql
CREATE TEMPORARY TABLE temp_orders AS
SELECT *
FROM orders o;

DROP TABLE orders;

CREATE TABLE orders AS
SELECT
	order_id,
	seller_id,
	buyer_id,
	kodepos,
	subtotal,
	discount,
	total,
	CAST(CASE WHEN created_at LIKE "NA" THEN NULL ELSE created_at END AS DATE) AS created_at,
	CAST(CASE WHEN paid_at LIKE "NA" THEN NULL ELSE paid_at END AS DATE) AS paid_at,
	CAST(CASE WHEN delivery_at LIKE "NA" THEN NULL ELSE delivery_at END AS DATE) AS delivery_at
FROM temp_orders;

SELECT *
FROM orders o
LIMIT 50;
```

**Insight:** \
Operasi di atas membuat temporary table orders untuk mengganti value "NA" dengan NULL pada 3 kolom tanggal serta berubah typenya ke DATE.

**3. Membuat table index**

```sql
CREATE INDEX idx_order_details ON order_details (order_detail_id,order_id);
CREATE INDEX idx_orders ON orders (order_id);
CREATE INDEX idx_users ON users (user_id);
```

**Insight:** \
Membuat index pada 3 tabel tersebut untuk mempercepat proses query karena baris data sangat banyak.

# Case Study Task and Insight 💡

## Chapter 1 - Data
Dataset berasal dari DQLab. Pada Chapter ini data akan di-eksplorasi lebih lanjut dalam 10 pertanyaan untuk mendapat insight dari dataset yang tersedia.\
Link to Case 🔗👉 [Chapter 1 - Data](https://github.com/ImamAdjiMauludi/DQLab-Projects/blob/125ee028b57cd8eaeb23073b82d6bf42a1a83e8f/Data%20Analysis%20for%20E-Commerce%20Challenge/Chapter%201%20-%20Data.md)

## Chapter 2 - Melengkapi SQL

Link to Case 🔗👉 SOON

## Chapter 3 - Membuat SQL

Link to Case 🔗👉 SOON
