@echo off
echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캠
echo � Making the "95-th Harrier" distribution kit            �
echo �                          (C) 13-Sep-1997y by TechnoRat �
echo 突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠
if '%1' == '' goto hint
copy 95scan.pas ..\95scan.pas
if errorlevel 1 goto err
%1\tpc ..\95scan.pas /m
if errorlevel 1 goto err
del ..\95scan.pas
if errorlevel 1 goto err
cd ..\asmswap
call make %1
cd ..\pelink
call make %1
cd ..\include
call make %1
cd ..\95th
call make %1
cd ..\main
del ..\monster.map
if errorlevel 1 goto err
del ..\monster.exe
if errorlevel 1 goto err
del ..\target.exe
if errorlevel 1 goto err
del ..\harrinfo.ini
if errorlevel 1 goto err
del ..\harrlogo.bmp
if errorlevel 1 goto err
del ..\harrinc.inc
if errorlevel 1 goto err
del ..\pelink.exe
if errorlevel 1 goto err
del ..\pelinks.def
if errorlevel 1 goto err
del ..\asmswap.exe
if errorlevel 1 goto err
del ..\incfile.exe
if errorlevel 1 goto err
..\95_run ..\wh95_r00.exe
del ..\95_run.exe
echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캠
echo �                     Completed OK!                      �
echo 突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠
goto ok

:err
echo Errors detected!!!
goto ok

:hint
echo USAGE: MAKE.BAT Path_To_Used_Tools
goto ok
:ok
