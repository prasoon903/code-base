from pynput.keyboard import Key , Controller
import time

def SimulateTyping(Data):
    keyboard = Controller()
    for line in Data:
        textToWrite = line 
        for char in textToWrite:
            countEnterPressed = 0
            if char.isupper():
                with keyboard.pressed(Key.shift):
                    time.sleep(0.04)
                    keyboard.press(char.lower())
                    keyboard.release(char.lower())
                    time.sleep(0.04)
                    countEnterPressed = 0
            elif ( 
                char == '!' or 
                char == '@' or 
                char == '#' or 
                char == '$' or 
                char == '%' or 
                char == '^' or 
                char == '&' or 
                char == '*' or 
                char == '(' or
                char == ')' or 
                char == '_' or
                char == '+' or
                char == '{' or
                char == '}' or
                char == '|' or
                char == ':' or
                char == '"' or
                char == '<' or
                char == '>' or
                char == '?'  
                ) :
                with keyboard.pressed(Key.shift):
                    time.sleep(0.1)
                    keyboard.press(char)
                    time.sleep(0.1)
                    keyboard.release(char)
                countEnterPressed = 0
            elif countEnterPressed == 5:
                break
            elif char == '\n':
                with keyboard.pressed(Key.shift):
                    keyboard.press(Key.enter)
                    keyboard.release(Key.enter)
                countEnterPressed += 1
            else:
                keyboard.press(char)
                keyboard.release(char)
                countEnterPressed = 0
            time.sleep(0.05)

