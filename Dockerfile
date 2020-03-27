# Stage 1 - Build the image
FROM node:lts-stretch-slim as build

WORKDIR /app

# Install app dependencies
# Ensure both package.json AND package-lock.json are copied
COPY package*.json ./
RUN npm install

# Build the source
COPY . .
RUN npm run-script build

# Package into Nginx
# Stage 2 - Production Environment
FROM nginx:1.17.9-alpine

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy the application
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
