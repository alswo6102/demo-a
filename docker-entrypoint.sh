#!/bin/sh
set -e

# envsubst로 템플릿을 실제 설정으로 렌더링
envsubst '\$PORT \$API_TARGET' \
  < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
