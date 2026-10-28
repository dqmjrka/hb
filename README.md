# 📺 HackBot V1.0 for iOS (.ipa)
> by **@HackBot_TV** | [t.me/hackbot_tv](https://t.me/hackbot_tv) | [hb.ttdq.pro](https://hb.ttdq.pro)

Нативное iOS-приложение для управления Smart TV и розыгрышей (LG WebOS, Samsung Tizen, Android TV) по локальной сети Wi-Fi, написанное на **SwiftUI**.

Готово к автоматической сборке в **.ipa** через **GitHub Actions** (macOS runner) без необходимости иметь Mac.

---

## 🚀 Как собрать HackBot.ipa через GitHub

### Шаг 1. Создайте репозиторий на GitHub
1. Перейдите на [github.com/new](https://github.com/new).
2. Назовите репозиторий, например: `HackBot-iOS` (Public или Private).
3. **Не** добавляйте README или .gitignore (они уже готовы в этой папке).

### Шаг 2. Отправьте проект в GitHub
Откройте терминал (PowerShell или Git Bash) в папке `C:\Users\dqmjrka\Desktop\TelevizorPRANK\ipa`:

```powershell
cd C:\Users\dqmjrka\Desktop\TelevizorPRANK\ipa
git init
git add .
git commit -m "Initial HackBot iOS commit"
git branch -M main
git remote add origin https://github.com/ВАШ_АККАУНТ/HackBot-iOS.git
git push -u origin main
```

---

### Шаг 3. Автоматическая сборка в GitHub Actions
1. Откройте ваш репозиторий в браузере и перейдите во вкладку **Actions**.
2. Воркфлоу **"Build HackBot IPA"** запустится автоматически при пуше (или нажмите `Run workflow`).
3. Примерно за **1–2 минуты** сервер Apple macOS скомпилирует приложение и упакует его в `HackBot.ipa`.
4. Нажмите на завершенный запуск — внизу в блоке **Artifacts** скачайте архив **`HackBot-iOS-IPA`**. Внутри будет готовый файл **`HackBot.ipa`**.

---

## 📲 Как установить HackBot.ipa на iPhone

Установить полученный файл `.ipa` можно любым привычным способом сайдлоадинга без джейлбрейка:

1. **Sideloadly (ПК)**:
   - Подключите iPhone по проводу или Wi-Fi к компьютеру.
   - Перетащите `HackBot.ipa` в окно Sideloadly, введите Apple ID и нажмите **Start**.
2. **AltStore**:
   - Откройте `HackBot.ipa` на телефоне через приложение AltStore.
3. **Scarlet / TrollStore / Gbox / Esign**:
   - Импортируйте `HackBot.ipa` и нажмите «Установить».

---

## ⚡ Функционал приложения

- **Экраны и навигация:**
  - `WelcomeScreen`: пульсирующий неоновый логотип, кнопки **Start** и **Telegram** (`t.me/hackbot_tv`).
  - `ConnectModal`: радар сонара, сканирование ТВ в подсети Wi-Fi, ручной ввод IP, модальное окно подтверждения сопряжения:
    > *"📺 На экране ТВ появится запрос. Возьмите пульт и нажмите ДА / РАЗРЕШИТЬ..."*
  - `Control`: статус подключения, пинг, кнопка «Отключить», раздельные кнопки питания `On (WoL)` и `Off` (выключение питания без разрыва соединения), `Screen On` и `Screen Off`, слайдер и шаг громкости `±3`, выбор аудиовыхода, D-Pad пульт Magic Remote, переключение видеовходов (HDMI 1–3, LiveTV), быстрый запуск YouTube и браузера.
  - `Pranks`: 8 встроенных розыгрышей с авто-восстановлением параметров и большая кнопка **🚨 ⛔ СТОП ВСЕ ПРАНКИ**.
  - `Status`: телеметрия ТВ, сетевые параметры, задержка ping, активный источник звука.
  - `Console`: терминал командной строки с подсказками опкодов, чипами быстрых команд (`help`, `status`, `wol`, `screen off`, `stop`, `clear`).
  - `Settings`: официальные кнопки **Telegram** (`t.me/hackbot_tv`) и **Site** (`hb.ttdq.pro`), переключатель демо-режима.
