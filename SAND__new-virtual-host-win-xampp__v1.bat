@echo off
chcp 65001
cls

rem Приветствие
echo.
echo      Hello World!
echo.
echo      Это скрипт для создания нового локального сайта (хоста) 
echo      на локальном сервере XAMPP.
echo.
echo      Выполняя указанные инструкции вы установите и правильно настроите
echo      свой тестовый сайт для разработки на вашей локальной машине.
echo      Если что-то пошло не так - просто закройте это окно 
echo      и снова запустите этот bat-файл.
echo.

:dirnameinput
rem Ввод пути в каталог для устанавливаемого сайта
echo.
echo      Ваш сайт будет установлен в выбранный вами КАТАЛОГ.
echo      Для этого ведите правильный путь от корня диска до каталога создаваемого 
echo      сайта и нажмите Enter (закрывающий слеш обязателен), например
echo.
echo      e:\www\1111\
echo.      
echo      Если каталог уже существует, ничего не произойдет - можно дальше   
echo      продолжать установку вашего сайта.
echo.
set /p NEW_HOST_DIR=

cls
echo.
echo ==================================================================
echo      Вы указали следующий ПУТЬ для размещения вашего сайта:
echo.
echo      %NEW_HOST_DIR%
echo.
echo      Все верно? Можно продолжить? 
echo      Если это верно - нажмите "Y", если не верно - нажмите "N" 
echo      (регистр не имеет значения)
echo ==================================================================
echo.

echo.
choice /M "Выбрать ..."

if %ERRORLEVEL% == 1 (

	cls
	echo.
	echo      Ваш выбор сделан - сайт будет размещаться в КАТАЛОГЕ 
	echo.
	echo      %NEW_HOST_DIR%
	echo.

	) else (

	cls
	goto dirnameinput
)

rem Проверка существования каталога и при отсутствии - его создание
if not exist %NEW_HOST_DIR% (

	md %NEW_HOST_DIR%
	echo.

	) else (

	echo      Такой каталог уже существует.
	echo      Ничего страшного - можно дальше продолжать установку вашего сайта.
	echo.
)

pause

:hostnameinput
rem Ввод имени создаваемого хоста
cls
echo.
echo      Теперь введите правильное ИМЯ создаваемого локального хоста, например 
echo.
echo      my-new-host.loc
echo.
set /p NEW_HOST_NAME=

if defined NEW_HOST_NAME (

	goto next

	) else (

	cls
	echo.
	echo      Вы не указали правильное ИМЯ создаваемого сайта.
	echo      Возможно, вы случайно нажали Enter раньше времени.
	echo      Попробуйте еще раз ...
	echo.
	pause
	goto hostnameinput

	)

:next
cls
echo.
echo ==================================================================
echo      Вы указали следующее ИМЯ для вашего сайта:
echo.
echo      %NEW_HOST_NAME%
echo.
echo      Все верно? Можно продолжить? 
echo      Если это верно - нажмите "Y", если не верно - нажмите "N" 
echo      (регистр не имеет значения)
echo ==================================================================
echo.

echo.
choice /M "Выбрать ..."

if %ERRORLEVEL% == 1 (

	cls
	echo.
	echo      Ваш выбор сделан - сайт будет называться
	echo.
	echo      %NEW_HOST_NAME%
	echo.

	) else (
	cls
	goto hostnameinput
)

rem Проверка существования сайта и при отсутствии - его создание
if not exist %NEW_HOST_DIR%%NEW_HOST_NAME% (
	md %NEW_HOST_DIR%%NEW_HOST_NAME%
	echo.
	) else (
	echo      Такой сайт уже существует.
	echo      Необходимо проверить настройки этого сайта. 
	echo      Возможно, сайт уже настроен и правильно работает.
	echo      Если нет - можно дальше продолжать установку вашего сайта.
	echo.
)

pause

rem Проверка существования index-файла для устанавливаемого сайта и при отсутсвии - его создание
cls
echo.
echo      Сейчас будет проведена проверка наличия index-файла.
echo      Если такого файла на сайте нет, он будет сгенерирован.
echo.

pause

