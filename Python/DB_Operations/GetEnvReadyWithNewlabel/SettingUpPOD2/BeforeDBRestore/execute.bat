for %%G in (*.sql) do sqlcmd /S BPLDEVDB01 /d PP_POD2_CI -E -i"%%G" -o out.txt
pause