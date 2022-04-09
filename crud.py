"""CRUD operations"""

from ast import Index
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

    return sorted(get_user_by_id(id).characters, key=lambda x: x.character_name)

def level_character_up_by_id(char_id):
    """Takes in a character id and increments the level by one"""

    char = get_character_by_id(char_id)
    char.character_level += 1

def char_multiclass(char_id):
    """Changes character's class to multiclass"""

    char = get_character_by_id(char_id)
    char.class_id = get_class_id_by_slug('multiclass')



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

def get_class_id_by_slug(slug):
    """Queries db for PlayerClass obj with matching slug, returns it"""

    class_obj = PlayerClass.query.filter(PlayerClass.class_slug == slug).first()
    
    return class_obj.class_id



#----------------------------------------managing spells

def create_spell(slug, name, level, classes, ritual, concentration):
    """Create and return a Spell object - initial data pop"""

    new_spell = Spell(spell_slug=slug,
                      spell_name=name,
                      spell_level=level,
                      spell_classes=classes,
                      ritual=ritual,
                      concentration=concentration)
    return new_spell

def get_all_spells():
    """Queries db for all 321 spells"""

    return Spell.query.all()

def get_all_spells_no_cantrips():
    """Queries db for all spells where level > 0"""

    return Spell.query.filter(Spell.spell_level > 0).all()

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

def get_spell_objs_known(char_id):
    """Queries db for Spell objs associated with Character matching char_id
    
    Returns a list of each spell's slug"""

    return Character.query.get(char_id).spells

def get_all_cantrips():
    """Queries db for Spell objs where level = 1"""

    return Spell.query.filter(Spell.spell_level == 0)

def get_spells_by_class(player_class):

    return Spell.query.filter(Spell.spell_classes.contains(player_class)).all()


#---------------------------------------managing days

def create_day(char_id):
    """Creates and returns a Day object"""

    new_day = Day(character_id=char_id, first_session_date=datetime.now())

    return new_day

def get_current_day(char_id):
    """Gets the id of the most recent Day record by character id"""

    curr_day = Day.query.filter_by(character_id=char_id).order_by(Day.day_id.desc()).first()
    
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
    """Prepopulates and returns slots on creation of a new day
    
    No spell details at first - they will be updated when they are used.
    """
    blank_slots = []

    if Character.query.get(char_id).player_class.class_slug != 'warlock':
        #at each casting level, 1 through 9
        for i in range(1,10):

            #retrieve the total number of slots in a day from slot_rules
            num_slots = get_slot_details(char_id)[f'max_slots_{i}']

            #create that many blank slots at that level
            for j in range(num_slots):
                blank_slots.append(create_a_slot(char_id=char_id, level=i)) #automatically assigns day = current day
    else:
        #at max casting level, create curr number of slots
        max_level = get_slot_details(char_id)['max_level']
        total_slots = get_slot_details(char_id)['slots']

        for i in range(total_slots):
            blank_slots.append(create_a_slot(char_id=char_id, level=max_level))


    return blank_slots

def get_slot(char_id, level):
    """Queries db for first empty Slot object with matching character id and day id at the specified level"""

    char_current_day = get_current_day(char_id)

    return Slot.query.filter(Slot.day_id == char_current_day,
                                  Slot.slot_level == level,
                                  Slot.spell_type_id == None,
                                  Slot.slot_reference == None).first()

def use_slot(char_id, level, spell_id=None, user_note=None):
    """Updates latest unused Slot object by inserting spell_type_id foreign key"""

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

def get_slots_used_today_by_char(char_id):
    """Queries db for slots used in the character's current day"""

    char_current_day = get_current_day(char_id)

    slot_objs = Slot.query.filter(
                                Slot.day_id == char_current_day,
                                (Slot.spell_type_id != None) | (Slot.slot_reference != None)
                                ).all()
    
    slot_list = []

    for slot in slot_objs:
        if slot.spell_type_id:
            slot_list.append({
                'level': slot.slot_level,
                'spell_name': Spell.query.get(slot.spell_type_id).spell_name,
                'note': None
            })
        else:
            slot_list.append({
                'level': slot.slot_level,
                'spell_name': None,
                'note': slot.slot_reference
            })

    return slot_list

def get_all_slots_today(char_id):
    """Queries db and returns list of all slot objs for a character's current day"""

    # #retrieves char's current day
    curr_day = get_current_day(char_id)

    #list of dictionary objects from all slot objects matching current day
    all_slots_today = [slot.to_dict() for slot in Slot.query.filter(Slot.day_id == curr_day, Slot.slot_level > 0)]

    #on each dictionary, if there is a spell, add key spell_name
    for slot in all_slots_today:
        if slot['spell_type_id']:
            slot['spell_name'] = Spell.query.get(slot['spell_type_id']).spell_name

    return all_slots_today


