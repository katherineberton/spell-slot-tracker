from flask import Flask, render_template, render_template_string, request, flash, session, redirect
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

        #assign variable user to the User obj with the associated email address
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



@app.route('/new_user_registration', methods=["POST"])
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

    return render_template('landing.html')



@app.route(f'/create_a_character')
def get_character_details():

    return render_template('create_a_character.html')



@app.route('/new_char_registration', methods=["POST"])
def create_a_character():

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

    db.session.commit()

    return redirect('/landing')

    
    

if __name__ == '__main__':
    connect_to_db(app)

    app.run(debug=True, host='0.0.0.0')