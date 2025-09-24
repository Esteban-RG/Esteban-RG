# Portafolio de Esteban Reyes

Sitio estático multilenguaje (ES/EN) para presentar CV/portafolio. Se sirve con Nginx en Docker.

## Estructura
- `public/`: assets estáticos servidos por Nginx
- `src/`: HTML/CSS/JS del sitio
- `i18n/`: traducciones `es.json` y `en.json`
- `data/profile.json`: datos del CV consumidos por el frontend
- `Dockerfile` y `nginx.conf`: imagen y configuración del servidor

## Desarrollo local
Puedes abrir `src/index.html` directamente en el navegador.

## Construir y ejecutar con Docker

### Método rápido (recomendado para Manjaro)

#### Despliegue HTTP (puerto 8080)
```bash
./deploy.sh
```

#### Despliegue HTTPS (puertos 80 y 443)
```bash
./deploy.sh --https
# o usar el script dedicado:
./deploy-https.sh
```

### Método manual

#### HTTP simple
```bash
docker build -t esteban-portfolio .
docker run --rm -p 8080:80 esteban-portfolio
```

#### HTTPS con Docker Compose
```bash
# Generar certificados SSL (primera vez)
./generate-ssl.sh

# Desplegar con HTTPS
docker-compose up --build -d
```

### Configuración para Manjaro Linux
El Dockerfile está optimizado para Manjaro con:
- Zona horaria configurada a México
- Usuario no-root para mayor seguridad
- Healthcheck integrado
- Permisos optimizados
- **Soporte completo para HTTPS con SSL/TLS**

### URLs de acceso:
- **HTTP**: http://localhost:8080
- **HTTPS**: https://localhost (puerto 443)
- **HTTP con redirección**: http://localhost (puerto 80) → redirige a HTTPS

## Configuración HTTPS

### Características de seguridad:
- **SSL/TLS moderno**: TLSv1.2 y TLSv1.3
- **Cifrados seguros**: ECDHE y AES256-GCM
- **Headers de seguridad**: HSTS, XSS Protection, Content Security Policy
- **Redirección automática**: HTTP → HTTPS
- **Certificados autofirmados** para desarrollo local

### Para producción con Let's Encrypt:
```bash
# Reemplaza los certificados autofirmados con certificados reales
# Copia tus certificados a la carpeta ssl/
cp /path/to/your/cert.pem ssl/cert.pem
cp /path/to/your/private.key ssl/key.pem

# Reinicia el contenedor
docker-compose restart
```

### Archivos de configuración HTTPS:
- `nginx.conf`: Configuración SSL/TLS y headers de seguridad
- `docker-compose.yml`: Orquestación con puertos 80 y 443
- `generate-ssl.sh`: Generación de certificados autofirmados
- `deploy-https.sh`: Script de despliegue HTTPS

## Personalización
- Edita `data/profile.json` con tu información.
- Traducciones en `i18n/es.json` y `i18n/en.json`.
- Estilos en `src/styles.css`.

## Licencia
MIT
