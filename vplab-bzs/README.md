# 佐證資料管理系統

**嶺東科技大學 數位媒體設計系 × 虛擬製作研習社 vplab 開源專案**

教師升等評鑑佐證資料的本機管理工具。  
上傳 PDF / 圖片、AI 智能分類、自動編號蓋章、一鍵匯出合併 PDF 與評分表。

---

## 功能

- 📁 **佐證上傳**：支援 PDF、JPG、PNG，自動轉 A4、蓋章編號
- 🤖 **AI 智能分類**：呼叫本機 Vision LLM，自動辨識文件類型與所屬指標
- 🔢 **自動編號**：A1-1-1(1)、A1-1-1(2)… 群組編號一鍵整理
- 📄 **匯出 PDF**：全份合併 PDF，含分隔頁
- 📝 **匯出 Word**：簡述評分表草稿（.docx）
- 🔄 **自動重啟**：存檔 server.py 或 index.html 後，伺服器即時重啟（run.py）

---

## 安裝

```bash
# 建立虛擬環境
python -m venv venv

# 啟動虛擬環境
# Windows:
venv\Scripts\activate
# macOS / Linux:
source venv/bin/activate

# 安裝相依套件
pip install pymupdf python-docx
```

---

## 設定 AI 端點（選用）

智能分類功能需要本機 Vision LLM（支援 llama.cpp、Ollama、LM Studio 等 OpenAI 相容端點）。

```bash
cp config.example.json config.json
# 編輯 config.json，填入你的 AI 端點位址
```

不設定也可以正常使用，只是智能分類功能會無法呼叫。

---

## 初始化資料庫

```bash
cp 佐證資料庫_範例.json 佐證資料庫.json
```

---

## 啟動

```bash
# 一般啟動
python server.py

# 開發模式（存檔自動重啟）
python run.py
```

瀏覽器開啟：[http://localhost:8899](http://localhost:8899)

---

## 目錄結構

```
.
├── server.py              # 主伺服器
├── run.py                 # 自動重啟啟動器
├── static/
│   └── index.html         # 前端介面
├── uploads/               # 上傳的佐證文件（不進 git）
├── output/                # 匯出的 PDF / Word（不進 git）
├── 佐證資料庫_範例.json   # 空白資料庫範本
├── 佐證資料庫.json        # 你的資料（不進 git）
└── config.example.json    # AI 端點設定範本
```

---

## 評鑑指標結構

本系統採用**嶺東科技大學數位媒體設計系**教師資格審查評鑑指標（A1～A6、B1～B6）。  
如需套用其他學校指標，可修改 `server.py` 中的 `INDICATORS` 字典。

> 教師評鑑版（通用版）預計另行釋出。

---

## 開源授權

MIT License

嶺東科技大學 數位媒體設計系 虛擬製作研習社 vplab  
[https://www.instagram.com/ltu_vplab](https://www.instagram.com/ltu_vplab)
