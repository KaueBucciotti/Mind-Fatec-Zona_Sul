@echo off
cd /d "%~dp0"
title Mind - inicializador

echo ============================================
echo   MIND - banco + backend + site + app
echo ============================================
echo.

rem --- Flutter no PATH desta janela ---------------------------------------
where flutter >nul 2>&1
if errorlevel 1 set "PATH=C:\src\flutter\bin;%PATH%"

rem --- MongoDB -------------------------------------------------------------
powershell -NoProfile -Command "if (Test-NetConnection -ComputerName 127.0.0.1 -Port 27017 -InformationLevel Quiet) { exit 0 } else { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo [..] MongoDB parado. Tentando iniciar o servico ^(pede permissao^)...
    powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -Wait -ArgumentList '-NoProfile','-Command','Start-Service MongoDB'"
    timeout /t 5 >nul
    powershell -NoProfile -Command "if (Test-NetConnection -ComputerName 127.0.0.1 -Port 27017 -InformationLevel Quiet) { exit 0 } else { exit 1 }" >nul 2>&1
    if errorlevel 1 (
        echo [X] MongoDB nao subiu. Sem banco o backend nao inicia.
        echo     Abra o PowerShell como administrador e rode: Start-Service MongoDB
        pause
        exit /b 1
    )
)
echo [ok] MongoDB respondendo na porta 27017.

rem --- Emulador Android ----------------------------------------------------
for /f "delims=" %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\escolher-device.ps1"') do set "ALVO=%%i"

if "%ALVO%"=="chrome" (
    echo [..] Nenhum Android conectado. Ligando o emulador...
    start "" flutter emulators --launch Pixel_10_Pro_XL
    echo     Aguardando o Android terminar de iniciar...
    timeout /t 45 >nul
    for /f "delims=" %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\escolher-device.ps1"') do set "ALVO=%%i"
)

if "%ALVO%"=="chrome" (
    echo [!] Emulador nao ficou pronto a tempo. O app vai abrir no Chrome.
) else (
    echo [ok] Device do app: %ALVO%
)

rem --- Backend + site ------------------------------------------------------
echo.
echo [..] Abrindo a janela do BACKEND + SITE...
start "MIND - backend e site" cmd /k "cd /d "%~dp0" && npm run dev"

echo [..] Esperando a API responder...
node "%~dp0scripts\wait-for-backend.js"
if errorlevel 1 (
    echo [X] A API nao respondeu. Veja o erro na janela "MIND - backend e site".
    pause
    exit /b 1
)

rem --- App -----------------------------------------------------------------
echo.
echo [..] Abrindo a janela do APP...
start "MIND - app" cmd /k "cd /d "%~dp0mobile" && set "PATH=C:\src\flutter\bin;%PATH%" && flutter run -d %ALVO%"

echo.
echo ============================================
echo   Tudo no ar:
echo     Site .... http://localhost:3000
echo     API ..... http://localhost:8080
echo     App ..... %ALVO%
echo.
echo   Login de teste: gabriel / 2000
echo ============================================
echo.
pause
