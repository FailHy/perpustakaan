#!/bin/bash
# Complete build and start script for microservices

set -e  # Exit on error

echo "========================================="
echo " Building and Starting All Microservices"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to build a service
build_service() {
    local service_name=$1
    echo -e "${YELLOW}[Building ${service_name}]${NC}"
    
    if [ -d "${service_name}" ]; then
        cd "${service_name}"
        
        # Build with Maven
        if [ -f "pom.xml" ]; then
            echo "Running Maven build..."
            ./mvnw clean package -DskipTests || mvn clean package -DskipTests
            
            # Check if JAR was created
            if [ -f "target/*.jar" ]; then
                echo -e "${GREEN}✓ ${service_name} built successfully${NC}"
            else
                echo -e "${RED}✗ ${service_name} build failed - no JAR found${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}⚠ No pom.xml found for ${service_name}${NC}"
        fi
        
        cd ..
    else
        echo -e "${RED}✗ ${service_name} directory not found${NC}"
        return 1
    fi
    echo ""
}

echo "[Step 1/5] Checking prerequisites..."
echo "Checking Java..."
java -version || { echo -e "${RED}Java not found! Please install Java 17+${NC}"; exit 1; }
echo ""
echo "Checking Maven..."
mvn -version || echo -e "${YELLOW}Maven not in PATH, will use mvnw${NC}"
echo ""
echo "Checking Docker..."
docker --version || { echo -e "${RED}Docker not found!${NC}"; exit 1; }
echo ""
echo "Checking Docker Compose..."
docker-compose --version || { echo -e "${RED}Docker Compose not found!${NC}"; exit 1; }
echo ""

echo "[Step 2/5] Building Java microservices with Maven..."
echo "This will take several minutes..."
echo ""

# Build each service
build_service "anggota"
build_service "buku"
build_service "peminjaman"
build_service "pengembalian"
build_service "api-gateway"
build_service "eureka-server"

echo -e "${GREEN}All services built successfully!${NC}"
echo ""

echo "[Step 3/5] Cleaning up old containers..."
# Stop and remove old RabbitMQ if exists
docker stop my-rabbitmq 2>/dev/null || true
docker rm my-rabbitmq 2>/dev/null || true

# Clean up docker-compose containers
docker-compose down -v
echo ""

echo "[Step 4/5] Building Docker images..."
docker-compose build
echo ""

echo "[Step 5/5] Starting all services with Docker Compose..."
docker-compose up -d
echo ""

echo "Waiting for services to start (60 seconds)..."
sleep 60
echo ""

echo "========================================="
echo " Service Status"
echo "========================================="
docker-compose ps
echo ""

echo "========================================="
echo " Access URLs"
echo "========================================="
echo "Infrastructure:"
echo "  - Eureka Server:    http://localhost:8761"
echo "  - RabbitMQ UI:      http://localhost:15672 (admin/password)"
echo "  - Kibana:           http://localhost:5601"
echo "  - Prometheus:       http://localhost:9090"
echo "  - Grafana:          http://localhost:3000 (admin/admin)"
echo ""
echo "Microservices:"
echo "  - Anggota Service:      http://localhost:8081/actuator/health"
echo "  - Buku Service:         http://localhost:8082/actuator/health"
echo "  - Peminjaman Service:   http://localhost:8083/actuator/health"
echo "  - Pengembalian Service: http://localhost:8084/actuator/health"
echo "  - API Gateway:          http://localhost:9000"
echo ""
echo "========================================="
echo ""

echo "To view logs: docker-compose logs -f [service-name]"
echo "To stop all:  docker-compose down"
echo ""
echo -e "${GREEN}Setup complete!${NC}"
