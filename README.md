### Project description:

Spell Slot Tracker is a full stack webapp for Dungeons and Dragons Fifth Edition casters to say goodbye to messy pencil and eraser marks on their character sheets, and track their spell slots online.

It has been deployed on Amazon Web Services! Play it without cloning the repo locally here: http://34.214.175.155/
Learn more about the developer here: https://www.linkedin.com/in/katherine-berton/

### Features:
The spell slot tracker allows users to create multiple characters with class and level, add known cantrips, level up, update character details, and play! It shows the character's slots for the day with buttons - clickable if the slots are available and disabled if they are used, with inner text describing what they were used for (spells or abilities like a paladin's smite). It supports multi-session in game days and allows user to log out and pick up right where they left off last session. Wizards and sorcerers can use arcane recovery and sorcery points respectively to regain slots, and warlocks can regain slots on a short rest. Users can also browse spells by class and read official, long-form descriptions, and see facts sheets about their characters' favorite spells to cast and upcast.

## Tech stack:
Python3, PostgreSQL, SQLAlchemy, Flask, Jinja2, JavaScript, AJAX/JSON, React, HTML/CSS, Bootstrap, React-Bootstrap
## API used:
Open5E (https://api.open5e.com/)
Specific library dependencies are listed in requirements.txt.

### Structure

server.py - core of the flask app, lists all routes.
model.py - describes the tables in the database using SQLAlchemy for object-relational mapping
crud.py - contains functions to carry out any database queries
slot_rules.py - amasses information from the .csv files in the data/ folder into nested dictionaries that describe the slot rules for each class and level

## Administrative files

to-do-list.txt - features to be implemented
seed_classes.py and seed_spells.py - retrieves basic details from the Open5e API for insertion into the database. This allows quicker back end operations, storage of spells known, and database queries to be done on spells and classes without having to implement logic on the client side in asynchronous fetches. More detail is still available in the API, and used on the browse spells section.
nginx.conf and flask.service - configuration files for deployment
tracker_db.sql - copy of database for deployment