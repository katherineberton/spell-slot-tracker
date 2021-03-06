from crypt import methods
from os import environ
from flask import Flask, render_template, request, flash, session, redirect, jsonify
from flask_sqlalchemy import SQLAlchemy

from model import connect_to_db, db
import crud

app = Flask(__name__)
app.secret_key = environ['KEY']


#------------------------------------------------------------------setup


@app.route('/')
def show_homepage():
    """Shows homepage that prompts for login creds"""

    #if user's already logged in, go to landing page
    if 'user_id' in session:
        return redirect('/landing')
    
    return render_template('homepage.html')



@app.route('/login', methods=["POST"])
def log_user_in():
    """Handles login attempts.
    
    If user email exists and password matches, add user id and obj to session and render "landing" template.
    If user email exists but password does not match, redirect to home, prompt try again.
    If user email does not exist, redirect to register page.

    """

    login_email = request.form.get("email")
    login_password = request.form.get("password")

    #if a user with this email address exists:
    if crud.get_user_by_email(login_email):

        #assign variable name user to the User obj with the associated email address
        user = crud.get_user_by_email(login_email)

        #if password matches:
        if login_password == user.password:
            #add user to session, flash success, and go to landing.
            session['user_id'] = user.user_id
            flash(f'Welcome back, {user.name}!')
            return redirect('/landing')
        #if password does not match:
        else:
            flash('That password does not match our records for this email address.')
            flash('Please try again.')
            return redirect('/')
    
    #if a user with this email address does not exist:
    else:
        flash('We do not have an account with this email address.')
        flash('Please register here.')
        return redirect('/register')



@app.route('/logout')
def log_user_out():
    """Logs out and redirects to homepage"""

    session.pop('user_id')
    flash('You lived to adventure another day!')

    return redirect('/')



@app.route('/register')
def register():
    """Shows registration page"""
    
    return render_template('register.html')



@app.route('/new-user-registration', methods=["POST"])
def handle_new_user():
    """Creates new user"""

    user_name = request.form.get("new-user-name")
    user_email = request.form.get("new-user-email")
    user_password = request.form.get("new-user-password")

    new_user = crud.create_user(name=user_name, email=user_email, password=user_password)
    db.session.add(new_user)
    db.session.commit()

    flash("You have successfully created an account! Please log in.")
    return redirect('/')



@app.route('/landing')
def show_landing():
    """Shows landing page listing user's characters"""

    characters = crud.get_characters_by_user_id(session['user_id'])
    cantrip_options = crud.get_all_cantrips()

    return render_template('landing.html', char_list=characters, cantrip_options=cantrip_options)



@app.route('/list-characters')
def list_characters():
    """Info for React character card components"""
    
    characters = [character.to_dict() for character in crud.get_characters_by_user_id(session['user_id'])]

    return jsonify(characters)



@app.route('/new-char-registration', methods=["POST"])
def handle_new_character():
    """Creates new character"""

    new_char_name = request.form.get('char-name')
    slug = request.form.get('char-class')
    new_char_level = request.form.get('char-level')

    new_char = crud.create_character(name=new_char_name, level=new_char_level)

    #get class object from slug and append to its list of Character objs
    chosen_class = crud.get_class_by_slug(slug)
    chosen_class.characters.append(new_char)

    #get user object from user_id in session and append to its list of Character objs
    curr_user = crud.get_user_by_id(session['user_id'])
    curr_user.characters.append(new_char) #this gives it a character ID

    #create a new casting day for new_char and add to db
    db.session.add(crud.create_day(new_char.character_id))

    #populates slots for the new day
    db.session.add_all(crud.populate_slots(new_char.character_id))

    db.session.commit()

    return redirect('/landing')

    

@app.route('/update-character/<char_id>')
def update_character(char_id):
    """Prompts user for updated character information"""

    char = crud.get_character_by_id(char_id)

    return render_template('update_character.html', char=char)



@app.route('/handle-character-update/<char_id>', methods=["POST"])
def handle_character_update(char_id):
    """Updates character in db"""
    
    char = crud.get_character_by_id(char_id)

    multi = request.form.get('multiclassing')
    caster_level = request.form.get('char-level')

    if multi:
        crud.char_multiclass(char_id)

    char.character_level = caster_level
    
    db.session.commit()

    return redirect('/landing')



@app.route('/level-up/<char_id>')
def increase_char_level(char_id):
    """Increase character level"""

    crud.level_character_up_by_id(char_id)
    db.session.commit()

    return redirect('/landing')



@app.route('/delete-spell-known/<char_id>')
def delete_spell_known(char_id):

    spell_slug = request.args.get('spell_to_delete')
    crud.delete_spell_known(char_id=char_id, spell_slug=spell_slug)

    db.session.commit()
    
    return redirect('/landing')



@app.route('/handle-add-spell/<char_id>', methods=['POST'])
def handle_add_spell(char_id):
    """Adds wanted spell to character's spell list"""

    #retrieve slug from form
    slug = request.form.get('cantrip-to-add')

    #retrieve spell obj from slug
    new_spell = crud.get_spell_by_slug(slug)

    #retrieve character from url
    char = crud.get_character_by_id(char_id)

    #append spell known to char's spells_known list
    char.spells.append(new_spell)

    db.session.commit()

    return redirect('/landing')



