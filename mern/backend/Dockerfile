# ---- Build stage ----
FROM node:22-alpine AS build

# Set working directory
WORKDIR /app

# Upgrade Alpine packages to fix base vulnerabilities (libpng, etc)
RUN apk update && apk upgrade --no-cache

# Copy package files first for caching
COPY package*.json ./

# Install all dependencies for build
RUN npm ci

# Copy app source code
COPY . .

# Optional: run tests or build scripts if any
# RUN npm run build


# ---- Runtime stage ----
FROM node:22-alpine AS runtime

WORKDIR /app

# Upgrade runtime Alpine packages for CVEs
# RUN apk update && apk upgrade --no-cache

# Copy only production dependencies from build stage
COPY --from=build /app/node_modules ./node_modules

# Copy app code
COPY --from=build /app ./

# Update vulnerable packages to patched versions
RUN npm install body-parser@1.20.3 glob@10.5.0 path-to-regexp@0.1.10 qs@6.14.1 tar@7.5.4 --save

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /app

USER appuser

# Expose app port
EXPOSE 5050

# Start the app
CMD ["npm", "start"]
