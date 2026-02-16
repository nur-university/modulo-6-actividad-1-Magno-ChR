# 🚀 Quick Start Guide

## Opción 1: Docker Compose (Recomendado)

```bash
# Clonar o descargar el proyecto
git clone <tu-repositorio>
cd api-gateway

# Ejecutar con Docker Compose
docker-compose up --build

# El servicio estará disponible en:
# http://localhost:8080
```

## Opción 2: Ejecución Local

```bash
# Clonar o descargar el proyecto
git clone <tu-repositorio>
cd api-gateway

# Restaurar dependencias
dotnet restore

# Ejecutar la aplicación
dotnet run

# El servicio estará disponible en:
# https://localhost:5001 o http://localhost:5000
```

---

## 📍 Acceso Inmediato

Una vez ejecutado, accede a:

- **Swagger UI**: http://localhost:8080/swagger
- **Health Check**: http://localhost:8080/health
- **Health Check UI**: http://localhost:8080/health-ui

---

## 🔑 Credenciales de Prueba

```
Usuario: admin
Contraseña: admin
```

---

## 🧪 Prueba Rápida (cURL)

### 1. Obtener Token
```bash
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}'
```

Respuesta:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 2. Usar el Token para Obtener Usuarios
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### 3. Usar el Token para Obtener Posts
```bash
curl -X GET http://localhost:8080/api/posts \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## 🎯 Flujo en Swagger UI

1. Abre http://localhost:8080/swagger
2. Click en **POST /api/login**
3. Click en **"Try it out"**
4. Ingresa:
   ```json
   {
     "username": "admin",
     "password": "admin"
   }
   ```
5. Click en **"Execute"**
6. Copia el token de la respuesta
7. Click en el botón **"Authorize"** (candado 🔒) en la parte superior
8. Pega el token
9. Click en **"Authorize"**
10. Ahora puedes probar **GET /api/users** y **GET /api/posts**

---

## 🐳 Detener Docker Compose

```bash
docker-compose down
```

---

## 📚 Documentación Completa

Ver `README.md` para documentación completa de endpoints, configuración y ejemplos avanzados.

---

## ✅ Verificación Rápida

Después de ejecutar, verifica que todo funciona:

```bash
# Verificar que el servicio está en línea
curl http://localhost:8080/health

# Debería devolver:
# {"status":"Healthy"}
```

---

¡Listo! El API Gateway está funcionando y listo para usar. 🎉
