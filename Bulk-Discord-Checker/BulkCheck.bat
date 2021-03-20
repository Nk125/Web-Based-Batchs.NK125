@echo off
setlocal enableextensions enabledelayedexpansion
cd "%~dp0"
break off
:main
cls
echo ====================
echo ^|   NK125 Discord  ^|
echo ^|   Bulk  Checker  ^|
echo ====================
echo.
:enter
del tokenso.txt 1>nul 2>nul
echo.
set /p "tokens=Ingresa el archivo con los tokens: "
if "%tokens%"=="" goto enter
echo.
echo Haciendo requests para comprobar tokens, espere por favor. . .
echo.
type %tokens% | findstr /I /V "Token Navegador" | findstr /I /V /C:"|" /C:"&" /C:"(" /C:")">>tokenso.txt
for /f "tokens=* delims=" %%a in (tokenso.txt) do (
	echo.
	echo Authorization:%%a>header
	echo Content-Type:application/json>>header
	call :check %%a
)
pause
goto main
:check
if "%1"=="" exit /b
set "tokenr=%1"
call winhttpjs.bat https://discord.com/api/v6/users/@me -method GET -headers-file header -saveTo response.txt -force yes | findstr /I /C:"Status: 201"
if %errorlevel% GEQ 1 (
      echo Token Invalido (%tokenr%^)
      del header /f /s /q 1>nul 2>nul
      for /f "tokens=2 delims=:," %%a in (response.txt) do for /f "tokens=3 delims=:," %%b in (response.txt) do (
			set /p res=<response.txt
            echo Respuesta:%%a%%b (%res%^)
      )
	  exit /b 1
)
del header /f /s /q 1>nul 2>nul
echo Token: %tokenr%
for /f "tokens=22 delims=,:" %%c in (response.txt) do (
      echo.
      echo La cuenta esta verificada:%%c
)
for /f "tokens=6 delims=,:" %%d in (response.txt) do (
      echo.
      echo Avatar:%%d
)
for /f "tokens=10 delims=,:" %%e in (response.txt) do (
      echo.
      echo Flags Publicos:%%e
)
for /f "tokens=16 delims=,:" %%f in (response.txt) do (
      echo.
      echo NSFW Habilitado:%%f
)
for /f "tokens=2 delims=,:" %%g in (response.txt) do (
      echo.
      echo ID:%%g
)
for /f "tokens=4 delims=,:" %%h in (response.txt) do (
      echo.
      echo Nombre de usuario:%%h
)
for /f "tokens=8 delims=,:" %%i in (response.txt) do (
      echo.
      echo Discriminador:%%i
)
for /f "tokens=20 delims=,:" %%j in (response.txt) do (
      echo.
      echo Email:%%j
)
for /f "tokens=24 delims=,:" %%k in (response.txt) do (
      echo.
      echo Numero de telefono:%%k
)
for /f "tokens=18 delims=,:" %%l in (response.txt) do (
      echo.
      echo Tiene Multi Factor Authentication (Numero de telefono, 2FA^):%%l
)
for /f "tokens=14 delims=,:" %%m in (response.txt) do (
      echo.
      echo Idioma:%%m
)
del response.txt /f /s /q > nul
set tokenr=
set res=
exit /b 0