if not exist %NEW_HOST_DIR%%NEW_HOST_NAME%\index.php (

	@echo ^<?php > %NEW_HOST_DIR%%NEW_HOST_NAME%\index.php
	@echo echo "<h1>Hello World!</h1>"; >> %NEW_HOST_DIR%%NEW_HOST_NAME%\index.php
	@echo echo "<div style='color: green'>Ваш новый локальный хост (сайт) готов!</div>"; >> %NEW_HOST_DIR%%NEW_HOST_NAME%\index.php
	@echo echo "<div><a href='http://%NEW_HOST_NAME%'>http://%NEW_HOST_NAME%</a></div>"; >> %NEW_HOST_DIR%%NEW_HOST_NAME%\index.php
	@echo phpinfo(^); >> %NEW_HOST_DIR%%NEW_HOST_NAME%\index.php
	@echo ^?^> >> %NEW_HOST_DIR%%NEW_HOST_NAME%\index.php
	cls
	echo.
	echo      Файл index.php создан в каталоге вашего сайта.
	echo.

	) else (

	cls
	echo.
	echo      Index-файл уже существует.
	echo      Необходимо проверить его содержимое. 
	echo      Можно дальше продолжать установку сайта.
	echo.
)

pause

rem Создание нового виртуального хоста в каталоге Apache в файле httpd-vhosts.conf 
cls
echo.
echo      Сейчас будет создан новый виртуальный хост 
echo      в файле httpd-vhosts.conf сервера Apache.
echo.

pause

set V_HOST_FILE=f:\2018\DevProg\XAMPP-717\apache\conf\extra\httpd-vhosts.conf

@echo. >> %V_HOST_FILE%
@echo. >> %V_HOST_FILE%
@echo ^## Хост %NEW_HOST_NAME% >> %V_HOST_FILE%
@echo ^#  >> %V_HOST_FILE%
@echo ^<VirtualHost *:80^> >> %V_HOST_FILE%
@echo     ServerAdmin azwebdds@gmail.com >> %V_HOST_FILE%
@echo     DocumentRoot "%NEW_HOST_DIR%%NEW_HOST_NAME%" >> %V_HOST_FILE%
@echo     ServerName %NEW_HOST_NAME% >> %V_HOST_FILE%
@echo     ErrorLog "e:\www\2017\logs\xampp717\error.log" >> %V_HOST_FILE%
@echo     CustomLog "e:\www\2017\logs\xampp717\access.log" common >> %V_HOST_FILE%
@echo ^</VirtualHost^> >> %V_HOST_FILE%
@echo ^<Directory "%NEW_HOST_DIR%%NEW_HOST_NAME%"^> >> %V_HOST_FILE%
@echo     AllowOverride All >> %V_HOST_FILE%
@echo     Require all granted >> %V_HOST_FILE%
@echo ^</Directory^> >> %V_HOST_FILE%

cls
echo.
echo      Файл httpd-vhosts.conf настроен.
echo.

pause

rem Создание нового виртуального хоста в файле hosts
cls
echo.
echo      Сейчас будет создан новый виртуальный хост в файле hosts.
echo.

pause

set HOSTS_WINFILE=c:\Windows\System32\drivers\etc\hosts

@echo. >> %HOSTS_WINFILE%
@echo 127.0.0.1		%NEW_HOST_NAME% >> %HOSTS_WINFILE%

cls
echo.
echo      Файл hosts настроен.
echo.

pause

rem Перезапуск Apache.
cls
echo.
echo      Ваш новый сайт почти готов к работе.
echo      Сейчас будет произведен перезапуск сервера Apache 
echo      и сайт будет открыт в браузере.
echo.     
echo      Если этого не произойдет, нужно искать ошибку...
echo.     

pause

cls
start /b f:\2018\DevProg\XAMPP-717\apache_stop.bat
timeout /T10
start /b f:\2018\DevProg\XAMPP-717\apache_start.bat

cls
color 72
echo.
echo.     
echo      Каталог нового хоста создан.
echo      Виртуальные хосты созданы и настроены.
echo      Запускается браузер для проверки работы созданного хоста ...
echo.     

timeout /T10
start http://%NEW_HOST_NAME%


cls
echo.
echo      Если все получилось, закройте это окно.
echo      При этом скрипт закончит работу, закроются все открытые  
echo      во время его работы окна и остановится сервер Apache.
echo.     
echo      Установка и настройка локального сайта закончилась успешно.
echo.     
echo      Перезапустите сервер Apache в контрольной панели XAMPP
echo.     
echo.     
echo      Приятной работы!
echo.
echo ==============================================================================