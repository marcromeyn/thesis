from sqlaload import *
import os


engine_start = connect('mysql://bijan:bhic@localhost/test')
table_start = get_table(engine_start, 'birth_certificates')
count_start = 0

for entry in find(engine_start, table_start, order_by='ID'):
    count_start = count_start + 1


print count_start

path_of_data = '../Database/BS-GEB'

a = 0
#
# for files in os.walk(path_of_data):
#     a = a + 1
#     print files

matches = []
row = {}
count = 0

for root, dirnames, filenames in os.walk(path_of_data):
    for filename in filenames:
        if filename.endswith('.sqlite'):
            # if filename.endswith('Aalst/GEB.001.50.1.sqlite'):
            #     continue
            matches.append(os.path.join(root, filename))

for match in matches:
    engine = connect('sqlite:///' + match)
    table = get_table(engine, 'G_Plaats')
    for entry in find(engine, table, _limit=5000, _offset=0, order_by='ID'):
        if entry['ID'] == None:
            continue
        count = count + 1
        add_row(engine_start, table_start, entry, ensure=True)
        print entry

print count

count_end = 0

for entry in find(engine_start, table_start, _limit=5000, _offset=0, order_by='ID'):
    count_end = count_end + 1
    print entry

print count_end