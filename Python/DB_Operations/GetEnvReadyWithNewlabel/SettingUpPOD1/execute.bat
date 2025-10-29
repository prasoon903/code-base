echo. > all_outputs.txt
for %%G in (*.sql) do (
    echo -- Output of %%G -- >> all_outputs.txt
    sqlcmd /S BPLDEVDB01 /d PP_CI -E -i"%%G" >> all_outputs.txt
)
pause