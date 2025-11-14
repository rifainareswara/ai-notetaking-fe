# Gunakan image Ubuntu sebagai base
FROM ubuntu:22.04

# Install Node.js dan npm
RUN apt-get update && apt-get install -y curl \
    # MEMPERBAIKI: Mengganti Node.js 16.x dengan 20.x (LTS) untuk menyelesaikan masalah crypto.getRandomValues
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Set working directory
WORKDIR /app

# Copy package.json dan package-lock.json ke dalam container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy semua file proyek ke dalam container
COPY . .

# Build aplikasi Next.js
RUN npm run build

# Jalankan Next.js di mode production
CMD ["npm", "run", "start"]