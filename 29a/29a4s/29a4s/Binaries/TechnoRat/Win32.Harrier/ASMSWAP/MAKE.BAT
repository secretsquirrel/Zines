@echo off
echo 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캠
echo � Making the "ASM Swapper" v1.3 tool-kit                 �
echo �                          (C) 14-Aug-1997y by TechnoRat �
echo 突袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠
if '%1' == '' goto hint
copy asmswap.pas ..\asmswap.pas
if errorlevel 1 goto err
%1\tpc ..\asmswap.pas /m
if errorlevel 1 goto err
del ..\asmswap.pas
if errorlevel 1 goto err
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
