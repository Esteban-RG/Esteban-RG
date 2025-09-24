#!/bin/bash

# Script de despliegue HTTPS para Manjaro Linux
# Autor: Esteban Reyes

set -e

# Configuración
IMAGE_NAME="esteban-portfolio-https"
CONTAINER_NAME="esteban-cv-https"
HTTP_PORT="80"
HTTPS_PORT="443"
SSL_DIR="ssl"

echo "🔐 Iniciando despliegue..."

# Verificar que Docker esté instalado y ejecutándose
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Instálalo con:"
    echo "sudo pacman -S docker"
    echo "sudo systemctl enable --now docker"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker no está ejecutándose. Inicia el servicio:"
    echo "sudo systemctl start docker"
    exit 1
fi

# Verificar que Docker Compose esté instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Instálalo con:"
    echo "sudo pacman -S docker-compose"
    exit 1
fi



# Detener y eliminar contenedor existente si existe
if docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "🛑 Deteniendo contenedor existente..."
    docker stop ${CONTAINER_NAME} || true
    docker rm ${CONTAINER_NAME} || true
fi

# Usar Docker Compose para el despliegue
echo "🔨 Construyendo y ejecutando con Docker Compose..."
docker-compose down || true
docker-compose up --build -d

# Verificar que el contenedor esté ejecutándose
echo "⏳ Esperando que el contenedor esté listo..."
sleep 5

if docker-compose ps | grep -q "Up"; then
    echo "✅ ¡Despliegue HTTPS exitoso!"
    echo ""
    echo "🌐 Tu contenedor está disponible en:"
    echo "   🔒 HTTPS: https://localhost (puerto ${HTTPS_PORT})"
    echo "   🔄 HTTP: http://localhost (puerto ${HTTP_PORT}) - redirige a HTTPS"
    echo ""
    echo "📊 Estado del contenedor:"
    docker-compose ps
    
    echo ""
    echo "📝 Comandos útiles:"
    echo "  Ver logs: docker-compose logs -f"
    echo "  Detener: docker-compose down"
    echo "  Reiniciar: docker-compose restart"
    echo "  Estado: docker-compose ps"
    
    echo ""
    echo "⚠️  NOTA: Si usas certificados autofirmados, el navegador mostrará una advertencia."
    echo "   Haz clic en 'Avanzado' y luego 'Continuar a localhost' para continuar."
else
    echo "❌ Error al ejecutar el contenedor. Revisa los logs:"
    docker-compose logs
    exit 1
fi
