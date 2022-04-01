from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Integer

db=SQLAlchemy()


class User(db.Model):
    """One user"""

    __tablename__ = 'users'

    user_id = db.Column(db.Integer,
                        autoincrement=True,
                        primary_key=True)
    email = db.Column(db.String(50),
                      nullable=False)
    password = db.Column(db.String(50),
                         nullable=False)
    created_date = db.Column(db.DateTime)
    name = db.Column(db.String(100),
                     nullable=False)

    # characters = a list of Character objects this user has
    # [character].slots = a list of Slot objects this user has used

    def __repr__(self):
        return f'<User obj id={self.user_id} name={self.name} email={self.email}>'



class Character(db.Model):
    """One player character belonging to a user"""

    __tablename__ = 'characters'

    character_id = db.Column(db.Integer,
                             autoincrement=True,
                             primary_key=True)
    user_id = db.Column(db.Integer,
                        db.ForeignKey("users.user_id"))
    class_id = db.Column(db.Integer,
                         db.ForeignKey("classes.class_id"))
    character_level = db.Column(db.Integer)
    character_name = db.Column(db.String(50),
                               nullable=False)
    created_date = db.Column(db.DateTime)

    user = db.relationship('User', backref='characters')
    player_class = db.relationship('PlayerClass', backref='characters')

    spells = db.relationship("Spell", secondary="characters_spells", backref="characters")

    #slots = a list of Slot objects used by this character
    #days = a list of Day objects this character has created
    #spells_known = a list of SpellKnown objects this character knows

    def __repr__(self):
        return f'<Character obj id={self.character_id} name={self.character_name}>'



class Spell(db.Model):
    """One spell - details from API"""

    __tablename__ = 'spells'

    spell_type_id = db.Column(db.Integer,
                              autoincrement=True,
                              primary_key=True)
    spell_slug = db.Column(db.String(100),
                           nullable=False)
    spell_name = db.Column(db.String(100))
    spell_level = db.Column(db.Integer)

    def __repr__(self):
        return f'<Spell obj id={self.spell_type_id} slug={self.spell_slug}>' 



class CharacterSpell(db.Model):
    """Spell known by a character (secondary/association table)"""

    __tablename__ = 'characters_spells'

    character_spell_id = db.Column(db.Integer, primary_key=True)
    character_id = db.Column(db.Integer, db.ForeignKey('characters.character_id'), nullable=False)
    spell_id = db.Column(db.Integer, db.ForeignKey('spells.spell_type_id'), nullable=False)



class PlayerClass(db.Model):
    """One player class - details from API"""

    __tablename__ = 'classes'

    class_id = db.Column(db.Integer,
                         autoincrement=True,
                         primary_key=True)
    class_slug = db.Column(db.String(50),
                           nullable=False)
    class_name = db.Column(db.String(50))

    #characters = a list of Character objects of this class

    def __repr__(self):
        return f'<PlayerClass obj id={self.class_id} slug={self.class_slug}>'



class Slot(db.Model):
    """One spell slot used
    
    These will be pre-generated when a user creates a new Day object, pursuant to character level and class constraints"""

    __tablename__ = 'slots'

    slot_id = db.Column(db.Integer,
                        autoincrement=True,
                        primary_key=True)
    slot_reference = db.Column(db.String(300)) #user input
    spell_type_id = db.Column(db.Integer,
                              db.ForeignKey("spells.spell_type_id"))
    day_id = db.Column(db.Integer,
                       db.ForeignKey("days.day_id"))
    character_id = db.Column(db.Integer,
                             db.ForeignKey("characters.character_id"))
    slot_level = db.Column(db.Integer)

    day = db.relationship('Day', backref='slots')
    character = db.relationship('Character', backref='slots')

    def to_dict(self):

        return {
            'slot_id': self.slot_id,
            'slot_reference': self.slot_reference,
            'spell_type_id': self.spell_type_id,
            'day_id': self.day_id,
            'character_id': self.character_id,
            'slot_level': self.slot_level
        }

    def __repr__(self):
        return f'<Slot obj id={self.slot_id}>'



class Day(db.Model):
    """A spellcasting day"""

    __tablename__ = 'days'

    day_id = db.Column(db.Integer,
                       autoincrement=True,
                       primary_key=True)
    day_reference = db.Column(db.String(100)) #user input
    first_session_date = db.Column(db.DateTime) #not sure if i'm going to keep this
    character_id = db.Column(db.Integer,
                        db.ForeignKey("characters.character_id"))

    # slots = a list of Slot objects used on this day

    character = db.relationship('Character', backref='days')

    def __repr__(self):
        return f'<Day obj id={self.day_id}>'




def connect_to_db(app, db_name="spell_slot_tracker_db"):
    """Connect to database."""

    app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql:///{db_name}"
    app.config["SQLALCHEMY_ECHO"] = True #try turning this off
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.app = app
    db.init_app(app)


if __name__ == '__main__':
    from server import app

    connect_to_db(app)