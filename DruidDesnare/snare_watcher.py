from stuff import delay
from stuff import Screen
from stuff import Keyboard
from stuff import any_match
MAIN = __name__ == "__main__"

delay(5)
screen = Screen()
keyboard = Keyboard()
TRIGGERS = ("rooted", "snared")

def Clear():
    # 0.4ms to execute
    keyboard.type('/clr')
    keyboard.press('enter')

def RecastShapeshift():
    # 1.4ms to execute
    keyboard.press('f')
    keyboard.press('f')

def Loop():
    # 130ms to execute
    chat = screen.read_chat()
    for line in chat:
        if any_match(TRIGGERS, line):
            Clear()
            RecastShapeshift()
            return


if MAIN:
    while True:
        Loop()
