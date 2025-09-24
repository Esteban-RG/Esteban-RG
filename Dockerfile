FROM nginx:1.27-alpine

# Copiar configuración personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar sitio estático
COPY src/ /usr/share/nginx/html/
COPY i18n/ /usr/share/nginx/html/i18n/
COPY data/ /usr/share/nginx/html/data/
COPY public/ /usr/share/nginx/html/public/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
