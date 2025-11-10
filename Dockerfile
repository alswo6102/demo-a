# --- build stage ---
FROM node:20-alpine AS build
WORKDIR /app

# 1) 의존성 메타만 먼저 복사 (lockfile 있으면 같이 복사)
COPY package.json ./
COPY package-lock.json* . 2>/dev/null || true

# 2) 조건부 설치 (lockfile 있으면 ci, 없으면 install)
RUN if [ -f package-lock.json ]; then npm ci; else npm install; endif

# 3) 나머지 소스 복사 + 빌드
COPY . .
RUN npm run build   # /app/dist 가정

# --- run stage (Nginx) ---
FROM nginx:alpine
WORKDIR /
RUN apk add --no-cache bash curl gettext
ENV PORT=3000
ENV API_TARGET=http://backend:8000
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -fsS http://127.0.0.1:${PORT}/healthz || exit 1
CMD ["nginx", "-g", "daemon off;"]
