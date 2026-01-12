@echo off
chcp 65001 >nul
echo ========================================
echo   电商微服务系统启动脚本
echo ========================================
echo.

echo [1/5] 检查 Docker 是否运行...
docker version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] Docker 未运行，请先启动 Docker Desktop
    pause
    exit /b 1
)
echo [✓] Docker 运行正常
echo.

echo [2/5] 停止并清理旧容器...
docker-compose down
echo [✓] 清理完成
echo.

echo [3/5] 重新构建镜像...
docker-compose build
if %errorlevel% neq 0 (
    echo [错误] 镜像构建失败
    pause
    exit /b 1
)
echo [✓] 镜像构建完成
echo.

echo [4/5] 启动所有服务...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [错误] 服务启动失败
    pause
    exit /b 1
)
echo [✓] 服务启动完成
echo.

echo [5/5] 等待服务就绪...
echo 等待 MySQL 健康检查（约30秒）...
timeout /t 30 /nobreak >nul

echo.
echo ========================================
echo   服务访问地址
echo ========================================
echo   前端页面:     http://localhost:8088
echo   网关服务:     http://localhost:8080
echo   Nacos控制台:  http://localhost:8848/nacos
echo                (用户名/密码: nacos/nacos)
echo.
echo   用户服务:     http://localhost:8081
echo   商品服务:     http://localhost:8082
echo   订单服务:     http://localhost:8083
echo   MySQL数据库:  localhost:3307
echo                (用户名/密码: root/123456)
echo ========================================
echo.

echo 检查服务状态...
docker ps
echo.

echo 启动完成！按任意键查看实时日志，或直接关闭窗口
pause >nul
docker-compose logs -f
