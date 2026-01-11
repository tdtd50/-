@echo off
chcp 65001 >nul
echo ========================================
echo 启动前端服务
echo ========================================
echo.

cd frontend

echo 检测可用的 HTTP 服务器...
echo.

REM 检查 Python
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 找到 Python，使用 Python HTTP 服务器
    echo.
    echo 前端服务启动在: http://localhost:3000
    echo 按 Ctrl+C 停止服务
    echo.
    python -m http.server 3000
    goto :end
)

REM 检查 Node.js
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 找到 Node.js，使用 http-server
    echo.
    echo 正在安装 http-server...
    call npx http-server -p 3000 -c-1
    goto :end
)

REM 检查 PHP
php --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 找到 PHP，使用 PHP 内置服务器
    echo.
    echo 前端服务启动在: http://localhost:3000
    echo 按 Ctrl+C 停止服务
    echo.
    php -S localhost:3000
    goto :end
)

echo ❌ 未找到可用的 HTTP 服务器
echo.
echo 请安装以下任意一个：
echo   - Python 3: https://www.python.org/downloads/
echo   - Node.js: https://nodejs.org/
echo   - PHP: https://www.php.net/downloads
echo.
echo 或者使用方案 2，将前端集成到 Gateway 中
echo.

:end
pause
