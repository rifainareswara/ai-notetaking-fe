# =======================================================
# TAHAP 1: BUILDER (Untuk menginstal dependensi dan membangun aset)
# Kami menggunakan gambar Node.js yang lebih lengkap untuk tahap pembangunan.
# =======================================================
FROM node:20-slim AS builder

# Tetapkan direktori kerja di dalam kontainer
WORKDIR /app

# Salin file package.json dan package-lock.json (atau yarn.lock)
COPY package*.json ./

# Instal dependensi. Kami menggunakan --omit=dev untuk instalasi yang lebih bersih.
RUN npm install --omit=dev

# Salin sisa kode aplikasi
COPY . .

# Jika Anda memiliki langkah build (misalnya, untuk React/Vue/Angular), tambahkan di sini:
# RUN npm run build

# =======================================================
# TAHAP 2: PRODUCTION (Untuk menjalankan aplikasi)
# Kami menggunakan gambar dasar yang lebih kecil dan hanya menyertakan yang penting
# untuk mengurangi ukuran gambar akhir (image size) dan meningkatkan keamanan.
# =======================================================
FROM node:20-slim AS production

# Tetapkan variabel lingkungan untuk mode produksi
ENV NODE_ENV production
ENV PORT 8080

# Tetapkan direktori kerja
WORKDIR /usr/src/app

# Salin HANYA folder node_modules dan file package.json/kode dari tahap builder
# Ini menghindari penyalinan file build (seperti sumber daya pengembangan atau file mentah)
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app .

# Buka port yang akan didengarkan oleh aplikasi Anda
EXPOSE 8080

# Perintah untuk menjalankan aplikasi saat kontainer dimulai
# Pastikan titik masuk (entry point) ini sesuai dengan file utama aplikasi Anda
CMD ["node", "server.js"]