# 1. 베이스 이미지 설정
FROM node:20-alpine

# 2. 작업 디렉토리 설정
WORKDIR /app

# 3. 의존성 설치 (가장 핵심적인 변경 부분)
# package.json과 package-lock.json을 먼저 복사
COPY package*.json ./

# ❗ [핵심 수정] package-lock.json이 있으면 npm ci, 없으면 npm install 실행
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

# 4. 나머지 소스 코드 복사
COPY . .

# 5. 애플리케이션 포트 노출
EXPOSE 3000

# 6. 애플리케이션 실행
CMD [ "node", "server.mjs" ]
