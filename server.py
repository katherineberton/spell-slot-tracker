from flask import Flask, render_template, render_template_string, request, flash, session, redirect
from flask_sqlalchemy import SQLAlchemy

from model import connect_to_db, db
import crud

app = Flask(__name__)
app.secret_key = "dev-mode"



if __name__ == '__main__':
    connect_to_db(app)

    app.run(debug=True, host='0.0.0.0')