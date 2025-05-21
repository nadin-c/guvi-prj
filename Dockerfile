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





# ----------------- Build Stage -----------------
FROM node:18-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ----------------- Nginx Stage -----------------
FROM nginx:alpine

# Clean default config
RUN rm -f /etc/nginx/conf.d/default.conf

# Add your custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files to Nginx
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
