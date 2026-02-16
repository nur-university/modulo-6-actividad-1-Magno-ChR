# API Gateway

API Gateway es un servicio de enrutamiento que proporciona autenticación JWT y redireccionamiento a servicios externos. Cuenta con 3 endpoints principales: login, usuarios y posts.

## 🚀 Inicio Rápido

### Requisitos Previos
- Docker y Docker Compose instalados
- O .NET 8 SDK para ejecución local

### Ejecutar con Docker Compose (Recomendado)

```bash
docker-compose up --build
```

El servicio estará disponible en:
- **HTTP**: `http://localhost:8080`
- **HTTPS**: `https://localhost:8081`
- **Swagger UI**: `http://localhost:8080/swagger`
- **Health Check**: `http://localhost:8080/health`
- **Health Check UI**: `http://localhost:8080/health-ui`

### Ejecutar Localmente

```bash
cd api-gateway
dotnet run
```

El servicio estará disponible en:
- **HTTP**: `https://localhost:5001` o `http://localhost:5000`
- **Swagger UI**: `https://localhost:5001/swagger`

---

## 📋 Endpoints

### 1. POST `/api/login` - Obtener Bearer Token

**Descripción**: Genera un JWT Bearer Token basado en credenciales.

**Autenticación**: No requerida

**Credenciales de Prueba**:
- Usuario: `admin`
- Contraseña: `admin`

**Request**:
```bash
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin"
  }'
```

**Response** (200 OK):
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsIm5hbWUiOiJhZG1pbiIsImlhdCI6MTUxNjIzOTAyMn0.VN3Yx3..."
}
```

**Errores**:
- 401 Unauthorized - Si las credenciales son inválidas

---

### 2. GET `/api/users` - Obtener Lista de Usuarios

**Descripción**: Redirige la solicitud a JSONPlaceholder para obtener una lista de usuarios de prueba.

**Autenticación**: Requerida (Bearer Token)

**Headers**:
```
Authorization: Bearer {token_obtenido_del_login}
```

**Request**:
```bash
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Response** (200 OK):
```json
[
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    ...
  },
  ...
]
```

**Errores**:
- 401 Unauthorized - Si no se proporciona token o es inválido
- 500 Internal Server Error - Si hay error al conectar con JSONPlaceholder

---

### 3. GET `/api/posts` - Obtener Lista de Posts

**Descripción**: Redirige la solicitud a JSONPlaceholder para obtener una lista de posts de prueba.

**Autenticación**: Requerida (Bearer Token)

**Headers**:
```
Authorization: Bearer {token_obtenido_del_login}
```

**Request**:
```bash
curl -X GET http://localhost:8080/api/posts \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Response** (200 OK):
```json
[
  {
    "userId": 1,
    "id": 1,
    "title": "sunt aut facere repellat provident...",
    "body": "quia et suscipit...",
    ...
  },
  ...
]
```

**Errores**:
- 401 Unauthorized - Si no se proporciona token o es inválido
- 500 Internal Server Error - Si hay error al conectar con JSONPlaceholder

---

## 🔐 Autenticación

El API Gateway utiliza JWT (JSON Web Tokens) con Bearer scheme para autenticación.

### Flujo de Autenticación:

1. **Obtener Token**: Llamar a `POST /api/login` con credenciales
2. **Usar Token**: Incluir el token en el header `Authorization` con formato `Bearer {token}`
3. **Validación**: El servidor valida el token y permite acceso a recursos protegidos

### Token JWT:
- **Algoritmo**: HS256
- **Duración**: 60 minutos (configurable)
- **Issuer**: `api-gateway`
- **Audience**: `api-gateway-users`

---

## 🧪 Pruebas con Swagger UI

1. Accede a `http://localhost:8080/swagger`

2. Click en el botón **"Authorize"** (candado 🔒)

3. Obtén un token:
   - Expande `POST /api/login`
   - Click en "Try it out"
   - Ingresa las credenciales:
     ```json
     {
       "username": "admin",
       "password": "admin"
     }
     ```
   - Click en "Execute"
   - Copia el token de la respuesta

4. Autoriza en Swagger:
   - En el dialog de Authorize, pega el token en el campo
   - Click en "Authorize"

5. Prueba los endpoints protegidos:
   - Expande `GET /api/users`
   - Click en "Try it out"
   - Click en "Execute"

---

## 📊 Ejemplos de Flujo Completo

### Bash / cURL

```bash
# 1. Login y obtener token
TOKEN=$(curl -s -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}' | jq -r '.token')

# 2. Obtener usuarios
curl -X GET http://localhost:8080/api/users \
  -H "Authorization: Bearer $TOKEN"

# 3. Obtener posts
curl -X GET http://localhost:8080/api/posts \
  -H "Authorization: Bearer $TOKEN"
```

### PowerShell

```powershell
# 1. Login y obtener token
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/login" `
  -Method Post `
  -ContentType "application/json" `
  -Body '{"username":"admin","password":"admin"}'

$token = $response.token

