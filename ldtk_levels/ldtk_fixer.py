#!/bin/python3
import re
import math

print("What do you want to do?")
print("1. Work as Anton")
print("2. Work as Filip")
print("3. Work as Sebbe")
print("4. Commit")

try:
    choice = int(input("> "))
except:
    print("Write an integer!")
    exit(1)

ANTON_NUM = 2000
FILIP_NUM = 3000
SEBBE_NUM = 4000
COMMIT_NUM = 5000
num = 0

def save_current_num():
    with open("GameWorld.ldtk", "r") as GameWorld:
        content = GameWorld.read()
    REGEX = r"\"nextUid\":\s*(\d+)"
    content = re.findall(REGEX, content)
    current_num = math.floor(int(content[0]) / 1000)
    print(f"Current number is: {current_num}")

    with open(str("id_" + str(current_num) + "000.notouchy"), "w") as file:
        file.write(str(int(content[0])))

def read_prev_num(index):
    with open("id_" + str(index) + ".notouchy", "r") as file:
        content = file.read()
    
    if content == "":
        return index
    
    return int(content)


if choice == 1:
    num = read_prev_num(ANTON_NUM)
elif choice == 2:
    num = read_prev_num(FILIP_NUM)
elif choice == 3:
    num = read_prev_num(SEBBE_NUM)
elif choice == 4:
    num = COMMIT_NUM
    save_current_num()
else:
    print("Not a valid number!")
    exit(1)

with open("GameWorld.ldtk", "r") as GameWorld:
    content = GameWorld.read()

REGEX = r"\"nextUid\":\s*(\d+)"
content = re.sub(REGEX, f"\"nextUid\": {num}", content)

with open("GameWorld.ldtk", "w") as GameWorld:
    GameWorld.write(content)
    print("wrote to file... closing it")

input("Press enter to exit...")