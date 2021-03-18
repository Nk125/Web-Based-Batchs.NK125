@echo off
:init
cls
echo Webhook Message Sender
set /p "message=Ingresa el mensaje a enviar: "
set /p "webhook=Ingresa la URL del webhook: "
echo Content-Type: application/json>header
call echo {"content": "%message%"}>body.json
call "winhttpjs.bat" %webhook% -method POST -headers-file header -saveTo con -body-file body.json
pause
goto init
