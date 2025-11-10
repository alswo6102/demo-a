# --- Nginx only: 정적 파일 서빙 + /api 프록시 ---
FROM nginx:alpine

# 유틸 (선택) - 헬스체크에 curl 씀
RUN apk add --no-cache curl

# 컨테이너 내부 리슨 포트
ENV PORT=3000
# 백엔드 서비스(default)
ENV API_TARGET=http://backend:8000

# Nginx 설정 복사 (이미 repo에 nginx.conf 있음)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 정적 파일 배포 - public 폴더 전체
COPY public/ /usr/share/nginx/html

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -fsS http://127.0.0.1:${PORT}/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
