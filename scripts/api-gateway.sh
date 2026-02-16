#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}   API Gateway Helper Script${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}\n"

case "$1" in
  start)
    echo -e "${YELLOW}Iniciando API Gateway con Docker Compose...${NC}"
    docker-compose up -d
    echo -e "${GREEN}✓ API Gateway iniciado${NC}"
    echo -e "\nAccesible en:"
    echo -e "  • Swagger UI: ${GREEN}http://localhost:8080/swagger${NC}"
    echo -e "  • Health Check: ${GREEN}http://localhost:8080/health${NC}"
    echo -e "  • Health Check UI: ${GREEN}http://localhost:8080/health-ui${NC}"
    ;;

  stop)
    echo -e "${YELLOW}Deteniendo API Gateway...${NC}"
    docker-compose down
    echo -e "${GREEN}✓ API Gateway detenido${NC}"
    ;;

  restart)
    echo -e "${YELLOW}Reiniciando API Gateway...${NC}"
    docker-compose restart
    echo -e "${GREEN}✓ API Gateway reiniciado${NC}"
    ;;

  logs)
    echo -e "${YELLOW}Mostrando logs de API Gateway...${NC}"
    docker-compose logs -f api-gateway
    ;;

  status)
    echo -e "${YELLOW}Estado de API Gateway...${NC}"
    docker-compose ps
    ;;

  test)
    echo -e "${YELLOW}Probando API Gateway...${NC}"
    
    # Test health check
    echo -e "\n${YELLOW}1. Probando Health Check...${NC}"
    HEALTH=$(curl -s http://localhost:8080/health)
    echo -e "   Respuesta: ${GREEN}$HEALTH${NC}"
    
    # Test login
    echo -e "\n${YELLOW}2. Probando Login...${NC}"
    TOKEN=$(curl -s -X POST http://localhost:8080/api/login \
      -H "Content-Type: application/json" \
      -d '{"username":"admin","password":"admin"}' | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    
    if [ -z "$TOKEN" ]; then
      echo -e "   ${RED}✗ Error en el login${NC}"
      exit 1
    else
      echo -e "   ${GREEN}✓ Token obtenido${NC}"
      echo -e "   Token: ${YELLOW}${TOKEN:0:30}...${NC}"
    fi
    
    # Test users endpoint
    echo -e "\n${YELLOW}3. Probando GET /api/users...${NC}"
    USERS_COUNT=$(curl -s -X GET http://localhost:8080/api/users \
      -H "Authorization: Bearer $TOKEN" | grep -o '"id"' | wc -l)
    echo -e "   ${GREEN}✓ Se obtuvieron $USERS_COUNT usuarios${NC}"
    
    # Test posts endpoint
    echo -e "\n${YELLOW}4. Probando GET /api/posts...${NC}"
    POSTS_COUNT=$(curl -s -X GET http://localhost:8080/api/posts \
      -H "Authorization: Bearer $TOKEN" | grep -o '"id"' | wc -l)
    echo -e "   ${GREEN}✓ Se obtuvieron $POSTS_COUNT posts${NC}"
    
    echo -e "\n${GREEN}✓ Todas las pruebas pasaron correctamente${NC}"
    ;;

  rebuild)
    echo -e "${YELLOW}Reconstruyendo imagen de Docker...${NC}"
    docker-compose down
    docker-compose up -d --build
    echo -e "${GREEN}✓ Imagen reconstruida e iniciada${NC}"
    ;;

  clean)
    echo -e "${YELLOW}Limpiando contenedores y volúmenes...${NC}"
    docker-compose down -v
    echo -e "${GREEN}✓ Limpieza completada${NC}"
    ;;

  *)
    echo -e "${YELLOW}Uso: $0 {start|stop|restart|logs|status|test|rebuild|clean}${NC}\n"
    echo "Comandos disponibles:"
    echo -e "  ${GREEN}start${NC}      - Iniciar API Gateway"
    echo -e "  ${GREEN}stop${NC}       - Detener API Gateway"
    echo -e "  ${GREEN}restart${NC}    - Reiniciar API Gateway"
    echo -e "  ${GREEN}logs${NC}       - Ver logs de API Gateway"
    echo -e "  ${GREEN}status${NC}     - Ver estado de API Gateway"
    echo -e "  ${GREEN}test${NC}       - Probar endpoints del API"
    echo -e "  ${GREEN}rebuild${NC}    - Reconstruir imagen de Docker"
    echo -e "  ${GREEN}clean${NC}      - Limpiar contenedores y volúmenes"
    echo ""
    ;;
esac
