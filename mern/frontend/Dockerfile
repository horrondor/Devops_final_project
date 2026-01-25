# Description: Dockerfile for the client side of the MERN stack application


FROM node:22-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the file from your host to your current location
COPY package*.json ./

RUN npm ci --only=production
# RUN npm install --frozen-lockfile

COPY . .


RUN npm run build

FROM nginx:alpine 

COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]