@echo off
echo ========================================
echo 测试启动 User Service
echo ========================================
echo.

cd user-service

echo 方法1: 尝试使用系统 Maven...
where mvn >nul 2>&1
if %errorlevel% equ 0 (
    echo 找到系统 Maven，正在启动...
    mvn spring-boot:run
    goto :end
)

echo 方法1 失败：系统未安装 Maven
echo.

echo 方法2: 尝试使用 IDEA 内置 Maven...
set IDEA_MAVEN=C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.1\plugins\maven\lib\maven3\bin\mvn.cmd
if exist "%IDEA_MAVEN%" (
    echo 找到 IDEA Maven，正在启动...
    "%IDEA_MAVEN%" spring-boot:run
    goto :end
)

echo 方法2 失败：未找到 IDEA Maven
echo.

echo ========================================
echo 所有方法都失败了！
echo ========================================
echo.
echo 请在 IntelliJ IDEA 中执行以下操作：
echo 1. 打开右侧的 Maven 工具窗口
echo 2. 展开 user-service
echo 3. 展开 Plugins
echo 4. 展开 spring-boot
echo 5. 双击 spring-boot:run
echo.

:end
pause
