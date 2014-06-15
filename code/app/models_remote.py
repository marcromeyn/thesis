from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from sqlalchemy import Table, Column, Integer, String, Date, Float
import config
# DB class

dbhost = '127.0.0.1:9990'
dbuser = 'bijan'
dbpass = 'bhic'
dbname = 'memorix'
DB_URI = 'mysql://' + dbuser + ':' + dbpass + '@' + dbhost + '/' + dbname

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = DB_URI
db = SQLAlchemy(app)

class Persons(db.Model):
	__tablename__ = 'blog_reference_person'
	reference_ptr_id = db.Column(db.Integer, primary_key = True, unique = True)
	first_name = db.Column(db.String(100))
	middle_name = db.Column(db.String(100))
	last_name = db.Column(db.String(100))
	gender = db.Column(db.String(100))
	document_id = db.Column(db.Integer)
