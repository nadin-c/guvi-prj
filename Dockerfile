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

FROM node:18-alpine3.19 AS build

WORKDIR /app


COPY package.json package-lock.json ./
RUN npm ci --omit=dev


COPY . .


RUN npm run build && npm cache clean --force


FROM nginx:1.25-alpine3.21


RUN apk update && apk upgrade --no-cache


RUN rm -f /etc/nginx/conf.d/default.conf


COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/build /usr/share/nginx/html

RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /usr/share/nginx/html /var/cache/nginx /run


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
