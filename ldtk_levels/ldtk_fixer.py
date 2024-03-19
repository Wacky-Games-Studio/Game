#!/bin/python
import re
import uuid
import os

GUID_REGEX = r"[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
GAME_WORLD_PATH = "GameWorld.ldtk"
LEVEL_PATH = "./GameWorld/"

guid_look_up_table = {}

def get_guid(guid):
    if not guid in guid_look_up_table:
        new_guid = uuid.uuid1()
        guid_look_up_table[guid] = new_guid
        return new_guid
    
    return guid_look_up_table[guid]


def replace_guid_in_file(file_path):
    print("replacing =>", file_path)
    content = ""

    with open(file_path, 'r') as file:
        content = file.read()

    guids = re.findall(GUID_REGEX, content)

    for guid in guids:
        new_guid = get_guid(guid)
        content = content.replace(guid, str(new_guid))

    with open(file_path, 'w') as file:
        file.write(content)

replace_guid_in_file(GAME_WORLD_PATH)
levels = os.listdir(LEVEL_PATH)

for level in levels:
    replace_guid_in_file(LEVEL_PATH + level)