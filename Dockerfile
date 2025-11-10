# --- build stage ---
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi
# --- run stage (Nginx) ---
FROM nginx:alpine
# 빌드 산출물 배포
COPY --from=build /app/dist /usr/share/nginx/html
# Nginx 프록시 설정 주입
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
