@echo off

if not exist venv (
    echo [ERROR] Not installed. Please run setup.bat first.
    pause
    exit /b 1
)

call venv\Scripts\activate.bat
echo [OK] Starting... http://localhost:8899
start http://localhost:8899
python run.py
