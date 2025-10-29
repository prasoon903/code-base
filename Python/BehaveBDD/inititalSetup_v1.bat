set "newPath=E:\Python\BehaveBDD\Python310\Scripts;%PATH%"
setx PATH "%newPath%" /M
cd /d "E:\Python\BehaveBDD\Python310\behave-main"
python setup.py install
cd /d "E:\Python\BehaveBDD\Python310\Scripts\behave-html-formatter-main"
python setup.py install
pause