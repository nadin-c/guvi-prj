# Default-size

FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install


COPY . .


EXPOSE 3000

CMD ["npm", "start"]





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
# FROM node:18-alpine3.19 AS build

# WORKDIR /app

# # Install only prod dependencies
# COPY package.json package-lock.json ./
# RUN npm ci --omit=dev

# # Copy source files
# COPY . .

# # Build React app
# RUN npm run build && npm cache clean --force

# # ----------------- Production Stage -----------------
# FROM nginx:1.25-alpine3.21

# # 🔧 Update vulnerable packages
# RUN apk update && apk upgrade --no-cache

# # Remove default NGINX config
# RUN rm -f /etc/nginx/conf.d/default.conf

# # Add custom config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# # Copy build output from builder
# COPY --from=build /app/build /usr/share/nginx/html

# # Set proper permissions (optional)
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
#     && chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /run

# # USER appuser  # Uncomment for non-root run

# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
