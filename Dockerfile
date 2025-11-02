# Dockerfile
FROM node:20-alpine

WORKDIR /app

# package.json만 먼저 복사 → 의존성 설치 (빌드 캐시 최적화)
COPY package*.json ./
RUN npm ci --omit=dev

# 나머지 코드 복사
COPY . .

# 환경변수 & 포트 설정
ENV PORT=8080
EXPOSE 8080

CMD ["npm", "start"]
