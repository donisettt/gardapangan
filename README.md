# GardaPangan 🍲 - Smart Food Rescue App

![GardaPangan Banner](docs/banner.png)

**"Selamatkan Makanan, Bantu Sesama."**

**GardaPangan** adalah aplikasi mobile berbasis *Food Rescue* yang menghubungkan UMKM kuliner yang memiliki surplus makanan dengan mahasiswa atau masyarakat yang membutuhkan makanan berkualitas dengan harga terjangkau.

Project ini dikembangkan untuk memenuhi **Ujian Tengah Semester (UTS) Pemrograman Mobile 2** di Universitas Teknologi Bandung, sekaligus sebagai eksplorasi implementasi **AI** dan **Realtime Database** pada aplikasi mobile.

---

## 📱 Fitur Unggulan (Key Features)

Aplikasi ini tidak sekadar CRUD, tetapi mengintegrasikan berbagai sensor dan layanan cloud:

* **🔐 Secure Authentication:** Sistem Login & Register aman menggunakan **Firebase Auth**.
* **🗺️ Realtime Geolocation:** Menampilkan jarak toko dari lokasi pengguna secara akurat menggunakan GPS.
* **📍 Interactive Map:** Peta interaktif berbasis **OpenStreetMap** untuk melihat sebaran lokasi makanan di sekitar.
* **🤖 Smart Chef AI:** Asisten cerdas terintegrasi **Google Gemini AI** yang memberikan ide resep kreatif dari bahan makanan sisa.
* **🔥 Realtime Transaction:** Pembaruan stok dan status pesanan secara instan (tanpa refresh) menggunakan **Cloud Firestore Streams**.
* **📷 QR Code Validation:** Sistem verifikasi pengambilan barang yang aman menggunakan pemindai **QR Code** unik per transaksi.
* **⏱️ Auto-Expired System:** Logika otomatis yang mendeteksi batas waktu pengambilan makanan.

---

## 🛠️ Teknologi yang Digunakan (Tech Stack)

Project ini dibangun dengan menerapkan prinsip **Clean Code** dan struktur folder yang modular.

* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Authentication, Cloud Firestore)
* **Artificial Intelligence:** Google Generative AI SDK (Gemini Flash)
* **Maps Services:** Flutter Map, LatLong2, Geolocator
* **UI Components:** Google Fonts (Poppins), Cupertino Icons, Shimmer Loading
* **Utilities:** Mobile Scanner, QR Flutter, URL Launcher, Intl

---

## 👤 Tentang Pengembang

Project ini dibuat dengan ❤️ oleh:

**Doni Setiawan Wahyono**
* **Role:** Mobile Application Developer
* **Kampus:** Universitas Teknologi Bandung
* **NPM:** 23552011146

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue.svg)](https://www.linkedin.com/in/doni-setiawan-wahyono)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black.svg)](https://www.github.com/donisettt)
[![Instagram](https://img.shields.io/badge/Instagram-Follow-purple.svg)](https://www.instagram.com/dnisetyaw)