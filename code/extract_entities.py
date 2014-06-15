import datetime
import hashlib
import string,random
from flask import Flask, jsonify, request
from sqlalchemy import or_, and_
from app.models import *


class People_in_birth_certificate(object):
    """
    Extract the child, mom and dad from a birthcertificate
    Try to merge them with an entity or create a new one.

    """

    def __init__(self, arg):
        super(People_in_birth_certificate, self).__init__()
        self.is_marriage = False
        self.doubles_marriage = False
        self.db_record = arg
        self.get_child()
        self.get_mom()
        self.get_dad()
        self.get_marriage()

    def get_child(self):
        self.name_child_full = (self.db_record.vnamenkind + " " +
                                self.db_record.tussenvkind + " " + self.db_record.achternkind)
        self.name_child_full = " ".join(self.name_child_full.split())

    def get_mom(self):
        self.name_mom_full = (self.db_record.voornm + " " +
                              self.db_record.tussenvm + " " + self.db_record.achtm)
        self.name_mom_full = " ".join(self.name_mom_full.split())

    def get_dad(self):
        self.name_dad_full = (self.db_record.voornv + " " +
                              self.db_record.tussenvv + " " + self.db_record.achtv)
        self.name_dad_full = " ".join(self.name_dad_full.split())

    def get_marriage(self):
        marriages = (Certificate_marriage.query
                     .filter(Certificate_marriage.voornamenbg
        .like(self.db_record.voornv))
                     .filter(Certificate_marriage.tussenvbg
        .like(self.db_record.tussenvv))
                     .filter(Certificate_marriage.achtbg
        .like(self.db_record.achtv))
                     .filter(Certificate_marriage.voornamenb
        .like(self.db_record.voornm))
                     .filter(Certificate_marriage.tussenvb
        .like(self.db_record.tussenvm))
                     .filter(Certificate_marriage.achtb
        .like(self.db_record.achtm))
                     .all()
        )
        if len(marriages) > 1: self.doubles_marriage = True
        for marriage in marriages:
            print ('groom: ' + self.name_dad_full +
                   ' bride: ' + self.name_mom_full)
            self.is_marriage = True


# Get all the certificates from the database
births = Certificate_birth.query.all()
#marriages = Certificate_marriage.query.all()
#deaths = Certificate_death.query.all()

# persons = Persons.query.all()
# for p in persons: print p.name_full

_counter = 0
_doubles = 0
_women = 0
_men = 0
_marriages = 0
_marriages_doubles = 0

for birth in births:
    if birth.voornv:
        people = People_in_birth_certificate(birth)

        match_child = (Persons.query.filter(
            Persons.name_full.like(people.name_child_full))
                       .first())

        match_dad = (Persons.query.filter(
            Persons.name_full.like(people.name_dad_full))
                     .all())

        match_mom = (Persons.query.filter(
            Persons.name_full.like(people.name_mom_full))
                     .all())
        if people.is_marriage:
            _marriages = _marriages + 1
            if people.doubles_marriage:
                _marriages_doubles = _marriages_doubles + 1

        if match_dad:
            _count = 0
            for match in match_dad:
                print(
                '''Match: child: [id: {}, name: {}] \
                            dad: [id: {}, name: {}]'''
                .format(
                    match_child.id, match_child.name_full,
                    match.id, match.name_full))
                _counter = _counter + 1
                _count = _count + 1
                _men = _men + 1
            if (_count >= 2):
                print _count
                _doubles = _doubles + 1

        if match_mom:
            _count = 0
            for match in match_mom:
                print('''Match: child: [id: {}, name: {}] \
								dad: [id: {}, name: {}]'''
                      .format(
                    match_child.id, match_child.name_full,
                    match.id, match.name_full))
                _counter = _counter + 1
                _count = _count + 1
                _women = _women + 1
            if (_count >= 2):
                print _count
                _doubles = _doubles + 1

print ('Number of matches: {}, number of doubles: {}'
       .format(_counter, _doubles))
print ('Number of women: {}, number of men: {}'
       .format(_women, _men))
print ('Number of marriages: {}, number of doubles: {}'
       .format(_marriages, _marriages_doubles))

# parents = Parents_from_birth_certificate(births[2])
# marr = Certificate_death.query.filter_by(id=2).first()

# query = meta.Session.query(User).filter(or_(User.firstname.like(searchVar),
#                                             User.lastname.like(searchVar)))

# print parents.name_dad_full
# print parents.name_mom_full
# print marr.Plaats_akte