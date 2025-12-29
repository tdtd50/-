@echo off
chcp 65001 >nul
echo ========================================
echo 环境检查脚本
echo ========================================
echo.

echo [1/6] 检查 Java 版本...
java -version 2>&1 | findstr "version"
if %errorlevel% neq 0 (
    echo ❌ Java 未安装或不在 PATH 中
) else (
    echo ✅ Java 已安装
)
echo.

echo [2/6] 检查 Docker 状态...
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker 未运行
) else (
    echo ✅ Docker 正在运行
)
echo.

echo [3/6] 检查 MySQL 容器...
docker ps | findstr mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ MySQL 容器未运行
) else (
    echo ✅ MySQL 容器正在运行
    docker exec mysql mysql -uroot -p123456 -e "SHOW DATABASES;" 2>nul | findstr "user_db product_db order_db"
    if %errorlevel% neq 0 (
        echo ❌ 数据库未初始化
    ) else (
        echo ✅ 数据库已初始化
    )
)
echo.

echo [4/6] 检查 Nacos 容器...
docker ps | findstr nacos >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Nacos 容器未运行
) else (
    echo ✅ Nacos 容器正在运行
)
echo.

echo [5/6] 检查端口占用...
echo 检查 8080-8083 端口（应该空闲）...
netstat -ano | findstr "8080 8081 8082 8083" >nul 2>&1
if %errorlevel% equ 0 (
    echo ⚠️  警告：某些端口已被占用
    netstat -ano | findstr "8080 8081 8082 8083"
) else (
    echo ✅ 所有服务端口空闲
)
echo.

echo [6/6] 检查基础设施端口...
echo 检查 3307 (MySQL) 和 8848 (Nacos)...
netstat -ano | findstr "3307 8848" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 基础设施端口未监听
) else (
    echo ✅ 基础设施端口正常
    netstat -ano | findstr "3307 8848"
)
echo.

echo ========================================
echo 检查完成！
echo ========================================
echo.
echo 如果所有检查都通过，可以尝试启动服务。
echo 如果有失败项，请先解决相应问题。
echo.
pause