# 2. Obtener usuarios
Invoke-RestMethod -Uri "http://localhost:8080/api/users" `
  -Method Get `
  -Headers @{"Authorization" = "Bearer $token"}

# 3. Obtener posts
Invoke-RestMethod -Uri "http://localhost:8080/api/posts" `
  -Method Get `
  -Headers @{"Authorization" = "Bearer $token"}
```

### JavaScript / Fetch API

```javascript
// 1. Login y obtener token
async function getToken() {
  const response = await fetch('http://localhost:8080/api/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      username: 'admin',
      password: 'admin'
    })
  });
  const data = await response.json();
  return data.token;
}

// 2. Obtener usuarios
async function getUsers(token) {
  const response = await fetch('http://localhost:8080/api/users', {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  return await response.json();
}

// 3. Obtener posts
async function getPosts(token) {
  const response = await fetch('http://localhost:8080/api/posts', {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  return await response.json();
}

// Uso
(async () => {
  const token = await getToken();
  const users = await getUsers(token);
  const posts = await getPosts(token);
  
  console.log('Users:', users);
  console.log('Posts:', posts);
})();
```

---

## 📝 Configuración

### appsettings.json

```json
{
  "Jwt": {
    "SecretKey": "your-super-secret-key-that-is-at-least-32-characters-long-for-hs256",
    "Issuer": "api-gateway",
    "Audience": "api-gateway-users",
    "ExpirationMinutes": 60
  },
  "ReverseProxy": {
    "Routes": [],
    "Clusters": []
  }
}
```

**Importantes**:
- `SecretKey`: Cambiar en producción (mínimo 32 caracteres)
- `ExpirationMinutes`: Duración del token en minutos
- `Issuer` y `Audience`: Deben coincidir con la configuración en el token

---

## 🐳 Docker

### Construir imagen

```bash
docker build -f api-gateway/Dockerfile -t api-gateway:latest .
```

### Ejecutar contenedor

```bash
docker run -d \
  --name api-gateway \
  -p 8080:8080 \
  -p 8081:8081 \
  api-gateway:latest
```

### Con Docker Compose

```bash
# Iniciar
docker-compose up -d

# Ver logs
docker-compose logs -f api-gateway

# Detener
docker-compose down
```

---

## ⚙️ Health Checks

### Endpoint de Health Check

```bash
curl http://localhost:8080/health
```

**Response** (200 OK):
```json
{
  "status": "Healthy"
}
```

### UI de Health Checks

Accede a `http://localhost:8080/health-ui` para una interfaz gráfica con el estado del servicio.

---

## 🛠️ Estructura del Proyecto

```
api-gateway/
├── Controllers/
│   └── GatewayController.cs       # Endpoints de login, users, posts
├── Services/
│   └── TokenGeneratorService.cs   # Servicio para generar JWT
├── Extensions/
│   ├── ApplicationBuilderExtensions.cs
│   ├── SecurityExtensions.cs
│   ├── ObservabilityExtensions.cs
│   └── SecretExtensions.cs
├── Access/
│   ├── AdvancedScopeAuthorizationMiddleware.cs
│   └── ScopeRouteMatcher.cs
├── Config/
│   └── ConsulYarpConfigProvider.cs
├── BearerAuthenticationHandler.cs  # Handler de autenticación Bearer
├── DependencyInjection.cs          # Configuración de servicios
├── Program.cs                      # Punto de entrada
├── appsettings.json                # Configuración
├── Dockerfile                      # Para Docker
└── api-gateway.csproj             # Archivo de proyecto

docker-compose.yml                 # Orquestación de contenedores
README.md                           # Este archivo
```

---

## 📚 Tecnologías

- **.NET 8** - Framework
- **ASP.NET Core** - Web framework
- **JWT (HS256)** - Autenticación
- **YARP** - Reverse Proxy
- **Swagger/OpenAPI** - Documentación interactiva
- **Docker** - Containerización
- **Docker Compose** - Orquestación

---

## 🔧 Troubleshooting

### El token ha expirado
**Error**: `401 Unauthorized - Token validation failed: The token is expired`

**Solución**: Obtén un nuevo token llamando nuevamente a `POST /api/login`

### Credenciales inválidas
**Error**: `401 Unauthorized - Credenciales inválidas`

**Solución**: Verifica que uses:
- Usuario: `admin`
- Contraseña: `admin`

### No se puede conectar a JSONPlaceholder
**Error**: `500 Internal Server Error - Error al obtener usuarios`

**Solución**: Verifica que tengas conexión a Internet y que `https://jsonplaceholder.typicode.com` sea accesible

### Puerto 8080 en uso
**Error**: `docker: Error response from daemon: Ports are not available`

**Solución**: Cambia el puerto en `docker-compose.yml`:
```yaml
ports:
  - "8090:8080"  # Usar puerto 8090 en lugar de 8080
```

---

## 📞 Soporte

Para reportar problemas o sugerencias, contacta al equipo de desarrollo.

---

## 📄 Licencia

Este proyecto es propiedad del equipo de desarrollo.
