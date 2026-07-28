#!/bin/bash

if [ ! -d "venv" ]; then
    echo "[ERROR] Not installed. Please run setup.sh first."
    exit 1
fi

source venv/bin/activate
echo "[OK] Starting... http://localhost:8899"

# Open browser (Mac: open, Linux: xdg-open)
if command -v open &>/dev/null; then
    sleep 1 && open http://localhost:8899 &
elif command -v xdg-open &>/dev/null; then
    sleep 1 && xdg-open http://localhost:8899 &
fi

python run.py
