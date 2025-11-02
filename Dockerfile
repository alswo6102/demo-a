FROM node:20-alpine
WORKDIR /app

# deps
COPY package*.json ./
RUN npm ci --omit=dev

# 소스 전체 복사 (server.mjs, public/ 포함)
COPY . .

USER node
EXPOSE 3000
ENV PORT=3000 NODE_ENV=production
CMD ["node", "server.mjs"]
