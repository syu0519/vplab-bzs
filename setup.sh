#!/bin/bash
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  vplab-bzs  佐證資料管理系統  -  Setup                     ║"
echo "║  嶺東數媒 x vplab                                ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ── 找 Python 3.10+ ──────────────────────────────────
PY=""
for cmd in python3.12 python3.11 python3.10 python3 python; do
    if command -v $cmd &>/dev/null; then
        VER=$($cmd -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)
        MAJOR=$(echo $VER | cut -d. -f1)
        MINOR=$(echo $VER | cut -d. -f2)
        if [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 10 ]; then
            PY=$cmd
            break
        fi
    fi
done

if [ -z "$PY" ]; then
    echo "[ERROR] 找不到 Python 3.10+，請先安裝"
    echo "        https://www.python.org/downloads/"
    exit 1
fi
echo "[OK] 使用：$PY ($($PY --version))"

# ── 建立 venv ─────────────────────────────────────────
if [ -d "venv" ]; then
    echo "[OK] venv 已存在，跳過建立"
else
    echo "[..] 建立虛擬環境..."
    $PY -m venv venv
    echo "[OK] venv 建立完成"
fi

source venv/bin/activate

# ── 安裝套件 ─────────────────────────────────────────
echo "[..] 升級 pip..."
pip install --upgrade pip -q

echo "[..] 安裝 pymupdf..."
pip install pymupdf -q

echo "[..] 安裝 python-docx..."
pip install python-docx -q

# ── 驗證 ─────────────────────────────────────────────
echo ""
echo "[..] 驗證安裝..."
python -c "import fitz; print(f'[OK] pymupdf {fitz.__version__}')"
if [ $? -ne 0 ]; then
    echo "[ERROR] pymupdf 安裝失敗"
    echo "        請手動執行：source venv/bin/activate && pip install pymupdf"
    exit 1
fi
python -c "import docx; print(f'[OK] python-docx {docx.__version__}')"
if [ $? -ne 0 ]; then
    echo "[ERROR] python-docx 安裝失敗"
    echo "        請手動執行：source venv/bin/activate && pip install python-docx"
    exit 1
fi

# ── 建立目錄 ─────────────────────────────────────────
mkdir -p uploads output
echo "[OK] 目錄確認完成"

# ── 初始化資料庫 ─────────────────────────────────────
if [ ! -f "佐證資料庫.json" ]; then
    if [ -f "佐證資料庫_範例.json" ]; then
        cp "佐證資料庫_範例.json" "佐證資料庫.json"
        echo "[OK] 佐證資料庫.json 已從範例初始化"
    else
        echo "[WARN] 找不到 佐證資料庫_範例.json，請手動建立 佐證資料庫.json"
    fi
else
    echo "[OK] 佐證資料庫.json 已存在"
fi

# ── 初始化 AI 設定 ────────────────────────────────────
if [ ! -f "config.json" ]; then
    if [ -f "config.example.json" ]; then
        cp config.example.json config.json
        echo "[OK] config.json 已從範例建立"
        echo "     請編輯 config.json 填入你的 AI 端點位址（選用）"
    fi
else
    echo "[OK] config.json 已存在"
fi

# ── 完成 ─────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  ✅ 環境建置完成！                               ║"
echo "║  執行 bash start.sh 啟動系統                     ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
