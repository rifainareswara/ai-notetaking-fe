# =======================================================
# TAHAP 1: BUILDER (Untuk menginstal dependensi dan membangun aset)
# =======================================================
# Menggunakan node:20-slim sebagai dasar untuk tahap build
FROM node:20-slim AS builder

# Tetapkan direktori kerja di dalam kontainer
WORKDIR /app

# Salin file package.json dan package-lock.json
COPY package*.json ./

# Instal SEMUA dependensi, termasuk devDependencies yang diperlukan untuk build
# (Menghapus --omit=dev karena vite/typescript diperlukan untuk build)
RUN npm install

# Salin sisa kode aplikasi
COPY . .

# Jalankan skrip build dari package.json (tsc -b && vite build)
# Ini akan membuat folder /app/dist
RUN npm run build

# =======================================================
# TAHAP 2: PRODUCTION (Hanya menyajikan file statis hasil build)
# Menggunakan Alpine untuk ukuran gambar yang sangat kecil dan aman.
# =======================================================
FROM node:20-alpine AS production 

# Instal 'serve' secara global, server web statis yang ringan
RUN npm install -g serve

# Tetapkan direktori kerja
WORKDIR /app

# Salin HANYA folder 'dist' (hasil build) dari tahap builder
COPY --from=builder /app/dist .

# Buka port 3000, agar sesuai dengan docker-compose.yml (3008:3000)
EXPOSE 3000

# Perintah untuk menjalankan 'serve'
# -s: Mode Single Page Application (SPA) (mengalihkan semua rute ke index.html)
# .: Sajikan direktori saat ini (yang berisi file 'dist')
# -l 3000: Dengarkan di port 3000
CMD ["serve", "-s", ".", "-l", "3000"]
