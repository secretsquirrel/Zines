@echo off
echo Compiling [$UPD�2.2] based virii demo ...
tasm $updviri.asm /m
tlink $updviri.obj $upd22.obj, $updviri.com /x /t
del $updviri.obj