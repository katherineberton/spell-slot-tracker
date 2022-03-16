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
    character_name = db.Column(db.String(50),
                               nullable=False)
    created_date = db.Column(db.DateTime)

    def __repr__(self):
        return f'<Character obj id={self.character_id} name={self.character_name}>'



class PlayerClass(db.Model):
    """One player class - details from API"""

    __tablename__ = 'classes'

    class_id = db.Column(db.Integer,
                         autoincrement=True,
                         primary_key=True)
    class_slug = db.Column(db.String(50),
                           nullable=False)
    class_name = db.Column(db.String(50))

    def __repr__(self):
        return f'<PlayerClass obj id={self.class_id} slug={self.class_slug}>'



class Spell(db.Model):
    """One spell - details from API"""

    __tablename__ = 'spells'

    spell_type_id = db.Column(db.Integer,
                              autoincrement=True,
                              primary_key=True)
    spell_slug = db.Column(db.String(100),
                           nullable=False)
    spell_name = db.Column(db.String(100))

    def __repr__(self):
        return f'<Spell obj id={self.spell_id} slug={self.spell_slug}>' 



class Slot(db.Model):
    """One spell slot used"""

    __tablename__ = 'slots'

    slot_id = db.Column(db.Integer,
                        autoincrement=True,
                        primary_key=True)
    slot_reference = db.Column(db.String(300))
    spell_type_id = db.Column(db.Integer,
                              db.ForeignKey("spells.spell_type_id"))
    day_id = db.Column(db.Integer,
                       db.ForeignKey("days.day_id"))
    character_id = db.Column(db.Integer,
                             db.ForeignKey("characters.character_id"))
    slot_level = db.Column(db.Integer,
                           nullable=False)

    def __repr__(self):
        return f'<Slot obj id={self.slot_id}>'



class Day(db.Model):
    """A spellcasting day"""

    __tablename__ = 'days'

    day_id = db.Column(db.Integer,
                       autoincrement=True,
                       primary_key=True)
    day_reference = db.Column(db.String(100))
    first_session_date = db.Column(db.DateTime)





def connect_to_db(app, db_name="spell_slot_tracker_db"):
    """Connect to database."""

    app.config["SQLALCHEMY_DATABASE_URI"] = f"postgresql:///{db_name}"
    app.config["SQLALCHEMY_ECHO"] = True
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.app = app
    db.init_app(app)


if __name__ == '__main__':
    from server import app

    connect_to_db(app)