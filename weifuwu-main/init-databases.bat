@echo off
echo ========================================
echo Initializing Databases
echo ========================================

echo Creating databases: user_db, product_db, order_db...
mysql -h localhost -P 3306 -u root -p123456 < init-db\create-db.sql

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo Databases initialized successfully!
    echo ========================================
) else (
    echo.
    echo Failed to initialize databases.
    echo Please check MySQL connection.
)

pause
