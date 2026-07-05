@echo off
title Practicas finales INSOD
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\instalar_y_abrir.ps1"
if errorlevel 1 (
  echo.
  echo No se pudo completar el arranque. Revisa el mensaje anterior.
  pause
)
