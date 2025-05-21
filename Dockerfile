# Default-size

FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install


COPY . .


FROM nginx

COPY --from=0 /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]





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
