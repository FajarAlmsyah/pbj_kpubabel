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
├── docker/                              # Konfigurasi container
│   └── nginx/
│       └── nginx.conf                   # Nginx config (gzip, cache & PDF support)
├── offline/                             # Salinan paket mandiri offline
├── PREVIEW/                             # Screenshot pratinjau tampilan
├── docker-compose.yml                   # Docker Compose port 8002
├── .env.example                         # Contoh variabel lingkungan port
├── Dockerfile                           # Dockerfile mandiri berbasis nginx:alpine
└── README.md
```

---

## 🚀 Panduan Deployment di Proxmox LXC (Docker)

Struktur ini telah disesuaikan agar selaras dengan lingkungan Docker LXC Anda (misal di `/opt/app/pbj-akademi`).

### 1. Masuk ke Server LXC & Clone Proyek
```bash
# Buat direktori atau clone ke /opt/app/
cd /opt/app
git clone <URL_REPOSITORY_GITHUB_ANDA> pbj-akademi
cd pbj-akademi
```

### 2. Atur Port (.env)
Aplikasi sebelumnya (`sepradik`) menggunakan port `8001`. Di aplikasi ini, default port adalah `8002`:
```bash
cp .env.example .env
# (Opsional) Ubah APP_PORT di .env jika ingin menggunakan port lain
```

### 3. Jalankan Container
```bash
docker compose up -d
```

### 4. Akses Web
Buka browser:
`http://<IP_LXC_PROXMOX>:8002`

---

## 🔄 Cara Melakukan Pembaruan (Update di Server)

Karena direktori proyek di-*mount* langsung (`./:/usr/share/nginx/html:ro`), setiap pembaruan via git akan langsung aktif seketika:

```bash
cd /opt/app/pbj-akademi
git pull origin main
```
*(Tidak perlu rebuild image)*
