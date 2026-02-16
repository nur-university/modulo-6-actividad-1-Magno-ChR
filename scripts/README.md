# Scripts de Ayuda

Este directorio contiene scripts para facilitar la gestión del API Gateway.

## 🐧 Linux / macOS - api-gateway.sh

### Dar permisos de ejecución

```bash
chmod +x scripts/api-gateway.sh
```

### Usar el script

```bash
./scripts/api-gateway.sh [comando]
```

### Comandos disponibles

#### `start`
Inicia el API Gateway con Docker Compose
```bash
./scripts/api-gateway.sh start
```

#### `stop`
Detiene el API Gateway
```bash
./scripts/api-gateway.sh stop
```

#### `restart`
Reinicia el API Gateway
```bash
./scripts/api-gateway.sh restart
```

#### `logs`
Muestra los logs en tiempo real
```bash
./scripts/api-gateway.sh logs
```

#### `status`
Muestra el estado de los contenedores
```bash
./scripts/api-gateway.sh status
```

#### `test`
Prueba todos los endpoints automáticamente
```bash
./scripts/api-gateway.sh test
```

Realiza pruebas sobre:
- Health Check del servicio
- Endpoint POST /api/login
- Endpoint GET /api/users (con token)
- Endpoint GET /api/posts (con token)

#### `rebuild`
Reconstruye la imagen de Docker e inicia el servicio
```bash
./scripts/api-gateway.sh rebuild
```

#### `clean`
Limpia contenedores y volúmenes
```bash
./scripts/api-gateway.sh clean
```

---

## 🪟 Windows - api-gateway.ps1

### Ejecutar el script

```powershell
.\scripts\api-gateway.ps1 [comando]
```

### Nota sobre permisos de ejecución

Si obtienes un error de permisos, ejecuta primero:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Comandos disponibles

Los mismos comandos que en el script de Bash funcionan en PowerShell:

```powershell
.\scripts\api-gateway.ps1 start
.\scripts\api-gateway.ps1 stop
.\scripts\api-gateway.ps1 restart
.\scripts\api-gateway.ps1 logs
.\scripts\api-gateway.ps1 status
.\scripts\api-gateway.ps1 test
.\scripts\api-gateway.ps1 rebuild
.\scripts\api-gateway.ps1 clean
```

---

## 📊 Ejemplo de Uso Completo

### Linux/macOS

```bash
# 1. Dar permisos
chmod +x scripts/api-gateway.sh

# 2. Iniciar el servicio
./scripts/api-gateway.sh start

# 3. Esperar a que esté listo
sleep 5

# 4. Probar los endpoints
./scripts/api-gateway.sh test

# 5. Ver logs
./scripts/api-gateway.sh logs

# 6. Detener cuando termines
./scripts/api-gateway.sh stop
```

### Windows

```powershell
# 1. Permitir ejecución de scripts (una sola vez)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. Iniciar el servicio
.\scripts\api-gateway.ps1 start

# 3. Esperar a que esté listo
Start-Sleep -Seconds 5

# 4. Probar los endpoints
.\scripts\api-gateway.ps1 test

# 5. Ver logs
.\scripts\api-gateway.ps1 logs

# 6. Detener cuando termines
.\scripts\api-gateway.ps1 stop
```

---

## 🎯 Flujo Típico de Desarrollo

```bash
# Terminal 1: Inicia el servicio y muestra logs
./scripts/api-gateway.sh start
./scripts/api-gateway.sh logs

# Terminal 2: Prueba los endpoints
./scripts/api-gateway.sh test

# Terminal 3: Haz cambios en el código y reinicia
./scripts/api-gateway.sh rebuild
```

---

## 🔍 Qué hace el comando `test`

El comando `test` automatiza las siguientes pruebas:

1. **Health Check**: Verifica que el servicio esté en línea
2. **Login**: Obtiene un token JWT con las credenciales `admin/admin`
3. **GET /api/users**: Obtiene la lista de usuarios usando el token
4. **GET /api/posts**: Obtiene la lista de posts usando el token

Si todas las pruebas pasan, el servicio está completamente funcional.

---

## 🐛 Troubleshooting

### El script no se ejecuta (Linux/macOS)

Verifica que tiene permisos:
```bash
ls -la scripts/api-gateway.sh
# Si ves "x", está bien. Si no, ejecuta:
chmod +x scripts/api-gateway.sh
```

### El script no se ejecuta (Windows)

Verifica la política de ejecución:
```powershell
Get-ExecutionPolicy
# Si dice "Restricted", ejecuta:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error de conexión en `test`

Asegúrate de que el servicio está en ejecución:
```bash
./scripts/api-gateway.sh status
```

Si no está corriendo, inicia con:
```bash
./scripts/api-gateway.sh start
```

---

## 📝 Notas

- Los scripts requieren que Docker y Docker Compose estén instalados
- El comando `test` requiere que `curl` (Linux/macOS) o PowerShell (Windows) estén disponibles
- Los logs se pueden ver en tiempo real con el comando `logs`
- El servicio tarda unos segundos en estar completamente listo después de iniciar
