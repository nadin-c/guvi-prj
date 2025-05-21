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

# ----------------- Build Stage -----------------
FROM node:18-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY . .

RUN npm run build && npm cache clean --force


# ----------------- Final Stage -----------------
FROM nginx:alpine

# Remove default NGINX config
RUN rm /etc/nginx/conf.d/default.conf

# Copy build output from build stage
COPY --from=build /app/build /usr/share/nginx/html

# ---- Security: Create non-root user ----
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# ---- Security: Lock root user (disable password login) ----
RUN passwd -l root

# Change ownership of content to new user
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Give permission on /run so nginx can create nginx.pid
RUN mkdir -p /run && chown appuser:appgroup /run

# Switch to non-root user
USER appuser

# Expose port 80 for nginx
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
