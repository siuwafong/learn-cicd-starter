# Build for Cloud Run architecture
FROM --platform=linux/amd64 node:18-slim

WORKDIR /usr/src/app

# Copy only package files first (caching)
COPY package.json package-lock.json ./

# Install dependencies inside container
RUN npm ci

# Copy the rest of the app
COPY . .

# Build the app
RUN npm run build

# Cloud Run uses PORT=8080
ENV PORT=8080

# Bind to 0.0.0.0 in your app (main.ts)
CMD ["node", "dist/main.js"]
