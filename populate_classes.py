import requests
from flask import Flask, request, session
from flask_sqlalchemy import SQLAlchemy

from model import connect_to_db, db
import crud
from server import app

class_data = requests.get("https://api.open5e.com/classes/").json()

class_list = class_data["results"]

def populate_classes():
    for item in class_list:
        class_info = crud.create_class(item["slug"], item["name"])
        db.session.add(class_info)
    db.session.commit()

if __name__ == '__main__':
    connect_to_db(app)