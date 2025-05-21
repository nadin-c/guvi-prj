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
# ----------------- Final Stage -----------------
FROM nginx:alpine

# Remove default NGINX config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy build output
COPY --from=build /app/build /usr/share/nginx/html

# ---- Security: Create non-root user ----
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# ---- Security: Lock root user (disable password login) ----
RUN passwd -l root

# Change ownership to new user
RUN chown -R appuser:appgroup /usr/share/nginx/html

# Use non-root user
USER appuser

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
