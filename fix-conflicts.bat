@echo off
echo ========================================
echo  Fixing Container Name Conflicts
echo ========================================
echo.

echo [Step 1] Removing conflicting containers...
echo Removing RabbitMQ container...
docker rm -f 849eace2fc980f887e0b06294ccb37fa585e0211c9cfadb5f1fec56bd982394e 2>nul
if errorlevel 1 (
    echo Container might already be removed or ID changed
) else (
    echo RabbitMQ container removed
)

echo Removing Eureka container...
docker rm -f 854edee1b7e9aeb83c9bc1e51b436bf1dd044f796ceff713a260eef449d7937a 2>nul
if errorlevel 1 (
    echo Container might already be removed or ID changed
) else (
    echo Eureka container removed
)

echo.
echo [Step 2] Removing by container name (alternative)...
docker rm -f rabbitmq 2>nul
docker rm -f server-eureka 2>nul
echo.

echo [Step 3] Starting all services again...
docker-compose up -d
echo.

echo [Step 4] Waiting 30 seconds for startup...
timeout /t 30 /nobreak
echo.

echo [Step 5] Checking status...
docker-compose ps
echo.
echo ========================================
echo Done! Check the status above.
echo ========================================
pause
