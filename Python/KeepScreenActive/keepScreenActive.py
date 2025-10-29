import pyautogui
import time

def keep_screen_active(interval_seconds=60):
    try:
        while True:
            # Move the mouse cursor slightly to simulate activity
            pyautogui.moveRel(5, 0)  # Move 5 pixels to the right
            time.sleep(1)
            pyautogui.moveRel(-5, 0) # Move back to the left
            
            # Wait for the specified interval
            time.sleep(interval_seconds - 1)
    except KeyboardInterrupt:
        print("Screen activity program terminated.")

if __name__ == "__main__":
    keep_screen_active()
