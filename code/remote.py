import datetime
import hashlib
import string, random
from flask import Flask, jsonify, request
from sqlalchemy import or_, and_
from app.models_remote import *

person = Persons.query.filter_by(reference_ptr_id=2).first()

print
person.first_name