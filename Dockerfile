# ---- Dockerfile (fixed) ----
FROM node:20-alpine

WORKDIR /app

# 1) 의존성 설치 캐시 최적화: package.json + lock 복사
COPY package*.json ./

# 2) 잠금파일 유무에 따라 분기 (prod 모드)
#    - lock 있으면 npm ci
#    - 없으면 npm install --only=production (npm v10 이상은 --omit=dev도 가능)
#    - 감사/펀드 비활성화로 깔끔하게
ENV NODE_ENV=production \
    NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_LOGLEVEL=warn

RUN if [ -f package-lock.json ]; then \
      echo "Using npm ci (lockfile detected)"; \
      npm ci --omit=dev; \
    else \
      echo "No lockfile -> using npm install (prod only)"; \
      npm install --only=production; \
    fi

# 3) 나머지 앱 복사 & 실행 설정
COPY . .
EXPOSE 3000
CMD ["npm","start"]
