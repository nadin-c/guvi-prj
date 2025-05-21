# Default-size

# FROM node:18

# WORKDIR /app

# COPY package*.json ./
# RUN npm install


# COPY . .


# EXPOSE 3000

# CMD ["npm", "start"]





# Reduced-size

# FROM node:18-alpine AS build
# WORKDIR /app


# COPY package.json package-lock.json ./
# RUN npm ci --omit=dev


# COPY . .


# RUN npm run build && npm cache clean --force


# FROM nginx:alpine

# RUN rm /etc/nginx/conf.d/default.conf

# COPY --from=build /app/build /usr/share/nginx/html

# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]





# Secure image



# # ----------------- Build Stage -----------------
# FROM node:18-alpine AS build

# WORKDIR /app

# COPY package.json package-lock.json ./
# RUN npm ci --omit=dev

# COPY . .

# RUN npm run build && npm cache clean --force


# # ----------------- Final Stage -----------------
# FROM nginx:alpine

# # Remove default nginx config
# RUN rm /etc/nginx/conf.d/default.conf

# # Copy custom nginx config (make sure you have nginx.conf alongside this Dockerfile)
# COPY nginx.conf /etc/nginx/nginx.conf

# # Copy build output from build stage
# COPY --from=build /app/build /usr/share/nginx/html

# # Create non-root user and group
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# # Lock root user password (disable root login)
# RUN passwd -l root

# # Change ownership of web files to non-root user
# RUN chown -R appuser:appgroup /usr/share/nginx/html

# # Switch to non-root user
# USER appuser

# EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]

# ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# # ----------------- Build Stage -----------------
# FROM node:18-alpine AS build

# WORKDIR /app

# # Copy dependencies and install
# COPY package.json package-lock.json ./
# RUN npm ci --omit=dev

# # Copy rest of the app
# COPY . .

# # Build the React app
# RUN npm run build && npm cache clean --force

# # ----------------- Final Stage -----------------
# FROM nginx:alpine

# # Remove default NGINX config if it exists
# RUN rm -f /etc/nginx/conf.d/default.conf

# # Copy the React build output to nginx's html folder
# COPY --from=build /app/build /usr/share/nginx/html

# # ✅ Add custom nginx config
# COPY default.conf /etc/nginx/conf.d/default.conf

# # Create non-root user
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
#     chown -R appuser:appgroup /usr/share/nginx/html

# # Use non-root user (optional, works fine if permissions are set)
# USER appuser

# EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]


# # ----------------- Build Stage -----------------
# FROM node:18-alpine AS build

# WORKDIR /app

# # Copy dependencies
# COPY package.json package-lock.json ./
# RUN npm ci --omit=dev

# # Copy rest of the app source
# COPY . .

# # Build the React app
# RUN npm run build && npm cache clean --force

# # ----------------- Production Stage -----------------
# FROM nginx:alpine

# # Remove default NGINX config
# RUN rm -f /etc/nginx/conf.d/default.conf

# # Add custom Nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# # Copy the React build output to NGINX html directory
# COPY --from=build /app/build /usr/share/nginx/html

# # Optional: Create and fix permissions (if you're running as non-root)
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
#     && chown -R appuser:appgroup /usr/share/nginx/html \
#     && chown -R appuser:appgroup /var/cache/nginx /run
# # USER appuser

# EXPOSE 80

# # Start Nginx
# CMD ["nginx", "-g", "daemon off;"]





# ----------------- Build Stage -----------------
FROM node:18-alpine3.19 AS build

WORKDIR /app

# Install only prod dependencies
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy source files
COPY . .

# Build React app
RUN npm run build && npm cache clean --force

# ----------------- Production Stage -----------------
FROM nginx:1.25-alpine3.19

# Update and upgrade base image to patch known vulnerabilities
RUN apk update && apk upgrade --no-cache

# Remove default NGINX config
RUN rm -f /etc/nginx/conf.d/default.conf

# Add your custom config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build output from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Set permissions for running as non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /run

# Switch to non-root user (optional for extra security)
USER appuser

# Expose web server port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
