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
```bash
# Construir imagen
docker build -t esteban-portfolio .

# Ejecutar contenedor
docker run --rm -p 8080:80 esteban-portfolio
```

Abrir: http://localhost:8080

## Personalización
- Edita `data/profile.json` con tu información.
- Traducciones en `i18n/es.json` y `i18n/en.json`.
- Estilos en `src/styles.css`.

## Licencia
MIT
