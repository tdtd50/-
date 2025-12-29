@echo off
echo ========================================
echo Debug User Service
echo ========================================
cd user-service

echo.
echo Running with debug output...
echo.

set MAVEN_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.1\plugins\maven\lib\maven3

if exist "%MAVEN_HOME%\bin\mvn.cmd" (
    "%MAVEN_HOME%\bin\mvn.cmd" spring-boot:run -X
) else (
    echo Maven not found. Trying system Maven...
    mvn spring-boot:run -X
)

pause
