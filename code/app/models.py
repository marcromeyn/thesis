from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from sqlalchemy import Table, Column, Integer, String, Date, Float
import config
# DB class

dbhost = 'localhost'
dbuser = 'root'
dbpass = 'bergersg'
dbname = 'scriptie'
DB_URI = 'mysql://' + dbuser + ':' + dbpass + '@' + dbhost + '/' + dbname

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = DB_URI
db = SQLAlchemy(app)

'''
.
. These are the models from the database
. 

'''

class Certificate_birth(db.Model):
	__tablename__ = 'certificates_birth'
	id = db.Column(db.Integer, primary_key = True, unique = True)
	id_orig = db.Column(db.String(300))
	plaats = db.Column(db.String(300))
	bron = db.Column(db.String(300))
	akte = db.Column(db.String(300))
	voornv = db.Column(db.String(300))
	patrv = db.Column(db.String(300))
	tussenvv = db.Column(db.String(300)) 
	achtv = db.Column(db.String(300))
	voornm = db.Column(db.String(300)) 
	patrm = db.Column(db.String(300))
	tussenvm = db.Column(db.String(300))
	achtm = db.Column(db.String(300))
	datum = db.Column(db.String(300))
	vnamenkind = db.Column(db.String(300))
	tussenvkind = db.Column(db.String(300))
	achternkind = db.Column(db.String(300))
	invnr = db.Column(db.String(300))
	codeinv = db.Column(db.String(300))
	opmerkingen = db.Column(db.String(300))
	scan = db.Column(db.String(300))
	soort = db.Column(db.String(300))
	akte_datum = db.Column(db.String(300))
	zndrkindvn = db.Column(db.String(300))
	beroepvad = db.Column(db.String(300))
	woonpl_vad = db.Column(db.String(300))
	beroep_moe = db.Column(db.String(300))
	woonpl_moe = db.Column(db.String(300))
	toponiem_geb = db.Column(db.String(300))
	info = db.Column(db.String(300))

class Certificate_marriage(db.Model):
	__tablename__ = 'certificates_marriage'
	id = db.Column(db.Integer, primary_key = True, unique = True)
	id_orig = db.Column(db.String(300))
	plaats = db.Column(db.String(300))
	bron = db.Column(db.String(300))
	akte = db.Column(db.String(300))
	datum = db.Column(db.String(300))
	voornamenbg = db.Column(db.String(300))
	tussenvbg = db.Column(db.String(300))
	achtbg = db.Column(db.String(300))
	voornvbg = db.Column(db.String(300))
	patrvbg = db.Column(db.String(300))
	tussvvbg = db.Column(db.String(300))
	achtvbg = db.Column(db.String(300))
	voornmbg = db.Column(db.String(300))
	patrmbg = db.Column(db.String(300))
	tussvmbg = db.Column(db.String(300))
	achtmbg = db.Column(db.String(300))
	voornamenb = db.Column(db.String(300))
	tussenvb = db.Column(db.String(300))
	achtb = db.Column(db.String(300))
	voornvb = db.Column(db.String(300))
	patrvb = db.Column(db.String(300))
	tussvvb = db.Column(db.String(300))
	achtvb = db.Column(db.String(300))
	voornmb = db.Column(db.String(300))
	patrmb = db.Column(db.String(300))
	tussvmb = db.Column(db.String(300))
	achtmb = db.Column(db.String(300))
	bggebdatum = db.Column(db.String(300))
	oudbg = db.Column(db.String(300))
	bggebplaats = db.Column(db.String(300))
	bgebdatum = db.Column(db.String(300))
	oudb = db.Column(db.String(300))
	bgebplaats = db.Column(db.String(300))
	codeinv = db.Column(db.String(300))
	invnr = db.Column(db.String(300))
	opmerkingen = db.Column(db.String(300))
	scan = db.Column(db.String(300))

class Certificate_death(db.Model):
	__tablename__ = 'certificates_death'
	id = db.Column(db.Integer, primary_key = True, unique = True)
	id_orig = db.Column(db.String(300))
	Plaats_akte = db.Column(db.String(300))
	Bron = db.Column(db.String(300))
	Aktenr = db.Column(db.String(300))
	Ovl_voornaam = db.Column(db.String(300))
	Ovl_patroniemen = db.Column(db.String(300))
	Ovl_tussenvoegsels = db.Column(db.String(300))
	Ovl_achternaam = db.Column(db.String(300))
	Relatie = db.Column(db.String(300))
	Rel_voornaam = db.Column(db.String(300))
	Rel_patroniemen = db.Column(db.String(300))
	Rel_tussenvoegsels = db.Column(db.String(300))
	Rel_achternaam = db.Column(db.String(300))
	Zn_dr_kind_van = db.Column(db.String(300))
	Overl_datum = db.Column(db.String(300))
	Vad_voornaam = db.Column(db.String(300))
	Vad_patroniemen = db.Column(db.String(300))
	Vad_tussenvoegsels = db.Column(db.String(300))
	Vad_achternaam = db.Column(db.String(300))
	Moe_voornaam = db.Column(db.String(300))
	Moe_patroniemen = db.Column(db.String(300))
	Moe_tussenvoegsels = db.Column(db.String(300))
	Moe_achternaam = db.Column(db.String(300))
	Invent_nr = db.Column(db.String(300))
	Archiefbloknr = db.Column(db.String(300))
	Opmerkingen = db.Column(db.String(300))
	Datum_akte = db.Column(db.String(300))
	Beroep_moe = db.Column(db.String(300))
	Beroep_ovl = db.Column(db.String(300))
	Beroep_vad = db.Column(db.String(300))
	Geboortepl = db.Column(db.String(300))
	Info = db.Column(db.String(300))
	Leeftijd = db.Column(db.String(300))
	Soort_akte = db.Column(db.String(300))
	Toponiem = db.Column(db.String(300))
	Woonplaats_moe = db.Column(db.String(300))
	Woonpl_ovl = db.Column(db.String(300))
	Woonplaats_vad = db.Column(db.String(300))
	scan = db.Column(db.String(300))
	FileName = db.Column(db.String(300))

class Persons(db.Model):
	id = db.Column(db.Integer, primary_key = True, unique = True)
	birth_certificate_id = 0
	name_full = db.Column(db.String(45))
	name_first = db.Column(db.String(45))
	name_second = db.Column(db.String(45))
	name_last = db.Column(db.String(45))
	gender = db.Column(db.String(45))
	man = db.Column(db.Integer)

class Relationships(db.Model):
	__tablename__ = 'relationships'
	person1 = db.Column(db.Integer, primary_key = True, unique = True)
	person2 = db.Column(db.Integer, primary_key = True, unique = True)
	type = db.Column(db.Integer, primary_key = True, unique = True)
	cert_id = db.Column(db.Integer)

class Types_relationships(db.Model):
	id = db.Column(db.Integer, primary_key = True, unique = True)
	relationship = db.Column(db.String(45))