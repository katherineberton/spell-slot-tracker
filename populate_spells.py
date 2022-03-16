import requests
from flask import Flask, request, session
from flask_sqlalchemy import SQLAlchemy

from model import connect_to_db, db
import crud
from server import app

spell_objs = []


#get spells from 1st page, add to list, no query string

spells_1_data = requests.get("https://api.open5e.com/spells/").json()
spells_1_info = spells_1_data["results"]

for item in spells_1_info:
    new_spell = crud.create_spell(item["slug"], item["name"])
    spell_objs.append(new_spell)


#get spells from pages 2 through 8, add to list, query string

for num in range(2,8):
    spells_data_dynamic = requests.get(f"https://api.open5e.com/spells/?page={num}").json()
    spells_info_dynamic = spells_data_dynamic["results"]
    
    for item in spells_info_dynamic:
        new_spell = crud.create_spell(item["slug"], item["name"])
        spell_objs.append(new_spell)

if __name__ == '__main__':
    connect_to_db(app)