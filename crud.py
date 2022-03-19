"""CRUD operations"""

from model import User, Character, Spell, Slot, Day, PlayerClass, SpellKnown, connect_to_db, db
from datetime import datetime

from slot_rules import slot_rules


#----------------------------------------managing users

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





#----------------------------------------managing characters

def create_character(name, level):
    """Create and return a Character object"""

    new_character = Character(character_name=name, character_level=level, created_date=datetime.now())
    return new_character

def get_character_by_id(char_id):
    """Retrieves Character object from the db with given id"""

    return Character.query.get(char_id)

def get_characters_by_user_id(id):
    """Returns list of characters belonging to the user by id"""

    return get_user_by_id(id).characters

def level_character_up_by_id(char_id):
    """Takes in a character id and increments the level by one"""

    char = get_character_by_id(char_id)
    char.character_level += 1

def get_slot_details_by_level_and_class(player_level, player_class):
    """Returns slot details by caster level and class"""

    return slot_rules[player_class][player_level]


#----------------------------------------managing classes

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




#----------------------------------------managing spells

def create_spell(slug, name):
    """Create and return a Spell object - initial data pop"""

    new_spell = Spell(spell_slug=slug, spell_name=name)
    return new_spell

def get_all_spells():
    """Queries db for all 321 spells"""

    return Spell.query.all()

def get_spell_by_slug(slug):
    """Queries db for Spell obj with matching slug"""

    return Spell.query.filter(Spell.spell_slug == slug).first()

def get_spell_id_by_slug(slug):
    """Queries db for Spell obj with matching slug and returns id"""

    return Spell.query.filter(Spell.spell_slug == slug).first().spell_type_id




#----------------------------------------managing spells known

def create_spell_known(slug):
    """Creates and returns new spell known"""

    spell = get_spell_id_by_slug(slug)
    spell_known = SpellKnown(spell_id=spell)

    return spell_known
    
def get_spells_known_by_character_id(char_id):
    """Queries db for SpellKnown obj with matching char_id and returns list"""

    return Character.query.get(char_id).spells_known

def get_spell_name_by_spell_known(spell_known_id):
    """Joins SpellKnown and Spell objs and returns Spell.spell_name"""

    return SpellKnown.query.get(spell_known_id).spells.spell_name




#create day
#create slot



#initial seed

if __name__ == '__main__':
    from server import app
    connect_to_db(app)