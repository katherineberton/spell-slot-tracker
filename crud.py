"""CRUD operations"""

from model import db, User, Character, Spell, Slot, Day, PlayerClass, connect_to_db
from server import app

def create_class(slug, name):
    """Create and return a class - initial data pop"""

    new_class = PlayerClass(class_slug=slug, class_name=name)
    return new_class


def create_spell(slug, name):
    """Create and return a class - initial data pop"""

    new_spell = Spell(spell_slug=slug, spell_name=name)
    return new_spell