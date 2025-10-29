set "newPath=E:\Python\BehaveBDD\Python312\Scripts;%PATH%"
setx PATH "%newPath%" /M
set "newPath=E:\Python\BehaveBDD\Python312;%PATH%"
setx PATH "%newPath%" /M
cd /d "E:\Python\BehaveBDD\Python312\behave-main"
python setup.py install
cd /d "E:\Python\BehaveBDD\Python312\Scripts\behave-html-formatter-main"
python setup.py install
pause