@echo off
echo.
echo +--------------------------------------------------+
echo ^|  vplab-bzs  Setup                               ^|
echo ^|  LTU Digital Media x vplab                      ^|
echo +--------------------------------------------------+
echo.

:: Find Python 3.12
set PY=

py -3.12 --version >nul 2>&1
if not errorlevel 1 set PY=py -3.12
if not "%PY%"=="" goto found

python --version >nul 2>&1
if not errorlevel 1 set PY=python
if not "%PY%"=="" goto found

echo [ERROR] Python not found. Please install Python 3.12
echo         https://www.python.org/downloads/
pause
exit /b 1

:found
for /f "tokens=2" %%v in ('%PY% --version 2^>^&1') do set PYVER=%%v
echo [OK] Python %PYVER%  (%PY%)

:: Create venv
if exist venv (
    echo [OK] venv already exists
) else (
    echo [..] Creating venv...
    %PY% -m venv venv
    echo [OK] venv created
)

call venv\Scripts\activate.bat

:: Install packages
echo [..] Installing packages...
pip install --upgrade pip -q
pip install pymupdf -q
pip install python-docx -q

:: Verify
echo.
echo [..] Verifying...
python -c "import fitz; print('[OK] pymupdf', fitz.__version__)"
if errorlevel 1 ( echo [ERROR] pymupdf failed & pause & exit /b 1 )
python -c "import docx; print('[OK] python-docx', docx.__version__)"
if errorlevel 1 ( echo [ERROR] python-docx failed & pause & exit /b 1 )

:: Create folders
if not exist uploads mkdir uploads
if not exist output  mkdir output
echo [OK] Folders ready

:: Init database
if not exist "ä½è­è³æåº«.json" (
    if exist "ä½è­è³æåº«_ç¯ä¾.json" (
        copy "ä½è­è³æåº«_ç¯ä¾.json" "ä½è­è³æåº«.json" >nul
        echo [OK] Database initialized from template
    ) else (
        echo [WARN] Template not found
    )
) else (
    echo [OK] Database already exists
)

:: Init config
if not exist config.json (
    if exist config.example.json (
        copy config.example.json config.json >nul
        echo [OK] config.json created from template
        echo      Edit config.json to set your AI endpoint (optional)
    )
) else (
    echo [OK] config.json already exists
)

:: Done
echo.
echo +--------------------------------------------------+
echo ^|  Done! Run start.bat to launch.                 ^|
echo +--------------------------------------------------+
echo.
pause
