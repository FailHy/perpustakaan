#!/bin/bash
# Script to start only the microservices (not infrastructure)

echo "========================================="
echo " Starting Backend Microservices Only"
echo "========================================="
echo ""

echo "[1] Checking if infrastructure is running..."
docker ps --filter "name=rabbitmq" --format "{{.Names}}: {{.Status}}"
docker ps --filter "name=server-eureka" --format "{{.Names}}: {{.Status}}"
echo ""

echo "[2] Starting RabbitMQ and Eureka if not running..."
docker-compose up -d rabbitmq server-eureka
sleep 20
echo ""

echo "[3] Starting microservices..."
docker-compose up -d anggota-service buku-service peminjaman-service pengembalian-service api-gateway
echo ""

echo "[4] Waiting for services to start (60 seconds)..."
sleep 60
echo ""

echo "[5] Checking microservices status..."
echo ""
echo "Checking Anggota Service..."
curl -s http://localhost:8081/actuator/health | grep -o '"status":"[^"]*"' || echo "NOT READY"

echo "Checking Buku Service..."
curl -s http://localhost:8082/actuator/health | grep -o '"status":"[^"]*"' || echo "NOT READY"

echo "Checking Peminjaman Service..."
curl -s http://localhost:8083/actuator/health | grep -o '"status":"[^"]*"' || echo "NOT READY"

echo "Checking Pengembalian Service..."
curl -s http://localhost:8084/actuator/health | grep -o '"status":"[^"]*"' || echo "NOT READY"
echo ""

echo "========================================="
echo " Service URLs for Frontend"
echo "========================================="
echo "Anggota:      http://localhost:8081"
echo "Buku:         http://localhost:8082"
echo "Peminjaman:   http://localhost:8083"
echo "Pengembalian: http://localhost:8084"
echo "API Gateway:  http://localhost:9000"
echo "========================================="
echo ""

echo "All services status:"
docker-compose ps
