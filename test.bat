@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   电商微服务系统 API 测试
echo ========================================
echo.

set GATEWAY=http://localhost:8080
set PASS=0
set FAIL=0

echo [1] 测试用户服务健康检查...
curl -s http://localhost:8081/users >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] 用户服务响应正常
    set /a PASS+=1
) else (
    echo [✗] 用户服务无响应
    set /a FAIL+=1
)

echo.
echo [2] 测试商品服务健康检查...
curl -s http://localhost:8082/products >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] 商品服务响应正常
    set /a PASS+=1
) else (
    echo [✗] 商品服务无响应
    set /a FAIL+=1
)

echo.
echo [3] 测试订单服务健康检查...
curl -s http://localhost:8083/orders >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] 订单服务响应正常
    set /a PASS+=1
) else (
    echo [✗] 订单服务无响应
    set /a FAIL+=1
)

echo.
echo [4] 测试网关路由 - 用户服务...
curl -s %GATEWAY%/user-service/users >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] 网关路由到用户服务正常
    set /a PASS+=1
) else (
    echo [✗] 网关路由到用户服务失败
    set /a FAIL+=1
)

echo.
echo [5] 创建测试用户...
curl -s -X POST %GATEWAY%/user-service/users ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"phone\":\"13800138000\"}" ^
  -o response.txt 2>nul
if %errorlevel% equ 0 (
    echo [✓] 创建用户成功
    type response.txt
    set /a PASS+=1
) else (
    echo [✗] 创建用户失败
    set /a FAIL+=1
)
del response.txt >nul 2>&1

echo.
echo [6] 查询用户列表...
curl -s %GATEWAY%/user-service/users -o response.txt 2>nul
if %errorlevel% equ 0 (
    echo [✓] 查询用户列表成功
    type response.txt
    set /a PASS+=1
) else (
    echo [✗] 查询用户列表失败
    set /a FAIL+=1
)
del response.txt >nul 2>&1

echo.
echo [7] 创建测试商品...
curl -s -X POST %GATEWAY%/product-service/products ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"测试商品\",\"price\":99.99,\"stock\":100}" ^
  -o response.txt 2>nul
if %errorlevel% equ 0 (
    echo [✓] 创建商品成功
    type response.txt
    set /a PASS+=1
) else (
    echo [✗] 创建商品失败
    set /a FAIL+=1
)
del response.txt >nul 2>&1

echo.
echo [8] 查询商品列表...
curl -s %GATEWAY%/product-service/products -o response.txt 2>nul
if %errorlevel% equ 0 (
    echo [✓] 查询商品列表成功
    type response.txt
    set /a PASS+=1
) else (
    echo [✗] 查询商品列表失败
    set /a FAIL+=1
)
del response.txt >nul 2>&1

echo.
echo [9] 创建测试订单...
curl -s -X POST %GATEWAY%/order-service/orders ^
  -H "Content-Type: application/json" ^
  -d "{\"userId\":1,\"productId\":1,\"quantity\":2}" ^
  -o response.txt 2>nul
if %errorlevel% equ 0 (
    echo [✓] 创建订单成功
    type response.txt
    set /a PASS+=1
) else (
    echo [✗] 创建订单失败
    set /a FAIL+=1
)
del response.txt >nul 2>&1

echo.
echo [10] 查询订单列表...
curl -s %GATEWAY%/order-service/orders -o response.txt 2>nul
if %errorlevel% equ 0 (
    echo [✓] 查询订单列表成功
    type response.txt
    set /a PASS+=1
) else (
    echo [✗] 查询订单列表失败
    set /a FAIL+=1
)
del response.txt >nul 2>&1

echo.
echo [11] 测试 Nacos 服务注册...
curl -s "http://localhost:8848/nacos/v1/ns/instance/list?serviceName=user-service" -o response.txt 2>nul
if %errorlevel% equ 0 (
    echo [✓] Nacos 服务注册查询成功
    set /a PASS+=1
) else (
    echo [✗] Nacos 服务注册查询失败
    set /a FAIL+=1
)
del response.txt >nul 2>&1

echo.
echo [12] 测试前端页面...
curl -s http://localhost:8088 >nul 2>&1
if %errorlevel% equ 0 (
    echo [✓] 前端页面可访问
    set /a PASS+=1
) else (
    echo [✗] 前端页面无法访问
    set /a FAIL+=1
)

echo.
echo ========================================
echo   测试结果汇总
echo ========================================
echo   通过: !PASS! 项
echo   失败: !FAIL! 项
echo   总计: 12 项
echo ========================================
echo.

if !FAIL! equ 0 (
    echo [✓] 所有测试通过！系统运行正常
    exit /b 0
) else (
    echo [✗] 有 !FAIL! 项测试失败，请检查日志
    exit /b 1
)
