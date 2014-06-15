SELECT b.ID as father_id, b.name_full as father_name, c.ID as child_id, c.name_full as child_name, a.ID
FROM scriptie.certificates_birth as a
INNER JOIN 
persons as b ON a.voornv = b.name_first AND a.tussenvv = b.name_second AND a.achtv = b.name_last 
INNER JOIN
persons as c ON a.vnamenkind = c.name_first AND a.tussenvkind = c.name_second AND a.achternkind = c.name_last 
WHERE a.voornv != '';
