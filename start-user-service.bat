@echo off
echo Starting User Service...
cd user-service

set MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.1\plugins\maven\lib\maven3

if exist "%MAVEN_HOME%\bin\mvn.cmd" (
    set PATH=%MAVEN_HOME%\bin;%PATH%
    call mvn spring-boot:run
) else (
    echo Maven not found. Please ensure Maven is installed.
    echo.
    echo Alternative: Use IntelliJ IDEA to run UserServiceApplication
    pause
)
