@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title Administrador: WYZ TOOLBOX v1.0.0

:: Verificar privilegios de Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ===============================================================================
    echo   [!] Solicitando permissao de Administrador para o WYZ TOOLBOX...
    echo ===============================================================================

    :: Criar VBScript temporario para elevar sem perder o diretorio
    set "ELEVATE_VBS=%TEMP%\wyz_elevate.vbs"
    echo Set UAC = CreateObject^("Shell.Application"^) > "!ELEVATE_VBS!"
    echo UAC.ShellExecute "%~f0", "", "%~dp0", "runas", 1 >> "!ELEVATE_VBS!"
    cscript //nologo "!ELEVATE_VBS!"
    del /q "!ELEVATE_VBS!" 2>nul
    exit /b
)

:: Garantir que estamos no diretorio correto mesmo apos elevacao
cd /d "%~dp0"

:: Configurar encoding UTF-8 e dimensoes da janela
chcp 65001 >nul
mode con: cols=120 lines=42 2>nul

:: Executar a interface PowerShell do Toolbox
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\toolbox.ps1"

:: Manter janela aberta caso o PowerShell encerre inesperadamente
if %errorlevel% neq 0 (
    echo.
    echo [!] O Toolbox encerrou com um erro. Pressione qualquer tecla para fechar...
    pause >nul
)

exit /b
