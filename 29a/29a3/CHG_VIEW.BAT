@ECHO OFF
ECHO Exchanging viewer for 29A Magazine issue 3.
COPY 29A#3.1_8 VIEWER\29A#3.BAK > NUL
COPY 29A#3.EXE VIEWER\29A#3_.BAK > NUL
COPY 29ADATA2.DAT VIEWER\29ADATA2.BAK > NUL

COPY VIEWER\29A#3.1_8 . > NUL
COPY VIEWER\29A#3.EXE . > NUL
COPY VIEWER\29ADATA2.DAT . > NUL

COPY VIEWER\29A#3.BAK VIEWER\29A#3.1_8 > NUL
COPY VIEWER\29A#3_.BAK VIEWER\29A#3.EXE > NUL
COPY VIEWER\29ADATA2.BAK VIEWER\29ADATA2.DAT > NUL

DEL VIEWER\*.BAK
