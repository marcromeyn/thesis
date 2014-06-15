import MySQLdb as mdb
import sys

con = mdb.connect('localhost', 'root', 'bergersg', 'scriptie')

cur = con.cursor()
cur.execute("SELECT ID, gender FROM persons")

ver = cur.fetchone()
result = cur.fetchall()

for (ID, gender) in result:
	if gender == "zoon van": 
		isMan = 1
	elif gender == "dochter van":
		isMan = 0
	elif gender == "doodgeboren zoon van":
		isMan = 1
	elif gender ==  "doodgeboren dother van":
		isMan = 0
	else:
		isMan = 2

	cur.execute("UPDATE persons SET man=%s WHERE ID=%s", (isMan, ID))

cur.connection.commit();

if con:    
    con.close()