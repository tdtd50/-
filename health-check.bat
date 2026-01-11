@echo off
chcp 65001 >nul
echo ========================================
echo   服务健康检查
echo ========================================
echo.

echo 检查容器状态:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 检查服务响应:
echo [用户服务] http://localhost:8081
curl -s http://localhost:8081/users >nul 2>&1 && echo [✓] 正常 || echo [✗] 异常

echo [商品服务] http://localhost:8082
curl -s http://localhost:8082/products >nul 2>&1 && echo [✓] 正常 || echo [✗] 异常

echo [订单服务] http://localhost:8083
curl -s http://localhost:8083/orders >nul 2>&1 && echo [✓] 正常 || echo [✗] 异常

echo [网关服务] http://localhost:8080
curl -s http://localhost:8080 >nul 2>&1 && echo [✓] 正常 || echo [✗] 异常

echo [前端页面] http://localhost:8088
curl -s http://localhost:8088 >nul 2>&1 && echo [✓] 正常 || echo [✗] 异常

echo [Nacos] http://localhost:8848
curl -s http://localhost:8848/nacos >nul 2>&1 && echo [✓] 正常 || echo [✗] 异常

echo.
pause
