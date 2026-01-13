@echo off
REM Complete build and start script for microservices (Windows)
setlocal enabledelayedexpansion

echo =========================================
echo  Building and Starting All Microservices
echo =========================================
echo.

REM Check prerequisites
echo [Step 1/5] Checking prerequisites...
java -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java not found! Please install Java 17+
    pause
    exit /b 1
)
echo Java: OK

docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker not found!
    pause
    exit /b 1
)
echo Docker: OK

docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker Compose not found!
    pause
    exit /b 1
)
echo Docker Compose: OK
echo.

echo [Step 2/5] Building Java microservices with Maven...
echo This will take several minutes...
echo.

REM Build each service
call :build_service anggota
call :build_service buku
call :build_service peminjaman
call :build_service pengembalian
call :build_service api-gateway
call :build_service eureka-server

echo.
echo All services built successfully!
echo.

echo [Step 3/5] Cleaning up old containers...
docker stop my-rabbitmq 2>nul
docker rm my-rabbitmq 2>nul
docker-compose down -v
echo.

echo [Step 4/5] Building Docker images...
docker-compose build
if errorlevel 1 (
    echo ERROR: Docker build failed!
    pause
    exit /b 1
)
echo.

echo [Step 5/5] Starting all services with Docker Compose...
docker-compose up -d
if errorlevel 1 (
    echo ERROR: Docker Compose up failed!
    pause
    exit /b 1
)
echo.

echo Waiting for services to start (60 seconds)...
timeout /t 60 /nobreak >nul
echo.

echo =========================================
echo  Service Status
echo =========================================
docker-compose ps
echo.

echo =========================================
echo  Access URLs
echo =========================================
echo Infrastructure:
echo   - Eureka Server:    http://localhost:8761
echo   - RabbitMQ UI:      http://localhost:15672 (admin/password)
echo   - Kibana:           http://localhost:5601
echo   - Prometheus:       http://localhost:9090
echo   - Grafana:          http://localhost:3000 (admin/admin)
echo.
echo Microservices:
echo   - Anggota Service:      http://localhost:8081/actuator/health
echo   - Buku Service:         http://localhost:8082/actuator/health
echo   - Peminjaman Service:   http://localhost:8083/actuator/health
echo   - Pengembalian Service: http://localhost:8084/actuator/health
echo   - API Gateway:          http://localhost:9000
echo.
echo =========================================
echo.
echo To view logs: docker-compose logs -f [service-name]
echo To stop all:  docker-compose down
echo.
echo Setup complete!
pause
exit /b 0

REM Function to build a service
:build_service
set SERVICE_NAME=%1
echo.
echo [Building %SERVICE_NAME%]
if not exist "%SERVICE_NAME%" (
    echo ERROR: %SERVICE_NAME% directory not found!
    exit /b 1
)

cd "%SERVICE_NAME%"

if not exist "pom.xml" (
    echo Warning: No pom.xml found for %SERVICE_NAME%
    cd ..
    exit /b 0
)

echo Running Maven build...
if exist "mvnw.cmd" (
    call mvnw.cmd clean package -DskipTests
) else (
    call mvn clean package -DskipTests
)

if errorlevel 1 (
    echo ERROR: %SERVICE_NAME% build failed!
    cd ..
    pause
    exit /b 1
)

if not exist "target\*.jar" (
    echo ERROR: No JAR file created for %SERVICE_NAME%
    cd ..
    pause
    exit /b 1
)

echo Success: %SERVICE_NAME% built successfully
cd ..
exit /b 0
