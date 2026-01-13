@echo off
REM Script to start only the microservices (not infrastructure)

echo =========================================
echo  Starting Backend Microservices Only
echo =========================================
echo.

echo [1] Checking current status...
docker-compose ps
echo.

echo [2] Starting RabbitMQ and Eureka...
docker-compose up -d rabbitmq server-eureka
echo Waiting 20 seconds...
timeout /t 20 /nobreak >nul
echo.

echo [3] Starting microservices...
docker-compose up -d anggota-service buku-service peminjaman-service pengembalian-service api-gateway
echo.

echo [4] Waiting for services to start (60 seconds)...
timeout /t 60 /nobreak >nul
echo.

echo [5] Checking microservices health...
echo.
echo Anggota Service:
curl -s http://localhost:8081/actuator/health
echo.

echo Buku Service:
curl -s http://localhost:8082/actuator/health
echo.

echo Peminjaman Service:
curl -s http://localhost:8083/actuator/health
echo.

echo Pengembalian Service:
curl -s http://localhost:8084/actuator/health
echo.

echo =========================================
echo  Service URLs for Frontend
echo =========================================
echo Anggota:      http://localhost:8081
echo Buku:         http://localhost:8082
echo Peminjaman:   http://localhost:8083
echo Pengembalian: http://localhost:8084
echo API Gateway:  http://localhost:9000
echo =========================================
echo.

echo All services status:
docker-compose ps
echo.

echo =========================================
echo Done! You can now test the frontend.
echo =========================================
pause
