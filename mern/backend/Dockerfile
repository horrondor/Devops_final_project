# ---- Build stage ----
FROM node:current-alpine3.23 AS build
WORKDIR /app

# Upgrade base Alpine packages
RUN apk update && apk upgrade --no-cache

# Copy package.json for caching
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy application code
COPY . .

# ---- Runtime stage ----
FROM node:current-alpine3.23 AS runtime
WORKDIR /app

# Upgrade Alpine packages for CVEs
RUN apk update && apk upgrade --no-cache

# Copy app and node_modules from build stage
COPY --from=build /app ./

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /app
USER appuser

EXPOSE 5050

# Start the app
CMD ["npm", "start"]
