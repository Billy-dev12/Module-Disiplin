# 🎯 Fokus Terminal & Sosmed Blocker (Magisk Module)

Modul Magisk/KernelSU/APatch universal untuk membantu kamu disiplin, membatasi kecanduan sosial media (maksimal 30 menit per hari), dan fokus ngulik di terminal!

Modul ini dibuat khusus untuk memantau sistem secara *systemless* dan berjalan otomatis sejak HP dinyalakan.

---

## ✨ Fitur Utama

1. **⏳ Limitasi Sosmed Harian (30 Menit):**
   Membatasi penggunaan aplikasi sosial media berikut secara kumulatif selama maksimal 30 menit (1800 detik) per hari:
   * **YouTube** (`com.google.android.youtube` / `app.revanced.android.youtube`)
   * **Instagram** (`com.instagram.android` / `com.instagram.lite`)
   * **TikTok** (`com.zhiliaoapp.musically` / `com.ss.android.ugc.trill`)

2. **🚫 Auto-Kill & Notifikasi Native:**
   Jika batas waktu terlewati, aplikasi target akan otomatis ditutup paksa (`am force-stop`) dan sistem akan mengirimkan notifikasi peringatan:
   > *⚠️ WAKTU SOSMED HABIS! Ingat bro, kamu sudah buka sosmed selama 30 menit! Kembali fokus ke terminal!*

3. **🔄 Auto-Reset Tengah Malam:**
   Timer penggunaan otomatis di-reset kembali ke `0` setiap pergantian hari pukul `00:00` malam.

4. **🟢 CLI Command `cek_fokus`:**
   Dilengkapi dengan perintah khusus di terminal HP kamu. Cukup ketik `cek_fokus` di terminal (Termux/ADB) dengan hak akses root untuk melihat sisa waktu belajar dengan tampilan berwarna yang keren!

5. **📊 Log Real-Time:**
   Menyimpan laporan status pemantauan aplikasi aktif dan background services di memori internal kamu di `/sdcard/monitor.txt` yang diperbarui setiap 5 detik.

---

## ⚡ Prasyarat Sistem
* Perangkat Android wajib dalam keadaan **ROOT** (menggunakan Magisk, KernelSU, atau APatch).
* Kompatibel dengan Android 9 (Pie) hingga versi Android terbaru.
* Diuji sukses pada **POCO X3 Pro (vayu)**.

---

## 🚀 Cara Pemasangan

1. Ambil file **`app_service_monitor.zip`** yang sudah dikompilasi.
2. Buka aplikasi root manager kamu (Magisk / KernelSU / APatch).
3. Masuk ke bagian **Modules**, klik **Install from storage**.
4. Pilih file `app_service_monitor.zip`, tunggu hingga selesai, lalu **Reboot** HP kamu.

---

## 🕹️ Cara Menggunakan CLI di Terminal

Setelah HP menyala kembali, buka Termux atau aplikasi terminal lainnya di HP kamu, lalu ketik perintah berikut:

```bash
su
cek_fokus
```

Sistem akan langsung menampilkan UI info real-time seperti ini:
```ansi
===========================================
        🎯 REMINDER FOKUS TERMINAL 🎯      
===========================================
Device  : POCO X3 Pro (vayu)
Limit   : 30 Menit / Hari (YouTube, IG, TikTok)
-------------------------------------------
Terpakai: 12 Menit 34 Detik
Sisa    : 17 Menit 26 Detik sebelum di-kill!
Status  : 🟢 AKTIF (Silakan fokus!)
===========================================
```

---

## 🛠️ Cara Melakukan Debugging & Lokasi File Status
Jika kamu ingin memantau file status secara manual, datanya disimpan secara terisolasi di folder berikut:
* **`/data/local/tmp/socmed_time.txt`** ── Menyimpan total detik penggunaan sosmed hari ini.
* **`/data/local/tmp/socmed_date.txt`** ── Menyimpan tanggal hari ini untuk pendeteksi reset tengah malam.
* **`/sdcard/monitor.txt`** ── Log visual aktivitas layar dan background service.

---
*Dibuat dengan 💻 oleh Billy*