@app.route('/browse-<player_class>-spells')
def browse_spells(player_class):
    """Renders template to browse class specific spells"""

    return render_template(f'browse_spells.html')



@app.route('/facts-sheet')
def show_facts_sheet():
    """Renders template to show facts sheet"""

    return render_template('facts_sheet.html')

@app.route('/info-sheet')
def show_info_sheet():
    """Shows info and FAQs"""

    return render_template('info_sheet.html')

        
#------------------------------------------------------------------tracker


@app.route('/play/<char_id>')
def show_play_screen(char_id):
    """Shows the tracker page"""

    char = crud.get_character_by_id(char_id)
    char_class = char.player_class.class_slug
    spell_options = crud.get_all_spells_no_cantrips()
    slot_details = crud.get_slot_details(char_id)
    spells_known = [spell.spell_slug for spell in crud.get_spell_objs_known(char_id)]
    slots_used_today = crud.get_slots_used_today_by_char(char_id)

    return render_template('tracker.html',
                            char=char,
                            spell_options=spell_options,
                            slot_details=slot_details,
                            slots_used_today=slots_used_today,
                            char_class=char_class)



@app.route('/handle-long-rest/<char_id>')
def handle_long_rest(char_id):
    """Creates new Day record, creates Slot records on that day"""

    db.session.add(crud.create_day(char_id))
    db.session.commit()

    db.session.add_all(crud.populate_slots(char_id))
    db.session.commit()
    
    return redirect(f'/play/{char_id}')



@app.route('/handle-short-rest/<char_id>')
def handle_short_rest(char_id):
    """WARLOCKS ONLY
    Creates more Slot records on the current day, does not create new day"""

    db.session.add_all(crud.populate_slots(char_id))
    db.session.commit()

    return redirect(f'/play/{char_id}')



@app.route('/handle-add-slot/<char_id>', methods=['POST'])
def handle_arcane_recovery(char_id):
    """WIZARDS AND SORCERERS ONLY
    Creates one slot on the current day"""

    level = request.json.get('slotLevel')

    db.session.add(crud.create_a_slot(char_id, level))
    db.session.commit()

    return redirect(f'/play/{char_id}')



#------------------------------------------------db stuff for fetch requests


@app.route('/current-slot-rules/<char_id>')
def get_current_slot_rules(char_id):
    """Gets slot details by character's class and level"""

    return jsonify(crud.get_slot_details(char_id))



@app.route('/list-spells-known-2/<char_id>')
def list_spells_known_2(char_id):
    """Returns list of spells known by a character"""

    cantrips = [spell.to_dict() for spell in crud.get_spell_objs_known(char_id)]

    return jsonify(cantrips)



@app.route('/cast-cantrip/<char_id>')
def handle_cast_cantrip(char_id):
    """Adds a cantrip to the db under the given character"""

    slug = request.args.get('spell-slug')

    cantrip = crud.cast_cantrip(char_id=char_id, spell_slug=slug)

    db.session.add(cantrip)
    db.session.commit()

    return 'success'



@app.route('/handle-use-slot/<char_id>', methods=["POST"])
def handle_use_slot(char_id):

    spell_cast = request.json.get("spellCast")
    spell_level = request.json.get("slotLevel")
    user_note = request.json.get("note")
    
    #if this slot not used for a spell
    if spell_cast == "other":

        #use slot with no spell, user note
        crud.use_slot(char_id=char_id, level=spell_level, user_note=user_note)
    
    #if it was used for a spell 
    else:

        #retrieve id from spell slug and use slot with that spell
        spell_cast_id = crud.get_spell_id_by_slug(spell_cast)
        crud.use_slot(char_id=char_id,
                      level=spell_level,
                      spell_id=spell_cast_id,
                      user_note=user_note)

    db.session.commit()

    return 'success'



@app.route('/get-all-slots/<char_id>')
def get_all_slots(char_id):
    """Returns list of all Slot objects"""

    return jsonify(crud.get_all_slots_today(char_id))



@app.route('/get-<player_class>-spells')
def display_spells_browsing(player_class):
    """Returns spells by class if a class is specified"""

    if player_class == 'all':
        return jsonify([spell.to_dict() for spell in crud.get_all_spells()])
    else:
        return jsonify([spell.to_dict() for spell in crud.get_spells_by_class(player_class)])



@app.route('/get-user-fav-spell')
def get_user_fav_spell():
    """Returns the user's most cast spell"""

    return jsonify(list(crud.get_user_favorite_spell(session['user_id'])))
        



@app.route('/list-characters-fact-sheet')
def list_characters_fact_sheet():
    """Info for fact sheet so as to do only one fetch request for each char card"""
    
    characters = [character.to_dict() for character in crud.get_characters_by_user_id(session['user_id'])]

    for character in characters:
        id = character['character_id']

        character['num_days'] = crud.count_num_days(id)
        character['fav_spell'] = list(crud.get_char_favorite_spell(id))
        character['fav_upcast_spell'] = list(crud.get_char_favorite_upcast_spell(id))
        character['fav_spell_each_level'] = crud.get_char_fav_spell_all_levels(id)
        character['spell_level_count'] = crud.count_char_spells_cast_all_levels(id)
    
    return jsonify(characters)



if __name__ == '__main__':
    connect_to_db(app)

    app.run(debug=True, host='0.0.0.0')