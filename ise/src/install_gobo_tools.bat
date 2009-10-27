setlocal
chdir ..
chdir ..
set PATH=%cd%\ise\src\bin;%PATH%

geant install

chdir ise\override
call git_update_generated.py

endlocal
