@echo off
echo Checking if Flask is installed...


REM Try to import Flask; if it fails, install it
python -c "import flask" 2>NUL
if %errorlevel% neq 0 (
    echo Flask not found. Installing Flask...
    pip install flask
)

echo Starting server...
python server.py
