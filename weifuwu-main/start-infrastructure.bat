@echo off
echo ========================================
echo Starting Infrastructure (MySQL + Nacos)
echo ========================================

echo Checking Docker status...
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

echo Starting MySQL and Nacos with docker-compose...
docker-compose up -d

echo Waiting for services to be ready...
timeout /t 30 /nobreak

echo.
echo ========================================
echo Infrastructure started successfully!
echo MySQL: localhost:3306
echo Nacos: http://localhost:8848/nacos
echo ========================================
echo.
echo You can now start the microservices.
pause
