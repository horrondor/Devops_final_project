FROM node:22-alpine AS build

WORKDIR /app

# Copy only package files first
COPY package*.json ./

# Install all dependencies (including dev for build)
RUN npm install

# Upgrade vulnerable dependencies to safe versions
# RUN npm install path-to-regexp@^6.3.0 qs@^6.14.1 tar@^7.5.3 --save \
#     && npm cache clean --force

# Copy app source code
COPY . .


FROM node:22-alpine

WORKDIR /app

# Copy only production dependencies from build stage
COPY --from=build /app/node_modules ./node_modules

# Copy application code
COPY --from=build /app ./

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose app port
EXPOSE 5050

# Start the app
CMD ["npm", "start"]
