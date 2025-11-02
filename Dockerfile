FROM node:20-alpine
WORKDIR /app
COPY package.json ./
RUN npm ci --omit=dev
COPY server.mjs ./server.mjs
COPY public ./public
USER node
EXPOSE 3000
ENV PORT=3000 NODE_ENV=production
CMD ["node", "server.mjs"]
