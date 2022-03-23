"""CRUD operations"""

from model import User, Character, Spell, Slot, Day, PlayerClass, connect_to_db, db
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

def delete_spell_known(char_id, spell_slug):
    """Queries db for Character matching char_id and deletes spell matching spell_type_id"""

    char = get_character_by_id(char_id)
    spell = get_spell_by_slug(spell_slug)

    char.spells.remove(spell)

def get_spells_known(char_id):
    """Queries db for Spell objs associated with Character matching char_id
    
    Returns a list of each spell's slug"""

    spell_slugs = [spell.spell_slug for spell in Character.query.get(char_id).spells]

    return spell_slugs



#---------------------------------------managing days

def create_day(char_id):
    """Creates and returns a Day object"""

    new_day = Day(character_id=char_id, first_session_date=datetime.now())

    return new_day

def get_current_day(char_id):
    """Gets the id of the most recent Day record by character id"""

    curr_day = Day.query.filter_by(character_id=char_id).order_by(Day.day_id).first()
    
    return curr_day.day_id



#---------------------------------------managing slots

def get_slot_details(char_id):
    """Returns slot details by caster level and class slug"""

    char = get_character_by_id(char_id)

    char_class = get_class_by_id(char.class_id).class_slug
    char_level = char.character_level

    return slot_rules[char_class][str(char_level)]

def create_a_slot(char_id, level):
    """Creates and returns one slot for the character with given id and slot level"""

    char_current_day = get_current_day(char_id)
    slot_used = Slot(character_id=char_id, day_id=char_current_day, slot_level=level)

    return slot_used

def populate_slots(char_id):
    """Prepopulates slots on creation of a new day to be updated by casting of a spell"""
    
    char = get_character_by_id(char_id)
    char_class = get_class_by_id(char.class_id).class_slug
    char_level = char.character_level

    #at each casting level, 1 through 9
    for i in range(1,10):

        #retrieve the total number of slots from slot_rules
        num_slots = get_slot_details(player_class=char_class, player_level=char_level)[f'max_slots_{i}']

        #create that many blank slots at that level
        for j in range(num_slots):
            create_a_slot(char_id=char_id, level=i)

def get_highest_slot(char_id):
    """Gets highest level slot of available slots"""
    #make this later
    pass

def get_slot(char_id, level):
    """Queries db for first empty Slot object with matching character id and day id at the specified level"""

    char_current_day = get_current_day(char_id).day_id

    return Slot.query.filtered_by(Slot.day_id == char_current_day,
                                  Slot.character_id == char_id,
                                  Slot.slot_level == level,
                                  Slot.spell_type_id is None).first()

def use_slot(char_id, level, spell_id, user_note=None):
    """Updates latest Slot object by inserting spell_type_id foreign key"""

    #retrieves slot object
    slot_obj = get_slot(char_id=char_id, level=level)
    
    #assigns given var spell_id to spell_type_id attribute of retrieved slot
    slot_obj.spell_type_id = spell_id
    slot_obj.slot_reference = user_note

def cast_cantrip(char_id, spell_slug):
    """Creates, updates and returns a Slot object"""

    record = create_a_slot(char_id, 0)
    record.spell_type_id = get_spell_id_by_slug(spell_slug)
    record.day_id = get_current_day(char_id)

    return record


if __name__ == '__main__':
    from server import app
    connect_to_db(app)