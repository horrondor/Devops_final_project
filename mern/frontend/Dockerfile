# ---- Build stage ----
FROM node:22-alpine AS builder

WORKDIR /app

# Prevent Cypress binary download
ENV CYPRESS_INSTALL_BINARY=0

RUN apk update && apk upgrade --no-cache

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build


# ---- Runtime stage ----
FROM nginx:1.27.2-alpine3.24

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
