"""CRUD operations"""

from model import User, Character, Spell, Slot, Day, PlayerClass, connect_to_db, db
from datetime import datetime


#managing users

def create_user(name, email, password):
    """Create and return a User object"""

    new_user = User(name=name, email=email, password=password, created_date=datetime.now())
    return new_user

def get_user_by_email(email_filter):
    """Queries db for User obj with matching email and returns obj"""

    return User.query.filter(User.email==email_filter).first()

def get_user_by_id(user_id):
    """Queries db for User obj with matching id and returns obj"""

    return User.query.get(user_id)


#managing characters

def create_character(name, level):
    """Create and return a Character object"""

    new_character = Character(character_name=name, character_level=level, created_date=datetime.now())
    return new_character

def get_characters_by_user_id(id):
    """Returns list of characters belonging to the user by id"""

    return get_user_by_id(id).characters


#managing classes

def create_class(slug, name):
    """Create and return a PlayerClass object - initial data pop"""

    new_class = PlayerClass(class_slug=slug, class_name=name)
    return new_class

def get_class_by_id(class_id):
    """Queries db for PlayerClass obj with matching id, returns it"""

    return PlayerClass.query.get(class_id)

def get_class_by_slug(slug):
    """Queries db for PlayerClass obj with matching slug, returns it"""

    return PlayerClass.query.filter(PlayerClass.class_slug == slug).first()

#create day
#create slot

#initial data population



def create_spell(slug, name):
    """Create and return a Spell object - initial data pop"""

    new_spell = Spell(spell_slug=slug, spell_name=name)
    return new_spell

if __name__ == '__main__':
    from server import app
    connect_to_db(app)