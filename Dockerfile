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

# Install only production dependencies
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy app source code
COPY . .

# Build the React app (or similar)
RUN npm run build && npm cache clean --force


# ----------------- Final Stage -----------------
FROM nginx:alpine

# Remove default NGINX config
RUN rm /etc/nginx/conf.d/default.conf

# Copy build output to NGINX public folder
COPY --from=build /app/build /usr/share/nginx/html

# ---- Security: Create non-root user ----
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# ---- Security: Lock root user ----
RUN passwd -l root && chsh -s /sbin/nologin root

# Change ownership of content to non-root user
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Switch to non-root user
USER appuser

# Expose port and run NGINX
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
