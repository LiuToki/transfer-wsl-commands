@echo off
chcp 65001
setlocal enabledelayedexpansion

cd /d %~dp0

set SRC=\\wsl.localhost\Ubuntu\usr\bin\
set DIST=%~dp0bin\

rem create base text.
rem CR
FOR /f "delims=" %%i IN ('cmd /u /c ECHO;名') DO (
set CR=%%i
set CR=!CR:~0,1!
)

rem LF
set LF=^


set BASE_TEXT=@echo off!CR!!LF!wsl COMMAND ^^%%*

:getopts
rem get arguments
	if not [%1]==[] (
		if "%~1"=="-s" set res=1
		if "%~1"=="--src" set res=1
		if defined res (
			set SRC=%2 & set res=
			shift
		)

		if "%~1"=="-d" set res=1
		if "%~1"=="--dist" set res=1
		if defined res (
			set DIST=%2 & set res=
			shift
		)

		if "%~1"=="-h" set res=1
		if "%~1"=="--help" set res=1
		if defined res (
			goto :help
		)

		shift
		goto :getopts
	)

:checkopts
if /i "%DATA%" equ "d" if /i "%SRC%" neq "" (
	echo "%SRC% is not folder."
	exit /b
)

if not exist "%DIST%" (
	echo "Create distination directory!"
	mkdir %DIST%
)

echo "Make transfer batchs!"
for /f %%F in ('dir "%SRC%\*" /A:-D /B') do (
	echo !BASE_TEXT:COMMAND=%%F! > %DIST%%%F.bat
)
echo "Done!"

goto :eof

:help
	echo.
    echo usage: bootstrap -s "\\wsl.localhost\Ubuntu\usr\bin\" -d "bin\"
    echo.
    echo    -s, --src       the wsl command path
    echo    -d, --dist      dist dir
    echo    -h, --help      display the help
