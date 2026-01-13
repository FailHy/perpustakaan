@echo off
echo ========================================
echo   Checking Docker Services Status
echo ========================================
echo.

echo [1] Checking if Docker is running...
docker version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running! Please start Docker Desktop.
    pause
    exit /b 1
)
echo OK: Docker is running
echo.

echo [2] Checking container status...
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo [3] Checking Kibana...
docker inspect kibana >nul 2>&1
if errorlevel 1 (
    echo WARNING: Kibana container does not exist!
    echo Run: docker-compose up -d
) else (
    for /f "tokens=*" %%i in ('docker inspect kibana --format "{{.State.Status}}"') do set KIBANA_STATUS=%%i
    echo Kibana Status: %KIBANA_STATUS%
    
    if "%KIBANA_STATUS%"=="running" (
        for /f "tokens=*" %%i in ('docker inspect kibana --format "{{.State.Health.Status}}"') do set KIBANA_HEALTH=%%i
        echo Kibana Health: %KIBANA_HEALTH%
        echo Kibana URL: http://localhost:5601
    )
)
echo.

echo [4] Checking Prometheus...
docker inspect prometheus >nul 2>&1
if errorlevel 1 (
    echo WARNING: Prometheus container does not exist!
    echo Run: docker-compose up -d
) else (
    for /f "tokens=*" %%i in ('docker inspect prometheus --format "{{.State.Status}}"') do set PROM_STATUS=%%i
    echo Prometheus Status: %PROM_STATUS%
    
    if "%PROM_STATUS%"=="running" (
        for /f "tokens=*" %%i in ('docker inspect prometheus --format "{{.State.Health.Status}}"') do set PROM_HEALTH=%%i
        echo Prometheus Health: %PROM_HEALTH%
        echo Prometheus URL: http://localhost:9090
    )
)
echo.

echo [5] Checking Elasticsearch (required for Kibana)...
docker inspect elasticsearch >nul 2>&1
if errorlevel 1 (
    echo WARNING: Elasticsearch container does not exist!
) else (
    for /f "tokens=*" %%i in ('docker inspect elasticsearch --format "{{.State.Status}}"') do set ES_STATUS=%%i
    echo Elasticsearch Status: %ES_STATUS%
    
    if "%ES_STATUS%"=="running" (
        for /f "tokens=*" %%i in ('docker inspect elasticsearch --format "{{.State.Health.Status}}"') do set ES_HEALTH=%%i
        echo Elasticsearch Health: %ES_HEALTH%
    )
)
echo.

echo [6] Checking port usage...
echo Checking port 5601 (Kibana):
netstat -ano | findstr ":5601" | findstr "LISTENING"
echo.
echo Checking port 9090 (Prometheus):
netstat -ano | findstr ":9090" | findstr "LISTENING"
echo.

echo ========================================
echo   Quick Actions
echo ========================================
echo 1. View Kibana logs:      docker logs kibana --tail 50
echo 2. View Prometheus logs:  docker logs prometheus --tail 50
echo 3. Restart services:      docker-compose restart kibana prometheus
echo 4. Start all services:    docker-compose up -d
echo 5. Stop all services:     docker-compose down
echo ========================================
echo.

pause
