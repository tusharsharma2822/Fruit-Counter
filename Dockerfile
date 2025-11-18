# Multi-stage Dockerfile for project root (server.js, index.html and package.json at repo root)
FROM openshift/node:18-minimal-ubi8 AS builder
WORKDIR /app

# Copy package files and install production deps
COPY package*.json ./
RUN npm ci --only=production

# Copy full project into image
COPY . .

# Final runtime image
FROM node:18-alpine AS runtime
WORKDIR /app

# Copy built app
COPY --from=builder /app /app

ENV NODE_ENV=production
EXPOSE 4000

# Ensure package.json has "type": "module" if server uses ES modules.
CMD ["node", "server.js"]