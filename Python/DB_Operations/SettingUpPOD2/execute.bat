for %%G in (*.sql) do sqlcmd /S BPLDEVDB01 /d master -E -i"%%G" -o out.txt
pause