"""CRUD operations"""

from model import User, Character, Spell, Slot, Day, PlayerClass, connect_to_db
from datetime import datetime



def create_user(name, email, password):
    """Create and return a User object"""

    new_user = User(name=name, email=email, password=password)
    return new_user

#need to define create character
#create day
#create slot

def create_day(name, email, password):
    """Create and return a User object"""

    new_user = User(name=name, email=email, password=password)
    return new_user

#initial data population

def create_class(slug, name):
    """Create and return a PlayerClass object - initial data pop"""

    new_class = PlayerClass(class_slug=slug, class_name=name)
    return new_class


def create_spell(slug, name):
    """Create and return a Spell object - initial data pop"""

    new_spell = Spell(spell_slug=slug, spell_name=name)
    return new_spell

if __name__ == '__main__':
    from server import app
    connect_to_db(app)