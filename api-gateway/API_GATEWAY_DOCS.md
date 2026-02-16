# API Gateway - Documentación

Este API Gateway incluye los siguientes endpoints:

## 1. POST /api/login
**Autenticación:** NO REQUERIDA

Genera un Bearer Token basado en credenciales.

### Credenciales (mockeadas):
- Usuario: `admin`
- Contraseña: `admin`

### Request:
```json
{
  "username": "admin",
  "password": "admin"
}
```

### Response (200 OK):
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## 2. GET /api/users
**Autenticación:** REQUERIDA (Bearer Token)

Redirige la solicitud a `https://jsonplaceholder.typicode.com/users`

### Headers:
```
Authorization: Bearer {token}
```

### Response (200 OK):
Retorna la lista de usuarios en JSON desde JSONPlaceholder.

---

## 3. GET /api/posts
**Autenticación:** REQUERIDA (Bearer Token)

Redirige la solicitud a `https://jsonplaceholder.typicode.com/posts`

### Headers:
```
Authorization: Bearer {token}
```

### Response (200 OK):
Retorna la lista de posts en JSON desde JSONPlaceholder.

---

## Configuración JWT

La configuración del JWT se encuentra en `appsettings.json`:

```json
{
  "Jwt": {
    "SecretKey": "your-super-secret-key-that-is-at-least-32-characters-long-for-hs256",
    "Issuer": "api-gateway",
    "Audience": "api-gateway-users",
    "ExpirationMinutes": 60
  }
}
```

## Ejemplo de flujo completo:

1. **Login:**
```bash
curl -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}'
```

2. **Usar token para acceder a usuarios:**
```bash
curl -X GET http://localhost:5000/api/users \
  -H "Authorization: Bearer {token_from_login}"
```

3. **Usar token para acceder a posts:**
```bash
curl -X GET http://localhost:5000/api/posts \
  -H "Authorization: Bearer {token_from_login}"
```
