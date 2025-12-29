@echo off
echo ========================================
echo Compiling All Services
echo ========================================

set MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.1\plugins\maven\lib\maven3
set MAVEN_CMD="%MAVEN_HOME%\bin\mvn.cmd"

if exist %MAVEN_CMD% (
    echo Using IntelliJ IDEA Maven
) else (
    echo Maven not found
    pause
    exit /b 1
)

cd /d %~dp0

echo.
echo Packaging project...
call %MAVEN_CMD% clean package -DskipTests

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESS
    echo ========================================
) else (
    echo.
    echo BUILD FAILED
)

pause
