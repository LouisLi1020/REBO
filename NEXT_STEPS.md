# 下一步（第一次上傳到 GitHub）

在終端機裡，**全部都在 `app/` 目錄下**執行。

---

## Step 1：補齊平台資料夾

```bash
cd "/Users/chengyili/Desktop/UTS/2025s1/side project/REBO/app"
flutter create .
```

會產生 `android/`、`ios/`、`web/`、`windows/`、`macos/`、`linux/`，不會覆蓋現有 `lib/`。

---

## Step 2：（選用）加入按鈕音效

若有 `click.mp3`（例如在 `_legacy/src/assets/audio/` 或本機其他地方），複製到：

```
app/assets/audio/click.mp3
```

沒有也無妨，之後再加即可。

---

## Step 3：初始化 Git 並接上遠端

```bash
cd "/Users/chengyili/Desktop/UTS/2025s1/side project/REBO/app"
git init
git remote add origin https://github.com/LouisLi1020/REBO.git
```

---

## Step 4：第一次提交並推送

```bash
git add .
git status   # 確認只有 app 內檔案，沒有 ../ 的規劃文件
git commit -m "chore: clean restart — modular lib structure, MIT license"
git branch -M main
git push -u origin main
```

若遠端已有內容（例如舊的 `develop`），可能要：

- **強制覆蓋**（慎用）：`git push -u origin main --force`
- **或** 先在 GitHub 上備份舊分支，再決定是否 force push

---

## Step 5：之後的日常

- 開發、commit、push 都在 **`app/`** 裡做。
- 根目錄的規劃文件、`_legacy/` 維持不進版控（已列在根目錄 `.gitignore`）。

完成 Step 1～4 後，專案就與 GitHub 同步並可正常開發了。
