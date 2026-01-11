@echo off
echo ========================================
echo Cleaning and Rebuilding All Services
echo ========================================

echo.
echo Step 1: Cleaning all target directories...
if exist "user-service\target" rmdir /s /q "user-service\target"
if exist "product-service\target" rmdir /s /q "product-service\target"
if exist "order-service\target" rmdir /s /q "order-service\target"
if exist "gateway-service\target" rmdir /s /q "gateway-service\target"

echo.
echo Step 2: Cleaning Maven local repository cache...
echo This will force re-download of dependencies.

echo.
echo ========================================
echo Cleanup completed!
echo ========================================
echo.
echo Next steps:
echo 1. In IntelliJ IDEA, click Maven tool window (right side)
echo 2. Click the Reload button (refresh icon)
echo 3. Wait for dependencies to download
echo 4. Run "All Services" configuration
echo.
pause
