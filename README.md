# PBJ Akademi V4 — Mobile Responsive & Offline Ready

Aplikasi web interaktif latihan mandiri dan simulasi ujian sertifikasi **Pengadaan Barang/Jasa Pemerintah (PBJ) Level 1** (LKPP). Dilengkapi dengan 294 bank soal, pembahasan lengkap, kamus 91 topik, modul materi PDF, dan antarmuka responsif (mobile & desktop).

---

## 📋 Fitur Utama
- **294 Bank Soal & Pembahasan Terpadu**: Soal latihan dan try out historis terstruktur.
- **Kamus Materi 91 Topik**: Penjelasan ringkas beserta referensi halaman modul resmi LKPP.
- **Modul & PDF Offline**: Termasuk 11 dokumen materi lengkap dalam format PDF.
- **Client-Side Single Page Application**: Berjalan 100% di browser tanpa ketergantungan database eksternal.
- **Penyimpanan Lokal (localStorage)**: Riwayat pengerjaan, bookmark, dan catatan tersimpan otomatis dengan fitur ekspor/impor JSON.
- **Tema Terang & Gelap**: Nyaman diakses di perangkat ponsel, tablet, maupun PC.

---

## 📂 Struktur Repositori

```text
├── index.html                           # Halaman utama aplikasi web
├── materi/                              # Dokumen PDF materi modul LKPP & try out
│   ├── bank-soal-terpadu.pdf
│   ├── kamus-pembahasan.pdf
│   ├── kontrak.pdf
│   ├── pemilihan.pdf
│   ├── pengantar.pdf
│   ├── perencanaan.pdf
│   ├── quick-exam.pdf
│   ├── rantai-pasok.pdf
│   ├── swakelola.pdf
│   ├── tryout-historis-lengkap.pdf
│   └── tryout-historis.pdf
├── offline/                             # Salinan paket mandiri offline
├── PREVIEW/                             # Screenshot pratinjau tampilan
├── nginx.conf                           # Konfigurasi Nginx produksi (gzip & cache)
├── Dockerfile                           # Dockerfile berbasis nginx:alpine
├── docker-compose.yml                   # Orkestrasi Docker Compose port 8080
└── README.md
```

---

## 🚀 Panduan Deployment di Proxmox VE

Aplikasi ini berjenis **statis (HTML + CSS + JS)**, sehingga kebutuhan sumber daya server sangat minim (RAM 128MB - 512MB dan 1 vCPU sudah lebih dari cukup).

Anda dapat menggunakan salah satu dari 2 metode di Proxmox:

### Opsi 1: Menggunakan Docker / Docker Compose (Direkomendasikan)
Cocok jika di Proxmox Anda sudah memiliki LXC/VM dengan Docker:

1. **Clone repository ke server:**
   ```bash
   git clone <URL_REPOSITORY_GITHUB_ANDA> /opt/pbj-akademi
   cd /opt/pbj-akademi
   ```

2. **Jalankan container:**
   ```bash
   docker compose up -d --build
   ```

3. **Akses aplikasi:**
   Buka browser dan akses `http://<IP-SERVER-PROXMOX>:8080`.

---

### Opsi 2: Menggunakan Nginx Native di Proxmox LXC Container (Ubuntu / Debian / Alpine)
Paling hemat memori (cukup 128MB RAM pada container LXC):

1. **Update dan pasang Nginx serta Git:**
   ```bash
   # Di dalam console LXC Ubuntu/Debian:
   apt update && apt install -y nginx git
   ```

2. **Clone repository ke direktori web server:**
   ```bash
   git clone <URL_REPOSITORY_GITHUB_ANDA> /var/www/pbj-akademi
   ```

3. **Buat konfigurasi virtual host Nginx:**
   ```bash
   nano /etc/nginx/sites-available/pbj-akademi
   ```
   Isi dengan:
   ```nginx
   server {
       listen 80;
       server_name pbj.domain-anda.com; # atau '_' jika menggunakan IP

       root /var/www/pbj-akademi;
       index index.html;

       gzip on;
       gzip_types text/plain text/css application/json application/javascript;

       location / {
           try_files $uri $uri/ /index.html;
       }

       location ~* \.(?:css|js|jpg|jpeg|gif|png|ico|pdf)$ {
           expires 7d;
           add_header Cache-Control "public";
       }
   }
   ```

4. **Aktifkan konfigurasi dan restart Nginx:**
   ```bash
   ln -s /etc/nginx/sites-available/pbj-akademi /etc/nginx/sites-enabled/
   rm -f /etc/nginx/sites-enabled/default
   nginx -t
   systemctl restart nginx
   ```

5. **Akses aplikasi:**
   Buka `http://<IP-LXC-CONTAINER>`.

---

## 🌐 Menghubungkan ke Internet (Online)

Untuk dapat diakses dari luar jaringan lokal (internet publik):
- **Cloudflare Tunnel (Paling Aman & Praktis)**: Pasang `cloudflared` di LXC/VM Proxmox, arahkan ke `http://localhost:80` atau `http://localhost:8080`. Tidak perlu port forwarding IP publik.
- **Nginx Proxy Manager / Traefik**: Arahkan subdomain ke IP lokal container di port 80/8080 lengkap dengan SSL Let's Encrypt gratis.
- **Port Forwarding Router**: Forward port 80/443 IP publik ISP Anda ke IP server Proxmox.

---

## 🔄 Cara Melakukan Pembaruan (Update di Server)

Jika Anda melakukan perubahan di komputer dan sudah di-push ke GitHub:

```bash
cd /opt/pbj-akademi # atau /var/www/pbj-akademi
git pull origin main

# Jika menggunakan Docker Compose:
docker compose down && docker compose up -d --build
```
