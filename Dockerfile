FROM nginx:1.27-alpine

# Instalar dependencias necesarias para HTTPS y healthcheck
RUN apk add --no-cache tzdata wget ca-certificates && \
    cp /usr/share/zoneinfo/America/Mexico_City /etc/localtime && \
    echo "America/Mexico_City" > /etc/timezone

# Crear usuario no-root para mayor seguridad
RUN addgroup -g 1001 -S nginx-user && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G nginx-user -g nginx-user nginx-user

# Copiar configuración personalizada
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Crear directorio y establecer permisos
RUN mkdir -p /usr/share/nginx/html && \
    chown -R nginx-user:nginx-user /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Copiar sitio estático con permisos correctos
COPY --chown=nginx-user:nginx-user src/ /usr/share/nginx/html/
COPY --chown=nginx-user:nginx-user i18n/ /usr/share/nginx/html/i18n/
COPY --chown=nginx-user:nginx-user data/ /usr/share/nginx/html/data/
COPY --chown=nginx-user:nginx-user public/ /usr/share/nginx/html/public/

# Configurar nginx para ejecutar como usuario no-root
RUN sed -i 's/user nginx;/user nginx-user;/' /etc/nginx/nginx.conf && \
    chown -R nginx-user:nginx-user /var/cache/nginx /var/run /var/log/nginx

# Exponer puertos HTTP y HTTPS
EXPOSE 80 443

# Configurar salud del contenedor (HTTPS)
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider --no-check-certificate https://localhost/health || exit 1

# Comando de inicio
CMD ["nginx", "-g", "daemon off;"]
