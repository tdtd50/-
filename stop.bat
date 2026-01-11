@echo off
chcp 65001 >nul
echo ========================================
echo   停止电商微服务系统
echo ========================================
echo.

echo 正在停止所有服务...
docker-compose down

echo.
echo [✓] 所有服务已停止
echo.
pause
