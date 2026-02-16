#!/usr/bin/env pwsh

# Colors for output
$Green = @{ForegroundColor = 'Green'}
$Yellow = @{ForegroundColor = 'Yellow'}
$Red = @{ForegroundColor = 'Red'}

Write-Host "═══════════════════════════════════════" @Green
Write-Host "   API Gateway Helper Script" @Green
Write-Host "═══════════════════════════════════════" @Green
Write-Host ""

$command = $args[0]

switch ($command) {
    "start" {
        Write-Host "Iniciando API Gateway con Docker Compose..." @Yellow
        docker-compose up -d
        Write-Host "✓ API Gateway iniciado" @Green
        Write-Host ""
        Write-Host "Accesible en:" @Yellow
        Write-Host "  • Swagger UI: http://localhost:8080/swagger" @Green
        Write-Host "  • Health Check: http://localhost:8080/health" @Green
        Write-Host "  • Health Check UI: http://localhost:8080/health-ui" @Green
    }
    "stop" {
        Write-Host "Deteniendo API Gateway..." @Yellow
        docker-compose down
        Write-Host "✓ API Gateway detenido" @Green
    }
    "restart" {
        Write-Host "Reiniciando API Gateway..." @Yellow
        docker-compose restart
        Write-Host "✓ API Gateway reiniciado" @Green
    }
    "logs" {
        Write-Host "Mostrando logs de API Gateway..." @Yellow
        docker-compose logs -f api-gateway
    }
    "status" {
        Write-Host "Estado de API Gateway..." @Yellow
        docker-compose ps
    }
    "test" {
        Write-Host "Probando API Gateway..." @Yellow
        
        # Test health check
        Write-Host ""
        Write-Host "1. Probando Health Check..." @Yellow
        try {
            $health = Invoke-RestMethod -Uri "http://localhost:8080/health" -Method Get -ErrorAction Stop
            Write-Host "   Respuesta: $($health.status)" @Green
        } catch {
            Write-Host "   Error al conectar con health check" @Red
            exit 1
        }
        
        # Test login
        Write-Host ""
        Write-Host "2. Probando Login..." @Yellow
        try {
            $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/login" `
                -Method Post `
                -ContentType "application/json" `
                -Body '{"username":"admin","password":"admin"}' `
                -ErrorAction Stop
            $token = $loginResponse.token
            Write-Host "✓ Token obtenido" @Green
            Write-Host "   Token: $($token.Substring(0, 30))..." @Yellow
        } catch {
            Write-Host "✗ Error en el login" @Red
            exit 1
        }
        
        # Test users endpoint
        Write-Host ""
        Write-Host "3. Probando GET /api/users..." @Yellow
        try {
            $users = Invoke-RestMethod -Uri "http://localhost:8080/api/users" `
                -Method Get `
                -Headers @{"Authorization" = "Bearer $token"} `
                -ErrorAction Stop
            Write-Host "✓ Se obtuvieron $($users.Count) usuarios" @Green
        } catch {
            Write-Host "✗ Error al obtener usuarios" @Red
            exit 1
        }
        
        # Test posts endpoint
        Write-Host ""
        Write-Host "4. Probando GET /api/posts..." @Yellow
        try {
            $posts = Invoke-RestMethod -Uri "http://localhost:8080/api/posts" `
                -Method Get `
                -Headers @{"Authorization" = "Bearer $token"} `
                -ErrorAction Stop
            Write-Host "✓ Se obtuvieron $($posts.Count) posts" @Green
        } catch {
            Write-Host "✗ Error al obtener posts" @Red
            exit 1
        }
        
        Write-Host ""
        Write-Host "✓ Todas las pruebas pasaron correctamente" @Green
    }
    "rebuild" {
        Write-Host "Reconstruyendo imagen de Docker..." @Yellow
        docker-compose down
        docker-compose up -d --build
        Write-Host "✓ Imagen reconstruida e iniciada" @Green
    }
    "clean" {
        Write-Host "Limpiando contenedores y volúmenes..." @Yellow
        docker-compose down -v
        Write-Host "✓ Limpieza completada" @Green
    }
    default {
        Write-Host "Uso: .\api-gateway.ps1 {start|stop|restart|logs|status|test|rebuild|clean}" @Yellow
        Write-Host ""
        Write-Host "Comandos disponibles:"
        Write-Host "  start      - Iniciar API Gateway" @Green
        Write-Host "  stop       - Detener API Gateway" @Green
        Write-Host "  restart    - Reiniciar API Gateway" @Green
        Write-Host "  logs       - Ver logs de API Gateway" @Green
        Write-Host "  status     - Ver estado de API Gateway" @Green
        Write-Host "  test       - Probar endpoints del API" @Green
        Write-Host "  rebuild    - Reconstruir imagen de Docker" @Green
        Write-Host "  clean      - Limpiar contenedores y volúmenes" @Green
        Write-Host ""
    }
}
