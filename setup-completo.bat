@echo off
rem Executa o setup-completo.ps1 como administrador.
rem A elevacao e necessaria para instalar programas e o servico do MongoDB.

net session >nul 2>&1
if errorlevel 1 (
    echo Pedindo permissao de administrador...
    powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','%~dp0setup-completo.ps1'"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-completo.ps1"
