import MySQLdb as mdb
import sys

con = mdb.connect('localhost', 'root', 'bergersg', 'scriptie')

cur = con.cursor()
cur.execute("SELECT ID, name_first, name_second, name_last FROM persons")

ver = cur.fetchone()
result = cur.fetchall()

for (ID, name_first, name_second, name_last) in result:
	name = name_first + " " + name_second + " " + name_last
	name = " ".join(name.split())

	cur.execute("UPDATE persons SET name_full=%s WHERE ID=%s", (name, ID))

cur.connection.commit();

if con:    
    con.close()