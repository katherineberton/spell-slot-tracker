from os import name
from flask import Flask, render_template, render_template_string, request, flash, session, redirect, jsonify
from flask_sqlalchemy import SQLAlchemy

from model import connect_to_db, db
import crud

app = Flask(__name__)
app.secret_key = "dev-mode"




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

    all_spells_known = {}

    for character in characters:
        #dictionary entry with key character id and value list of spells

        spells_known = crud.get_character_by_id(character.character_id).spells
        all_spells_known[character.character_id] = spells_known



    return render_template('landing.html', char_list=characters, spell_dict=all_spells_known)



@app.route(f'/create-a-character')
def get_character_details():

    return render_template('create_a_character.html')



@app.route('/new-char-registration', methods=["POST"])
def create_a_character():
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
    curr_user.characters.append(new_char)

    #create a new casting day for new_char and add to db
    db.session.add(crud.create_day(new_char.character_id))

    db.session.commit()

    return redirect('/landing')

    

@app.route('/level-up/<char_id>')
def increase_char_level(char_id):
    """Increase character level"""

    crud.level_character_up_by_id(char_id)
    db.session.commit()

    return redirect('/landing')



@app.route('/add-spell-known/<char_id>')
def add_spell_known(char_id):
    """Shows spell list"""
    #adjust this later to filter for spells that only the character's class can use
    spell_options = crud.get_all_spells()

    return render_template('all_spells.html', spell_options=spell_options, char_id=char_id)



@app.route('/delete-spell-known/<char_id>')
def delete_spell_known(char_id):

    spell_slug = request.args.get('spell_to_delete')
    crud.delete_spell_known(char_id=char_id, spell_slug=spell_slug)

    db.session.commit()
    
    return redirect('/landing')


@app.route('/handle-add-spell/<char_id>')
def handle_add_spell(char_id):
    """Adds wanted spell to character's spell list"""

    #retrieve slug from form
    slug = request.args.get('spell_to_add')

    #retrieve spell obj from slug
    new_spell = crud.get_spell_by_slug(slug)

    #retrieve character from url
    char = crud.get_character_by_id(char_id)

    #append spell known to char's spells_known list
    char.spells.append(new_spell)

    db.session.commit()

    return redirect('/landing')



@app.route('/play/<char_id>')
def show_play_screen(char_id):
    """Shows the tracker page"""

    char = crud.get_character_by_id(char_id)
    current_day = crud.get_current_day(char_id)

    return render_template('tracker.html', char=char, current_day=current_day)



@app.route('/current-slot-rules/<char_id>')
def get_current_slot_rules(char_id):
    """Gets slot details by character's class and level"""

    return jsonify(crud.get_slot_details(char_id))



@app.route('/list-spells-known/<char_id>')
def list_spells_known(char_id):
    """Returns list of spells known by a character"""

    return jsonify(crud.get_spells_known(char_id))



@app.route('/cast-cantrip/<char_id>')
def handle_cast_cantrip(char_id):
    """Adds a cantrip to the db under the given character"""

    print('\n'*20)
    slug = request.args.get('spell-slug')
    print(slug)
    cantrip = crud.cast_cantrip(char_id=char_id, spell_slug=slug)
    print(cantrip)
    db.session.add(cantrip)
    db.session.commit()

    return 'success'



if __name__ == '__main__':
    connect_to_db(app)

    app.run(debug=True, host='0.0.0.0')