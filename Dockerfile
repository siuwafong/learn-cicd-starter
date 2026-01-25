# Stage 1: Build the application with a fuller Node.js image
FROM --platform=linux/amd64 node:18 AS builder

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Create a slim runtime image
FROM --platform=linux/amd64 node:18-slim

WORKDIR /usr/src/app

# Copy only necessary files from the builder stage
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package.json ./package.json

ENV PORT=8080
CMD ["node", "dist/main.js"]