#------------------------------------------------analytics

def get_max_slot(char_id):

    rules = get_slot_details(char_id)

    if get_character_by_id(char_id).player_class.class_slug != 'warlock':

        lst = []
        for key, value in rules.items():
            if value > 0 and key[-1] != 'n':
                lst.append(key[-1])

        return int(max(lst))

    else:
        return rules['max_level']



def get_char_favorite_spell(char_id):
    
    query = """SELECT spell_name, count(slot_id)
                    FROM slots
                    JOIN spells ON slots.spell_type_id = spells.spell_type_id
                    WHERE character_id = :character_id
                        AND slots.spell_type_id IS NOT NULL
                    GROUP BY slots.spell_type_id, spell_name
                    ORDER BY count(slot_id) DESC
                    LIMIT 1"""

    cursor = db.session.execute(query, {'character_id': char_id})
    
    try:
        return cursor.fetchall()[0]
    except IndexError:
        return []

def count_num_days(char_id):

    query = """SELECT count(day_id)
                FROM days
                WHERE character_id = :character_id
                GROUP BY day_id"""

    cursor=db.session.execute(query, {'character_id': char_id})

    return len(cursor.fetchall())

def get_char_favorite_spell_by_level(char_id, target_level):

    query = """SELECT spell_name, count(slot_id)
                FROM slots
                JOIN spells ON spells.spell_type_id = slots.spell_type_id
                WHERE character_id = :character_id
                    AND slots.spell_type_id IS NOT NULL
                    AND slot_level = :level 
                GROUP BY spell_name
                ORDER BY count(slot_id) DESC
                LIMIT 1"""

    cursor=db.session.execute(query, {'character_id': char_id, 'level': target_level})

    try:
        return cursor.fetchall()[0]
    except IndexError:
        return []

def get_char_fav_spell_all_levels(char_id):

    faves = {}

    for i in range(1, get_max_slot(char_id) + 1):
        faves[i] = list(get_char_favorite_spell_by_level(char_id, i))

    return faves

def count_char_spells_cast_all_levels(char_id):

    query = """SELECT slot_level, count(slot_id)
                FROM slots
                WHERE character_id = :character_id
                    AND spell_type_id IS NOT NULL
                GROUP BY slot_level
                ORDER BY slot_level"""

    cursor=db.session.execute(query, {'character_id': char_id}).fetchall()

    return [[row[0], row[1]] for row in cursor]

def is_spell_upcast(slot_id):

    query = """SELECT spell_level, slot_level
                FROM slots
                JOIN spells ON slots.spell_type_id = spells.spell_type_id
                WHERE slot_id = :slot"""

    cursor=db.session.execute(query, {'slot': slot_id}).fetchall()

    return cursor[0][0] < cursor[0][1]

def get_char_upcast_spells(char_id):

    query = """SELECT slot_id, spell_name, spell_level, slot_level
                FROM slots
                JOIN spells ON spells.spell_type_id = slots.spell_type_id
                WHERE character_id = :character_id
                    AND slots.spell_type_id IS NOT NULL
                    AND spell_level < slot_level"""
    
    cursor=db.session.execute(query, {'character_id': char_id})

    print(cursor.fetchall())

def get_char_favorite_upcast_spell(char_id):
    
    query = """SELECT spell_name, count(slot_id)
                    FROM slots
                    JOIN spells ON slots.spell_type_id = spells.spell_type_id
                    WHERE character_id = :character_id
                        AND slots.spell_type_id IS NOT NULL
                        AND slots.slot_level > spells.spell_level
                    GROUP BY slots.spell_type_id, spell_name
                    ORDER BY count(slot_id) DESC
                    LIMIT 1"""

    cursor = db.session.execute(query, {'character_id': char_id})
    
    try:
        return cursor.fetchall()[0]
    except IndexError:
        return []

def get_user_favorite_spell(user_id):

    query = """SELECT name, character_name, spell_name, count(slot_id)
                FROM slots
                JOIN characters ON characters.character_id = slots.character_id
                JOIN users ON characters.user_id = users.user_id
                JOIN spells ON spells.spell_type_id = slots.spell_type_id
                WHERE users.user_id = :user
                GROUP BY spells.spell_name, characters.character_name, users.name
                ORDER BY count(slot_id) DESC
                LIMIT 1"""

    cursor=db.session.execute(query, {'user': user_id})

    try:
        return cursor.fetchall()[0]
    except IndexError:
        return []



if __name__ == '__main__':
    from server import app
    connect_to_db(app)