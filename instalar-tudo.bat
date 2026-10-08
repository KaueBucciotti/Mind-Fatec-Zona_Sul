@echo off
cd /d "%~dp0"
title Mind - instalando dependencias
setlocal enabledelayedexpansion

echo ============================================
echo   MIND - instalacao de dependencias
echo ============================================
echo.

set FALTANDO=0

rem ---------------------------------------------------------------- pre-requisitos
echo [1/6] Conferindo o que precisa estar instalado...
echo.

rem --- Node -----------------------------------------------------------------
where node >nul 2>&1
if errorlevel 1 (
    echo   [X] Node.js nao encontrado.
    echo       Instale com:  winget install OpenJS.NodeJS.LTS
    set FALTANDO=1
) else (
    for /f "delims=" %%v in ('node --version') do echo   [ok] Node %%v
)

rem --- Java -----------------------------------------------------------------
where java >nul 2>&1
if errorlevel 1 (
    echo   [X] Java nao encontrado ^(o backend precisa do JDK 17 ou superior^).
    echo       Instale com:  winget install Microsoft.OpenJDK.21
    set FALTANDO=1
) else (
    for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do echo   [ok] Java %%v
)

rem --- Flutter --------------------------------------------------------------
where flutter >nul 2>&1
if errorlevel 1 (
    if exist "C:\src\flutter\bin\flutter.bat" (
        set "PATH=C:\src\flutter\bin;%PATH%"
        echo   [ok] Flutter encontrado em C:\src\flutter ^(fora do PATH do sistema^).
    ) else (
        echo   [X] Flutter nao encontrado.
        echo       Instale com:  git clone -b stable https://github.com/flutter/flutter.git C:\src\flutter
        echo       e adicione C:\src\flutter\bin ao PATH do usuario.
        set FALTANDO=1
    )
) else (
    echo   [ok] Flutter no PATH.
)

rem --- MongoDB --------------------------------------------------------------
sc query MongoDB >nul 2>&1
if errorlevel 1 (
    echo   [X] Servico do MongoDB nao encontrado.
    echo       Instale com:  winget install MongoDB.Server
    set FALTANDO=1
) else (
    echo   [ok] Servico MongoDB instalado.
)

echo.
if "%FALTANDO%"=="1" (
    echo ============================================
    echo   Instale os itens marcados com [X] acima,
    echo   feche e reabra o terminal, e rode de novo.
    echo ============================================
    pause
    exit /b 1
)

rem ---------------------------------------------------------------- dependencias
echo [2/6] Dependencias da raiz ^(concurrently, mongodb^)...
call npm install
if errorlevel 1 goto :erro

echo.
echo [3/6] Dependencias do site ^(React + Vite^)...
call npm install --prefix frontend
if errorlevel 1 goto :erro

echo.
echo [4/6] Dependencias do app ^(Flutter: http, shared_preferences^)...
pushd mobile
call flutter pub get
if errorlevel 1 (
    popd
    goto :erro
)
popd

echo.
echo [5/6] Dependencias do backend ^(Spring Boot via Maven^)...
echo       Na primeira vez isso baixa centenas de MB. Pode demorar.
pushd backend
call mvnw.cmd -B dependency:go-offline
if errorlevel 1 (
    echo   [!] O Maven relatou problemas ao baixar tudo de uma vez.
    echo       Nao e necessariamente fatal: o que faltar sera baixado no primeiro run.
)
popd

echo.
echo [6/6] Diagnostico do Flutter...
call flutter doctor

echo.
echo ============================================
echo   Instalacao concluida.
echo.
echo   Para rodar tudo:   npm start
echo   Login de teste:    gabriel / 2000
echo ============================================
echo.
pause
exit /b 0

:erro
echo.
echo ============================================
echo   A instalacao parou por causa do erro acima.
echo ============================================
pause
exit /b 1
