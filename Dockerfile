# Stage 1: Build Angular application
FROM node AS builder

# spring boot profile
ARG ARG_ANGULAR_PROFILES_ACTIVE

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the Angular app
RUN npm run $ARG_ANGULAR_PROFILES_ACTIVE

# Stage 2: Serve the app with nginx
FROM nginx:alpine

# Copy built files from the previous stage
COPY --from=builder /app/dist/poc-k8s-keycloak-angular/browser /usr/share/nginx/html

# Expose the port nginx is running on
EXPOSE 80

# Command to run the nginx server
CMD ["nginx", "-g", "daemon off;"]