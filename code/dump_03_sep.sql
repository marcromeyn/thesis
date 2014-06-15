SELECT *
FROM test.birth_death as bd, test.birth_names_full as bn, test.death_full_names as dn
WHERE bd.birth_certificate_id = bn.birth_certificate_id AND
    bd.death_certificate_id = dn.death_certificate_id;

SELECT COUNT(*)
FROM test.birth_death as bd, test.birth_names_full as bn, test.death_full_names as dn
WHERE bd.birth_certificate_id = bn.birth_certificate_id AND
    bd.death_certificate_id = dn.death_certificate_id
;

INSERT INTO t
SELECT *
FROM test.persons as p;

SELECT COUNT(*) FROM test.death_full_names as a WHERE a.relative = '';

SELECT first_name, middle_name, last_name, COUNT(*)
  FROM memorix.blog_reference_person
  WHERE first_name != ''
  GROUP BY first_name, middle_name, last_name
  HAVING COUNT(*) > 1;

INSERT INTO test.birth_death(birth_certificate_id, death_certificate_id)
    SELECT birth_names.birth_certificate_id, death_names.death_certificate_id
    FROM test.birth_names_full as birth_names , test.death_full_names as death_names
    WHERE birth_names.child = death_names.person AND
        birth_names.mom = death_names.mom AND
        birth_names.dad = death_names.dad;

SELECT COUNT(*)
    FROM test.marriage_names_full as marriage_names,
      test.death_full_names as death_names,
      test.marriage_certificates as marriages,
      test.death_certificates as deaths
    WHERE marriage_names.groom = death_names.person AND
        marriage_names.bride = death_names.relative AND
        marriage_names.marriage_certificate_id = marriages.marriage_certificate_id AND
        death_names.death_certificate_id = deaths.death_certificate_id AND
        marriages.plaats = deaths.plaats;

INSERT IGNORE INTO test.marriage_death(marriage_certificate_id, death_certificate_id)
  SELECT marriage_names.marriage_certificate_id, death_names.death_certificate_id
      FROM test.marriage_names_full as marriage_names,
        test.death_full_names as death_names,
        test.marriage_certificates as marriages,
        test.death_certificates as deaths
      WHERE marriage_names.bride = death_names.person AND
          marriage_names.groom = death_names.relative AND
          marriage_names.marriage_certificate_id = marriages.marriage_certificate_id AND
          death_names.death_certificate_id = deaths.death_certificate_id AND
          marriages.plaats = deaths.plaats
      GROUP BY  marriage_names.marriage_certificate_id
      HAVING COUNT(*) = 1;

INSERT IGNORE INTO test.marriage_death(marriage_certificate_id, death_certificate_id)
  SELECT marriage_names.marriage_certificate_id, death_names.death_certificate_id
      FROM test.marriage_names_full as marriage_names,
        test.death_full_names as death_names,
        test.marriage_certificates as marriages,
        test.death_certificates as deaths
      WHERE marriage_names.groom = death_names.person AND
          marriage_names.groom_dad = death_names.dad AND
          marriage_names.groom_mom = death_names.mom AND
          marriage_names.marriage_certificate_id = marriages.marriage_certificate_id AND
          death_names.death_certificate_id = deaths.death_certificate_id AND
          marriages.plaats = deaths.plaats
      GROUP BY  marriage_names.marriage_certificate_id
      HAVING COUNT(*) = 1;

INSERT INTO test.marriage_death(marriage_certificate_id, death_certificate_id)
    SELECT marriage_names.marriage_certificate_id, death_names.death_certificate_id
    FROM test.marriage_names_full as marriage_names, test.death_full_names as death_names
    WHERE marriage_names.groom = death_names.person AND
        marriage_names.groom_dad = death_names.dad AND
        marriage_names.groom_mom = death_names.mom AND
        marriage_names.bride = death_names.relative;


SELECT SUM(persons) FROM( SELECT COUNT(*) as persons
  FROM memorix.blog_reference_person
  WHERE first_name != ''
  GROUP BY first_name, middle_name, last_name
  HAVING COUNT(*) > 1) as a;

SELECT COUNT(*) FROM test;

ALTER TABLE test.full_names_birth AUTO_INCREMENT = 0;

DELETE FROM test.full_names_birth WHERE birth_certificate_id > 0;

SELECT COUNT(*) FROM test.marriage_certificates;

SELECT COUNT(*)
FROM test.birth_death;

SELECT COUNT(*)
  FROM test.marriage_names as mn, test.birth_names as bn
  WHERE
      mn.groom_dad_full = bn.dad_full AND mn.groom_mom_full = bn.mom_full AND mn.groom_full = bn.child_full
;

INSERT INTO test.death_full_names(death_certificate_id, person, relative, mom, dad)
  SELECT death_certificate_id,
    REPLACE(CONCAT_WS(' ', TRIM(voorn), TRIM(tussenv), TRIM(acht)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(relvoorn), TRIM(reltussenv), TRIM(relacht)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(vnaamm), TRIM(tussenvm), TRIM(achtm)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(vnaamv), TRIM(tussenvv), TRIM(achtv)), '  ', ' ')
  FROM test.death_certificates;

INSERT INTO test.buried_names(buried_certificate_id, person_full, person_first, person_middle, person_last,
                              relative_full, relative_first, relative_middle, relative_last)
SELECT buried_certificate_id,
  REPLACE(CONCAT_WS(' ', TRIM(vnaam), TRIM(tussenv), TRIM(acht)), '  ', ' '),
  TRIM(vnaam), TRIM(tussenv), TRIM(acht),
  REPLACE(CONCAT_WS(' ', TRIM(relvnaam), TRIM(reltussenv), TRIM(relacht)), '  ', ' '),
  TRIM(relvnaam), TRIM(reltussenv), TRIM(relacht)
  FROM test.buried_certificates;


INSERT INTO test.persons(full_name, certificate_id, cert_type)
    SELECT child, birth_certificate_id, 0 FROM test.birth_names_full;

INSERT INTO test.birth_names(birth_certificate_id, child_full, child_first, child_middle, child_last, mom_full, mom_first,
                              mom_middle, mom_last, dad_full, dad_first, dad_middle, dad_last)
    SELECT birth_certificate_id,
        REPLACE(CONCAT_WS(' ', TRIM(vnamenkind), TRIM(tussenvkind), TRIM(achternkind)), '  ', ' '),
        TRIM(vnamenkind), TRIM(tussenvkind), TRIM(achternkind),
        REPLACE(CONCAT_WS(' ', TRIM(voornm), TRIM(tussenvm), TRIM(achtm)), '  ', ' '),
        TRIM(voornm), TRIM(tussenvm), TRIM(achtm),
        REPLACE(CONCAT_WS(' ', TRIM(voornv), TRIM(tussenvv), TRIM(achtv)), '  ', ' '),
        TRIM(voornv), TRIM(tussenvv), TRIM(achtv)
    FROm test.birth_certificates;

INSERT INTO test.birth_full_names(birth_certificate_id, child, mom, dad)
  SELECT birth_certificate_id,
    REPLACE(CONCAT_WS(' ', TRIM(vnamenkind), TRIM(tussenvkind), TRIM(achternkind)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornm), TRIM(tussenvm), TRIM(achtm)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornv), TRIM(tussenvv), TRIM(achtv)), '  ', ' ')
  FROM test.birth_certificates;

INSERT INTO test.marriage_names(marriage_certificate_id, bride_full, bride_first, bride_middle, bride_last,
                                groom_full, groom_first, groom_middle, groom_last, bride_mom_full, bride_mom_first,
                                bride_mom_middle, bride_mom_last, bride_dad_full, bride_dad_first, bride_dad_middle,
                                bride_dad_last, groom_mom_full, groom_mom_first, groom_mom_middle, groom_mom_last,
                                groom_dad_full, groom_dad_first, groom_dad_middle, groom_dad_last)
    SELECT marriage_certificate_id,
    REPLACE(CONCAT_WS(' ', TRIM(voornamenb), TRIM(tussenvb), TRIM(achtb)), '  ', ' '),
      TRIM(voornamenb), TRIM(tussenvb), TRIM(achtb),
    REPLACE(CONCAT_WS(' ', TRIM(voornamenbg), TRIM(tussenvbg), TRIM(achtbg)), '  ', ' '),
      TRIM(voornamenbg), TRIM(tussenvbg), TRIM(achtbg),
    REPLACE(CONCAT_WS(' ', TRIM(voornmb), TRIM(tussvmb), TRIM(achtmb)), '  ', ' '),
    TRIM(voornmb), TRIM(tussvmb), TRIM(achtmb),
    REPLACE(CONCAT_WS(' ', TRIM(voornvb), TRIM(tussvvb), TRIM(achtvb)), '  ', ' '),
      TRIM(voornvb), TRIM(tussvvb), TRIM(achtvb),
    REPLACE(CONCAT_WS(' ', TRIM(voornmbg), TRIM(tussvmbg), TRIM(achtmbg)), '  ', ' '),
      TRIM(voornmbg), TRIM(tussvmbg), TRIM(achtmbg),
    REPLACE(CONCAT_WS(' ', TRIM(voornvbg), TRIM(tussvvbg), TRIM(achtvbg)), '  ', ' '),
      TRIM(voornvbg), TRIM(tussvvbg), TRIM(achtvbg)
    FROM test.marriage_certificates;

INSERT INTO test.marriage_names_full(marriage_certificate_id, bride, groom,
                                     bride_mom, bride_dad, groom_mom, groom_dad)
  SELECT marriage_certificate_id,
    REPLACE(CONCAT_WS(' ', TRIM(voornamenb), TRIM(tussenvb), TRIM(achtb)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornamenbg), TRIM(tussenvbg), TRIM(achtbg)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornmb), TRIM(tussvmb), TRIM(achtmb)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornvb), TRIM(tussvvb), TRIM(achtvb)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornmbg), TRIM(tussvmbg), TRIM(achtmbg)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornvbg), TRIM(tussvvbg), TRIM(achtvbg)), '  ', ' ')
  FROM test.marriage_certificates;

SELECT births.birth_certificate_id, birth_names.mom, birth_names.dad, marriage_names.marriage_certificate_id
  FROM test.birth_certificates as births
  INNER JOIN test.full_names_birth as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.full_names_marriage as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad;

SELECT COUNT(*) FROM test.birth_marriage;

CREATE FUNCTION levenshtein RETURNS INTEGER SONAME 'levenshtein.so';

SELECT a.marriage_certificate_id, a.groom, a.bride, a.dad_groom, a.mom_groom, a.dad_bride, a.mom_bride FROM test.full_names_marriage as a
  INNER JOIN test.full_names_marriage as b ON
    a.bride = b.bride AND
    a.groom = b.groom AND
    a.mom_groom = b.mom_groom AND
    a.dad_groom = b.dad_groom AND
    a.mom_bride = b.mom_bride AND
    a.dad_bride = b.dad_bride
  GROUP BY a.groom, a.bride, a.dad_groom, a.mom_groom, a.dad_bride, a.mom_bride
  HAVING COUNT(*) > 1
  ORDER BY a.groom, a.bride, a.dad_groom, a.mom_groom, a.dad_bride, a.mom_bride;

SELECT COUNT(doubles), SUM(doubles) FROM (SELECT COUNT(*) as doubles FROM test.full_names_marriage as a
  INNER JOIN test.full_names_marriage as b ON
    a.bride = b.bride AND
    a.groom = b.groom AND
    a.mom_groom = b.mom_groom AND
    a.dad_groom = b.dad_groom AND
    a.mom_bride = b.mom_bride AND
    a.dad_bride = b.dad_bride
  GROUP BY a.groom, a.bride, a.dad_groom, a.mom_groom, a.dad_bride, a.mom_bride
  HAVING COUNT(*) > 1) as A;

SELECT COUNT(doubles), SUM(doubles) FROM (SELECT COUNT(*) as doubles FROM test.full_names_birth as a
  INNER JOIN test.full_names_birth as b ON
    a.child = b.child AND
    a.dad = b.dad AND
    a.mom = a.dad
  GROUP BY a.child, a.dad, a.mom
  HAVING COUNT(*) > 1) as A;


SELECT COUNT(one_marriage), SUM(one_marriage) FROM (SELECT COUNT(*) as one_marriage
  FROM test.birth_certificates as births
  INNER JOIN test.full_names_birth as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.full_names_marriage as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad
  GROUP BY birth_names.mom, birth_names.dad
  HAVING COUNT(*) = 1) as a;

SELECT births.birth_certificate_id, COUNT(*)
  FROM test.birth_certificates as births
  INNER JOIN test.full_names_birth as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.full_names_marriage as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad
  GROUP BY births.birth_certificate_id
  HAVING COUNT(*) = 1;

select levenshtein('privacy', 'rpivacy');


# Find the marriage certificate of the child's parents
SELECT COUNT(one_mar) FROM (SELECT COUNT(*) as one_mar
  FROM test.birth_certificates as births
  INNER JOIN test.birth_names_full as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.marriage_names_full as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad
  GROUP BY births.birth_certificate_id
  HAVING COUNT(*) = 1) AS a;

SELECT COUNT(one_mar) FROM (SELECT COUNT(*) as one_mar
  FROM test.birth_certificates as births
  INNER JOIN test.birth_names_full as birth_names ON
      births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.marriage_names_full as marriage_names ON
      marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad
  INNER JOIN test.birth_names_full as birth_dad ON
      birth_dad.child = birth_names.dad AND
      birth_dad.mom = marriage_names.groom_mom AND
      birth_dad.dad = marriage_names.groom_dad
  GROUP BY births.birth_certificate_id
  HAVING COUNT(*) = 1) AS a;

SELECT COUNT(one_mar) FROM (SELECT COUNT(*) as one_mar
  FROM test.birth_certificates as births
  INNER JOIN test.birth_names_full as birth_names ON
      births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.marriage_names_full as marriage_names ON
      damlevlim256(marriage_names.bride, birth_names.mom, 255) < 5 AND
      damlevlim256(marriage_names.groom, birth_names.dad, 255) < 5
  GROUP BY births.birth_certificate_id
  HAVING COUNT(*) = 1) AS a;

# Get the number of rows and size in MB of all the tables in the database:
SELECT TABLE_NAME, table_rows, data_length, index_length,  round(((data_length + index_length) / 1024 / 1024),2) "Size in MB" FROM information_schema.TABLES WHERE table_schema = "test";

INSERT IGNORE INTO test.person_relations(id_person1, id_person2, type, distance)
  SELECT children.person_id, mom.person_id, 2 FROM  test.persons as children
    INNER JOIN test.birth_names_full as birth_names ON
        children.certificate_id = birth_names.birth_certificate_id
    INNER JOIN test.marriage_names_full as marriage_names ON
        marriage_names.bride = birth_names.mom AND
        marriage_names.groom = birth_names.dad
    INNER JOIN test.birth_names_full as birth_mom ON
        birth_mom.child = birth_names.mom AND
        birth_mom.mom = marriage_names.bride_mom AND
        birth_mom.dad = marriage_names.bride_dad
    INNER JOIN test.persons as mom ON
        mom.cert_type = 0 AND
        mom.certificate_id = birth_mom.birth_certificate_id
  GROUP BY children.certificate_id
  HAVING COUNT(*) = 1;



INSERT IGNORE INTO test.person_relations(id_person1, id_person2, type, distance)
  SELECT children.person_id, mom.person_id, 2 FROM  test.persons as children
    INNER JOIN test.birth_names_full as birth_names ON
        children.certificate_id = birth_names.birth_certificate_id
    INNER JOIN test.marriage_names_full as marriage_names ON
        marriage_names.bride = birth_names.mom AND
        marriage_names.groom = birth_names.dad
    INNER JOIN test.birth_names_full as birth_mom ON
        birth_mom.child = birth_names.mom AND
        birth_mom.mom = marriage_names.bride_mom AND
        birth_mom.dad = marriage_names.bride_dad
    INNER JOIN test.persons as mom ON
        mom.cert_type = 0 AND
        mom.certificate_id = birth_mom.birth_certificate_id
  GROUP BY children.certificate_id
  HAVING COUNT(*) = 1;

INSERT INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad)
  SELECT births.birth_certificate_id, marriage_names.marriage_certificate_id, damlevlim256(marriage_names.bride, birth_names.mom, 255), damlevlim256(marriage_names.groom, birth_names.dad, 255)
    FROM test.birth_certificates as births
    INNER JOIN test.birth_names_full as birth_names ON
        births.birth_certificate_id = birth_names.birth_certificate_id
    INNER JOIN test.marriage_names_full as marriage_names ON
        (marriage_names.bride = birth_names.mom XOR
          marriage_names.groom = birth_names.dad)
        AND
        (ABS(LENGTH(marriage_names.bride) - LENGTH(birth_names.mom)) < 5 AND
          ABS(LENGTH(marriage_names.groom) - LENGTH(birth_names.dad)) < 5)
        AND
        (damlevlim256(marriage_names.bride, birth_names.mom, 255) < 5 AND
          damlevlim256(marriage_names.groom, birth_names.dad, 255) < 5)
    GROUP BY births.birth_certificate_id
    HAVING COUNT(*) = 1;

select damlevlim256('privacy', 'rpivacy', 255);

SELECT test.SPLIT_STR('marc romeyn', ' ', 1);

SELECT test.SPLIT_STR(`database`, '/', 4) FROM test.birth_certificates

;

INSERT INTO test.places_synonyms(name, name_synonym, latitude, longitude, province, reference_ptr_id)
SELECT a.standard_name, a.admin_name_2, lat, lng, admin_name_1, reference_ptr_id
FROM test.blog_reference_place as a
group by standard_name;

LOAD DATA INFILE '/home/marcromeyn/marc/database/cities.csv'
INTO TABLE test.places
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT COUNT(*)
FROM  test.marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.dad_full = mn2.groom_full AND
                damlevlim256(bn.mom_last, mn2.bride_last, 255) < 3 AND
                damlevlim256(bn.mom_first, mn2.bride_first, 255) < 8
        ORDER BY damlevlim256(bn.mom_full, mn2.bride_full, 255) ASC
        LIMIT 1)
;

SELECT COUNT(*)
FROM test.birth_marriage as bm, test.marriage_names mn, test.birth_names as bn
WHERE bm.marriage_certificate_id = mn.marriage_certificate_id AND
      (mn.bride_dad_full = bn.dad_full AND
      damlevlim256(bn.mom_last, mn.bride_mom_last, 255) < 3 AND
          damlevlim256(bn.child_last, mn.bride_last, 255) < 3) OR
      (mn.bride_mom_full = bn.mom_full AND
       damlevlim256(bn.dad_last, mn.bride_dad_last, 255) < 3 AND
        damlevlim256(bn.child_last, mn.bride_last, 255) < 3) OR
      (mn.bride_full = bn.child_full AND
      damlevlim256(bn.dad_last, mn.bride_dad_last, 255) < 3 AND
          damlevlim256(bn.mom_last, mn.bride_mom_last, 255) < 3)
;

SELECT COUNT(*)
FROM test.birth_marriage as bm, test.marriage_names mn, test.birth_names as bn
WHERE bm.marriage_certificate_id = mn.marriage_certificate_id AND
      mn.bride_dad_full = bn.dad_full AND mn.bride_mom_full = bn.mom_full AND mn.bride_full = bn.child_full
;

SELECT COUNT(*)
FROM test.birth_marriage as bm, test.marriage_names mn, test.birth_names as bn
WHERE bm.marriage_certificate_id = mn.marriage_certificate_id AND
      mn.bride_dad_full = bn.dad_full AND  damlevlim256(bn.mom_full, mn.bride_mom_full, 255) < 5 AND
          damlevlim256(bn.child_full, mn.bride_full, 255) < 5
;

SELECT COUNT(*)
FROM test.birth_marriage as bm;

CREATE FUNCTION test.SPLIT_STR(
  x VARCHAR(255),
  delim VARCHAR(12),
  pos INT
)
RETURNS VARCHAR(255)
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '');

SELECT COUNT(doubles), SUM(doubles) FROM (SELECT COUNT(*) AS doubles FROM test.full_names_marriage as a
  INNER JOIN test.full_names_marriage as b ON
    a.bride = b.bride AND
    a.groom = b.groom
  GROUP BY a.groom, a.bride
  HAVING COUNT(*) > 1) AS a;

SELECT bn.dad_full, mn.groom_full,
  damlevlim256(test.SPLIT_STR(bn.dad_first, ' ', 1),
                test.SPLIT_STR(mn.groom_first, ' ', 1), 255) as lev
FROM  test.marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.mom_full = mn2.bride_full AND
                damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 AND
                damlevlim256(test.SPLIT_STR(bn.dad_first, ' ', 1), test.SPLIT_STR(mn2.groom_first, ' ', 1), 255) < 15
        ORDER BY damlevlim256(bn.dad_full, mn2.groom_full, 255) ASC
        LIMIT 1)
Order by lev desc
;

SELECT count(*)
FROM  test.marriage_names as mn,
    (select *
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.mom_full = mn2.bride_full AND
                damlevlim256(bn.dad_last, mn2.groom_last, 255) < 3
        ORDER BY damlevlim256(bn.dad_full, mn2.groom_full, 255) ASC
        LIMIT 1)
;

select count(*)
  from test.birth_names as b, test.marriage_names as m
  where b.mom_full = m.bride_full and b.dad_full = m.groom_full;

SELECT ((count(*) /  360142 * 100)) as percentage
FROM  test.marriage_names as mn,
    (select *
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage where distance_dad = 0 and distance_mom = 0
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE (bn.dad_full = mn2.groom_full and
                damlevlim256(bn.mom_full, mn2.bride_full, 255) < 10)
        ORDER BY damlevlim256(bn.mom_full, mn2.bride_full, 255) ASC
        LIMIT 1)
;

SELECT bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as lev, count(*)
FROM  test.marriage_names as mn,
    (select *
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage where distance_dad = 0 and distance_mom = 0
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE (bn.dad_full = mn2.groom_full and
                damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2)
        ORDER BY damlevlim256(bn.mom_last, mn2.bride_last, 255) ASC
        LIMIT 1)
ORDER BY damlevlim256(bn.mom_full, mn.bride_full, 255) desc
;


SELECT test.SPLIT_STR(bn.dad_first, ' ', 1) as dad_first, test.SPLIT_STR(mn.groom_first, ' ', 1) as groom_first, bn.dad_full, mn.groom_full, COUNT(*) as count
FROM  test.marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.mom_full = mn2.bride_full AND
                damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 AND
                damlevlim256(test.SPLIT_STR(bn.dad_first, ' ', 1), test.SPLIT_STR(mn2.groom_first, ' ', 1), 255) < 8 AND
                test.SPLIT_STR(bn.dad_first, ' ', 1) != test.SPLIT_STR(mn2.groom_first, ' ', 1)
        ORDER BY damlevlim256(bn.dad_full, mn2.groom_full, 255) ASC
        LIMIT 1)
  GROUP BY dad_first, groom_first
  ORDER BY count DESC
;

select * from test.birth_names_christen order by birth_certificate_id desc;

select * from test.marriage_names_christen order by marriage_certificate_id desc;

SELECT test.SPLIT_STR(bn.dad_first, ' ', 1) as dad_first, test.SPLIT_STR(mn.groom_first, ' ', 1) as groom_first, bn.dad_full, mn.groom_full
FROM  test.marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.mom_full = mn2.bride_full AND
                damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 AND
                damlevlim256(test.SPLIT_STR(bn.dad_first, ' ', 1), test.SPLIT_STR(mn2.groom_first, ' ', 1), 255) < 8 AND
                test.SPLIT_STR(bn.dad_first, ' ', 1) != test.SPLIT_STR(mn2.groom_first, ' ', 1)
        ORDER BY damlevlim256(bn.dad_full, mn2.groom_full, 255) ASC
        LIMIT 1) and
       test.SPLIT_STR(bn.dad_first, ' ', 1) = 'Jan' and test.SPLIT_STR(mn.groom_first, ' ', 1) = 'Johannes'
;

select sum(count) from (select count(*) as count from
  test.marriage_names
  group by bride_mom_full, bride_dad_full, bride_full, groom_dad_full, groom_mom_full, groom_full
  having count > 1) as a;

SELECT test.SPLIT_STR(bn.mom_first, ' ', 1) as mom_first, test.SPLIT_STR(mn.bride_first, ' ', 1) as bride_first, bn.mom_full, mn.bride_full, COUNT(*) as count
FROM  test.marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.dad_full = mn2.groom_full AND
                damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 AND
                damlevlim256(test.SPLIT_STR(bn.mom_first, ' ', 1), test.SPLIT_STR(mn2.bride_first, ' ', 1), 255) < 8 AND
                test.SPLIT_STR(bn.mom_first, ' ', 1) != test.SPLIT_STR(mn2.bride_first, ' ', 1)
        ORDER BY damlevlim256(bn.mom_full, mn2.bride_full, 255) ASC
        LIMIT 1)
  GROUP BY mom_first, bride_first
  ORDER BY count DESC
;

SELECT bn.mom_full, mn.bride_full
FROM test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND bn2.birth_certificate_id not in (
          select birth_certificate_id from test.birth_names_christen
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2, test.marriage_names_christen as c
        WHERE bn.dad_full = mn2.groom_full AND
              damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 AND
              mn2.marriage_certificate_id = c.marriage_certificate_id and c.type = 0 and damlevlim256(c.name, bn.mom_first, 100) < 3
        LIMIT 1)
;

SELECT bn.dad_full, mn.groom_full
FROM test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND bn2.birth_certificate_id not in (
          select birth_certificate_id from test.birth_names_christen
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2, test.marriage_names_christen as c
        WHERE bn.mom_full = mn2.bride_full AND
              damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 AND
              mn2.marriage_certificate_id = c.marriage_certificate_id and c.type = 1 and damlevlim256(c.name, bn.dad_first, 100) < 3
        LIMIT 1)
;



select bn.dad_full, mn.groom_full
from test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  not in (
            SELECT birth_certificate_id from test.birth_marriage
        ) AND bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_names_christen
        ) and bn2.dad_first in (
            select name from test.names_synonyms where name = dad_first
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
where
    mn.marriage_certificate_id = (select mn2.marriage_certificate_id as mid
        from test.marriage_names as mn2, test.marriage_names_christen as c, test.names_synonyms as n
        where bn.mom_full = mn2.bride_full and
              n.group_id = (select group_id from test.names_synonyms where name = bn.dad_first group by name) and
              damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 and
              mn2.marriage_certificate_id = c.marriage_certificate_id and c.type = 1 and
              (
                 (LENGTH(n.name) <= 5 and damlevlim256(n.name, bn.dad_first, 100) < (LENGTH(n.name) / 4)) or
                 (LENGTH(n.name) > 5 and damlevlim256(n.name, bn.dad_first, 100) < 3)
              )
        limit 1)
  ;

# from male nick name to christian names direct or via synonyms, (type = 3)
insert ignore into test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id, 0, 0, 6 #
from test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_marriage
        ) and
        bn2.child_full != '' and bn2.mom_full != '' and bn2.dad_full != ''
    ) as bn, test.birth_names_christen as bc
where
    bn.birth_certificate_id = bc.birth_certificate_id and bc.type = 1 and
    mn.marriage_certificate_id = (select mn2.marriage_certificate_id as mid
        from test.marriage_names as mn2, test.names_synonyms as n
        where
          mn2.marriage_certificate_id not in (
                select marriage_certificate_id from test.marriage_names_christen where type = 0
          ) and
          # bn.dad_last =  mn2.groom_last and
          bn.dad_full =  mn2.groom_full and
          damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 and
          (
              (n.group_id = (select group_id from test.names_synonyms where name = mn2.bride_first group by name) and
               (
                 (LENGTH(n.name) <= 5 and damlevlim256(n.name, bc.name, 100) < (LENGTH(n.name) / 4)) or
                 (LENGTH(n.name) > 5 and damlevlim256(n.name, bc.name, 100) < 3)
               )
              )
              or
              (
                damlevlim256(bc.name, mn2.bride_first, 100) < 3
              )
          )
        order by damlevlim256(bc.name, mn2.bride_first, 100)
        LIMIT 1)
;

# from male nick name to christian names direct or via synonyms, (type = 3)
select bn.dad_full, mn.groom_full #count(*)
from test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  not in (
            SELECT birth_certificate_id from test.birth_marriage
        ) AND bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_names_christen where type = 1
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
where
    mn.marriage_certificate_id = (select mn2.marriage_certificate_id as mid
        from test.marriage_names as mn2, test.marriage_names_christen as c, test.names_synonyms as n
        where bn.mom_full = mn2.bride_full and
              (
                (n.group_id = (select group_id from test.names_synonyms where name = bn.dad_first group by name) and
                 damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 and
                 mn2.marriage_certificate_id = c.marriage_certificate_id and c.type = 1 and
                 (
                   (LENGTH(n.name) <= 5 and damlevlim256(n.name, bn.dad_first, 100) < (LENGTH(n.name) / 4)) or
                   (LENGTH(n.name) > 5 and damlevlim256(n.name, bn.dad_first, 100) < 3)
                 )
                )
                or
                (
                  damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 AND
                  mn2.marriage_certificate_id = c.marriage_certificate_id and c.type = 1 and damlevlim256(c.name, bn.dad_first, 100) < 3
                )
              )
        limit 1)
;

# from male christian names to nick name direct or via synonyms (type = 4)
select count(*) # bn.dad_full, mn.groom_full
from test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_marriage
        ) and
        bn2.child_full != '' and bn2.mom_full != '' and bn2.dad_full != ''
    ) as bn, test.birth_names_christen as bc
where
    bn.birth_certificate_id = bc.birth_certificate_id and bc.type = 2 and
    mn.marriage_certificate_id = (select mn2.marriage_certificate_id as mid
        from test.marriage_names as mn2, test.names_synonyms as n
        where
          mn2.marriage_certificate_id not in (
                select marriage_certificate_id from test.marriage_names_christen where type = 1
          ) and
          bn.mom_full = mn2.bride_full and
          damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 and
          (
              (n.group_id = (select group_id from test.names_synonyms where name = mn2.groom_first group by name) and
               (
                 (LENGTH(n.name) <= 5 and damlevlim256(n.name, bc.name, 100) < (LENGTH(n.name) / 4)) or
                 (LENGTH(n.name) > 5 and damlevlim256(n.name, bc.name, 100) < 3)
               )
              )
              or
              (
                damlevlim256(bc.name, mn2.groom_first, 100) < 3
              )
          )
        order by damlevlim256(bc.name, mn2.groom_first, 100)
        LIMIT 1)
;

# from female nick name to christian names direct or via synonyms (type = 5)
select bn.mom_full, mn.bride_full # count(*)
from test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  not in (
            SELECT birth_certificate_id from test.birth_marriage
        ) AND bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_names_christen where type = 0
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
where
    mn.marriage_certificate_id = (select mn2.marriage_certificate_id as mid
        from test.marriage_names as mn2, test.marriage_names_christen as c, test.names_synonyms as n
        where bn.dad_full = mn2.groom_full and
              (
                (n.group_id = (select group_id from test.names_synonyms where name = bn.mom_first group by name) and
                 damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 and
                 mn2.marriage_certificate_id = c.marriage_certificate_id and c.type = 2 and
                 (
                   (LENGTH(n.name) <= 5 and damlevlim256(n.name, bn.mom_first, 100) < (LENGTH(n.name) / 4)) or
                   (LENGTH(n.name) > 5 and damlevlim256(n.name, bn.mom_first, 100) < 3)
                 )
                )
                or
                (
                  damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 AND
                  mn2.marriage_certificate_id = c.marriage_certificate_id and c.type = 0 and damlevlim256(c.name, bn.mom_first, 100) < 3
                )
              )
        limit 1)
  ;


# from female christian names to nick name direct or via synonyms (type = 6)
select count(*)
from test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_marriage
        ) and
        bn2.child_full != '' and bn2.mom_full != '' and bn2.dad_full != ''
    ) as bn, test.birth_names_christen as bc
where
    bn.birth_certificate_id = bc.birth_certificate_id and bc.type = 1 and
    mn.marriage_certificate_id = (select mn2.marriage_certificate_id as mid
        from test.marriage_names as mn2, test.names_synonyms as n
        where
          mn2.marriage_certificate_id not in (
                select marriage_certificate_id from test.marriage_names_christen where type = 0
          ) and
          # bn.dad_last =  mn2.groom_last and
          bn.dad_full =  mn2.groom_full and
          damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 and
          (
              (n.group_id = (select group_id from test.names_synonyms where name = mn2.bride_first group by name) and
               (
                 (LENGTH(n.name) <= 5 and damlevlim256(n.name, bc.name, 100) < (LENGTH(n.name) / 4)) or
                 (LENGTH(n.name) > 5 and damlevlim256(n.name, bc.name, 100) < 3)
               )
              )
              or
              (
                damlevlim256(bc.name, mn2.bride_first, 100) < 3
              )
          )
        order by damlevlim256(bc.name, mn2.bride_first, 100)
        LIMIT 1)
;



# from female christian names to nick name direct or via synonyms (type = 6)
select count(*)
from 
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_marriage
        ) and
        bn2.child_full != '' and bn2.mom_full != '' and bn2.dad_full != ''
    ) as bn

inner join 
where
    bn.birth_certificate_id = bc.birth_certificate_id and
    mn.marriage_certificate_id = (select mn2.marriage_certificate_id as mid
        from test.marriage_names as mn2, test.names_synonyms as n
        where
          mn2.marriage_certificate_id not in (
                select marriage_certificate_id from test.marriage_names_christen where type = 0
          ) and
          # bn.dad_last =  mn2.groom_last and
          bn.dad_full =  mn2.groom_full and
          damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 and
          (
              (n.group_id = (select group_id from test.names_synonyms where name = mn2.bride_first group by name) and
               (
                 (LENGTH(n.name) <= 5 and damlevlim256(n.name, bc.name, 100) < (LENGTH(n.name) / 4)) or
                 (LENGTH(n.name) > 5 and damlevlim256(n.name, bc.name, 100) < 3)
               )
              )
              or
              (
                damlevlim256(bc.name, mn2.bride_first, 100) < 3
              )
          )
        order by damlevlim256(bc.name, mn2.bride_first, 100)
        LIMIT 1)
;




select dad_first, count(*) as count
  from test.birth_names
  where
    birth_certificate_id not in (select birth_certificate_id from test.birth_names_christen)
  group by dad_first
  having count > 1
  order by count desc
;

select mom_first from test.birth_names where mom_first = 'Betje';

delete from test.name_synonyms where group_id >= 0;

select * from test.name_synonyms;

SELECT bn.dad_full, mn.groom_full
FROM test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn, test.birth_names_christen as bc
WHERE
    bn.birth_certificate_id = bc.birth_certificate_id and
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.mom_full = mn2.bride_full AND
              damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 AND
              bc.type = 2 and damlevlim256(bc.name, mn2.groom_first, 100) < 3
        order by damlevlim256(bc.name, mn2.groom_first, 100)
        LIMIT 1)
;

SELECT bn.mom_full, mn.bride_full
FROM test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn, test.birth_names_christen as bc
WHERE
    bn.birth_certificate_id = bc.birth_certificate_id and
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.dad_full = mn2.groom_full AND
              damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 AND
              bc.type = 1 and damlevlim256(bc.name, mn2.bride_first, 100) < 3
        order by damlevlim256(bc.name, mn2.bride_first, 100)
        LIMIT 1)
;

SELECT bn.mom_full, mn.bride_full
FROM test.marriage_names as mn,
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) and
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn, test.birth_names_christen as bc
WHERE
    bn.birth_certificate_id = bc.birth_certificate_id and
        bc.type = 1 and
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.dad_full = mn2.groom_full AND
              damlevlim256(bn.mom_last, mn2.bride_last, 255) < 3 AND
              damlevlim256(bc.name, mn2.bride_first, 100) < 3
        order by damlevlim256(bc.name, mn2.bride_first, 100)
        LIMIT 1)
;

SELECT test.SPLIT_STR(bn.mom_first, ' ', 1) as mom_first2, test.SPLIT_STR(mn.bride_first, ' ', 1) as bride_first2, bn.mom_full, mn.bride_full
FROM  test.marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM test.birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM test.marriage_names as mn2
        WHERE bn.dad_full = mn2.groom_full AND
                damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 AND
                damlevlim256(test.SPLIT_STR(bn.mom_first, ' ', 1), test.SPLIT_STR(mn2.bride_first, ' ', 1), 255) < 8 AND
                test.SPLIT_STR(bn.mom_first, ' ', 1) != test.SPLIT_STR(mn2.bride_first, ' ', 1)
        ORDER BY damlevlim256(bn.mom_full, mn2.bride_full, 255) ASC
        LIMIT 1) and
    test.SPLIT_STR(bn.mom_first, ' ', 1) = 'Maria' AND test.SPLIT_STR(mn.bride_first, ' ', 1) = 'Anna'
;

select year(datum) as year, count(*) as certificates
  from test.birth_certificates
  group by year
  having certificates > 20 and year != 0
;

select year(datum) as jaar, count(*) as certificates
  from test.marriage_certificates
  group by jaar
  having certificates > 20 and jaar != 0
;

select year(datum) as jaar, count(*) as certificates
  from test.death_certificates
  group by jaar
  having certificates > 20 and jaar != 0
;

select year(begraafdatum) as jaar, count(*) as certificates
  from test.buried_certificates
  group by jaar
  having certificates > 20 and jaar != 0
;

select ps.latitude, ps.longitude, count(*) as count
  from test.birth_certificates as bc, test.places_synonyms as ps
  where bc.plaats = ps.name
  group by bc.plaats
  order by count desc
;

select count(*)
from test.marriage_names as m, test.death_full_names as d
  where m.bride_full = d.person and m.bride_dad_full = d.dad and m.bride_mom_full = d.mom;

select count(*)
from test.marriage_names as m, test.death_full_names as d
  where m.groom_full = d.person and m.groom_dad_full = d.dad and m.groom_mom_full = d.mom;

select count(*)
from test.marriage_names as m, test.death_full_names as d1, test.death_full_names as d2
  where m.groom_full = d1.person and m.groom_dad_full = d1.dad and m.groom_mom_full = d1.mom and
  m.bride_full = d2.person and m.bride_dad_full = d2.dad and m.bride_mom_full = d2.mom
;

select count(*)
from test.marriage_names as m, test.birth_names b1, test.birth_names as b2
  where m.groom_full = b1.child_full and m.groom_dad_full = b1.dad_full and m.groom_mom_full = b1.mom_full and
  m.bride_full = b2.child_full and m.bride_dad_full = b2.dad_full and m.bride_mom_full = b2.mom_full
;

select count(*)
  from test.death_full_names as d, test.birth_names as m
  where
    d.person = m.child_full and d.mom = m.mom_full and d.dad = m.dad_full;

select plaats, count(*) from test.death_certificates
group by plaats;


select ps.latitude as lat, ps.longitude as lng, count(*) as count
  from test.death_certificates as mc, test.places_synonyms as ps
    where mc.plaats = ps.name
  group by mc.plaats
  order by count desc
;

select sum(certificates) from (select bc.plaats, count(*) as certificates, ps.latitude, ps.longitude
  from test.birth_certificates as bc, test.places_synonyms as ps
  where bc.plaats = ps.name
  group by bc.plaats
  order by certificates desc) as a
;

select count(*) from test.birth_certificates;

select distinct plaats
from test.birth_certificates
  where plaats not in(select name from test.places_synonyms)
;

SELECT test.SPLIT_STR(mom_first, ' ', 1) as name1, test.SPLIT_STR(mom_first, ' ', 2) as name2, test.SPLIT_STR(mom_first, ' ', 3) as name3
FROM test.birth_names
where mom_first != ''
and LENGTH(mom_first) - LENGTH(REPLACE(mom_first, ' ', '')) + 1 = 2
order by mom_first;

insert into test.birth_names_christen(birth_certificate_id, type, position, name)
SELECT birth_certificate_id, child_first
FROM test.birth_names
where child_first != '' and LENGTH(child_first) - LENGTH(REPLACE(child_first, ' ', ''))+1 = 1
;





-- test

select count(*)
from 
    (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
            bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
            bn2.dad_middle, bn2.dad_last
        from test.birth_names as bn2
        where bn2.birth_certificate_id not in (
            select birth_certificate_id from test.birth_marriage
        ) and
        bn2.child_full != '' and bn2.mom_full != '' and bn2.dad_full != ''
        limit 1000
    ) as bn
inner join birth_names_christen as bc on 
      bn.birth_certificate_id = bc.birth_certificate_id and bc.type = 1
inner join birth_names_christen as bc2 on 
      bn.birth_certificate_id = bc2.birth_certificate_id and bc2.type = 2
left join names_synonyms as bc_synonyms on 
      bc_synonyms.name = bc.`name`
left join names_synonyms as bc2_synonyms on 
      bc2_synonyms.name = bc2.`name`
inner join marriage_names as mn on
        mn.marriage_certificate_id not in (
                select marriage_certificate_id from test.marriage_names_christen where type = 0 or type = 1
          ) and
          damlevlim256(bn.mom_last, mn.bride_last, 255) < 2 and
          damlevlim256(bn.dad_last, mn.groom_last, 255) < 2
inner join names_synonyms ON
      (
              (n.group_id = (select group_id from test.names_synonyms where name = mn.bride_first group by name) and
               (
                 (LENGTH(n.name) <= 5 and damlevlim256(n.name, bc.name, 100) < (LENGTH(n.name) / 4)) or
                 (LENGTH(n.name) > 5 and damlevlim256(n.name, bc.name, 100) < 3)
               )
              )
              or
              (
                damlevlim256(bc.name, mn.bride_first, 100) < 3
              )
          ) 
        and         
          (
              (n.group_id = (select group_id from test.names_synonyms where name = mn.groom_first group by name) and
               (
                 (LENGTH(n.name) <= 5 and damlevlim256(n.name, bc2.name, 100) < (LENGTH(n.name) / 4)) or
                 (LENGTH(n.name) > 5 and damlevlim256(n.name, bc2.name, 100) < 3)
               )
              )
              or
              (
                damlevlim256(bc2.name, mn.groom_first, 100) < 3
              )
          )
;


select  *
from 
    marriage_names as mn
inner join 
    (
      (select bn2.birth_certificate_id, bn2.mom_full, bn2.mom_first,
              bn2.mom_middle, bn2.mom_last, bn2.dad_full, bn2.dad_first,
              bn2.dad_middle, bn2.dad_last
          from test.birth_names as bn2
          where bn2.birth_certificate_id not in (
              select birth_certificate_id from test.birth_marriage
          ) and
          bn2.child_full != '' and bn2.mom_full != '' and bn2.dad_full != ''
      ) as bn
      inner join birth_names_christen as bc on 
            bn.birth_certificate_id = bc.birth_certificate_id and bc.type = 1
      inner join birth_names_christen as bc2 on 
            bn.birth_certificate_id = bc2.birth_certificate_id and bc2.type = 2
      left outer join names_synonyms as bc_synonym_group on 
            bc_synonym_group.name = bc.`name`
      left outer join names_synonyms as bc2_synonym_group on 
            bc2_synonym_group.name = bc2.`name`
      left outer join names_synonyms as bc_synonyms ON
            bc_synonyms.group_id = bc_synonym_group.group_id
      left outer join names_synonyms as bc2_synonyms ON
            bc2_synonyms.group_id = bc2_synonym_group.group_id
  )
  on
          bn.mom_last =  mn.bride_last and
          bn.dad_last =  mn.groom_last and
          (
               (
                  damlevlim256(bc_synonyms.name, mn.bride_first, 100) < 3
               )
              or
              (
                damlevlim256(bc.name, mn.bride_first, 100) < 3
              )
          ) 
        and         
         (
               (
                  damlevlim256(bc2_synonyms.name, mn.groom_first, 100) < 3
               )
              or
              (
                damlevlim256(bc2.name, mn.groom_first, 100) < 3
              )
          ) 
where mn.marriage_certificate_id not in (
                select marriage_certificate_id from test.marriage_names_christen where type = 0 or type = 1
          ) and mn.marriage_certificate_id not in (
                select marriage_certificate_id from birth_marriage
          ) 
limit 100;




select bn.mom_full, mn.bride_full, bn.dad_full, mn.groom_full,  YEAR(bc.datum) - YEAR(mc.datum) , mc.plaats
from birth_marriage_potential as pot
join birth_names as bn
        on bn.birth_certificate_id = pot.birth_certificate_id and 
        bn.birth_certificate_id not in (
                select birth_certificate_id from birth_names_christen where type = 1 or type = 2 
        )
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and mc.plaats = bc.plaats
limit 1000
;

select count(*)
from birth_marriage as bm
join marriage_certificates as mc on 
  mc.marriage_certificate_id = bm.marriage_certificate_id
join birth_certificates as bc on 
  bc.birth_certificate_id = bm.birth_certificate_id
where YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and mc.plaats = bc.plaats;

select bn.birth_certificate_id, mn.marriage_certificate_id, bn.mom_full, mn.bride_full, bn.dad_full, 
            mn.groom_full,  YEAR(bc.datum) - YEAR(mc.datum) as date_range , mc.plaats
from birth_marriage_potential as pot
join birth_names as bn
        on bn.birth_certificate_id = pot.birth_certificate_id and 
        bn.birth_certificate_id not in (
                select birth_certificate_id from birth_names_christen where type = 1 or type = 2 
        )
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and damlevlim256(bn.mom_full, mn.bride_full, 255) < 3 and
          damlevlim256(bn.dad_full, mn.groom_full, 255) < 3
having date_range < 40 and date_range > 0 
order by date_range, pot.distance_bride, pot.distance_groom
limit 100000
;

select name from names_synonyms where group_id = (select group_id from names_synonyms where `name` = 'Maria');


select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as distance, bn.dad_full, 
            mn.groom_full, YEAR(bc.datum) - YEAR(mc.datum) as date_range, mc.plaats
from birth_marriage_potential as pot
join birth_names as bn
        on bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 
              and mc.plaats = bc.plaats  and bn.dad_full = mn.groom_full
group by bn.dad_full, mn.groom_full
having count(*) = 1
order by  YEAR(bc.datum) - YEAR(mc.datum)

-- Type = 7
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255) , damlevlim256(bn.dad_full, mn.groom_full, 255) ,  7
from birth_marriage_potential as pot
join birth_names as bn
        on bn.birth_certificate_id = pot.birth_certificate_id and 
        bn.birth_certificate_id not in (
                select birth_certificate_id from birth_names_christen where type = 1 or type = 2 
        )
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and   damlevlim256(bn.mom_full, mn.bride_full, 255) < 3 and
          damlevlim256(bn.dad_full, mn.groom_full, 255) < 3

-- Deleted from potential table
delete from birth_marriage_potential where birth_certificate_id in (
select birth_certificate_id
from birth_marriage)
;

-- Type = 8
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 8
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bns on 
        bns.birth_certificate_id = bn.birth_certificate_id and bns.type = 1
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and mns.`name` = bns.`name`
group by mn.groom_full, bn.dad_full
having count(*) = 1

-- Type = 9
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 9
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bns on 
        bns.birth_certificate_id = bn.birth_certificate_id and bns.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and mns.`name` = bns.`name`
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 10
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 10
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
        and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 2)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and mns.`name` = bn.dad_first
group by mn.bride_full, bn.mom_full
having count(*) = 1

INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 10
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
        and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 2)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and damlevlim256(mns.`name`, bn.dad_first, 100) < 3
group by mn.bride_full, bn.mom_full
having count(*) = 1

-- Type = 11
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 11
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
        and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 1)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and mns.`name` = bn.mom_first
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 12
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 11
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
        and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 1)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and damlevlim256(bn.mom_first, mns.`name`, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 13
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 13
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
        and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 2)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = mns.`name` group by mns.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and damlevlim256(bn.dad_first, ns.`name`, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 14
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 14
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc on 
        bnc.birth_certificate_id = bn.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 0)
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = bnc.`name` group by bnc.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and damlevlim256(mn.bride_first, ns.`name`, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 15
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 15
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc on 
        bnc.birth_certificate_id = bn.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 1)
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = bnc.`name` group by bnc.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and damlevlim256(mn.groom_first, ns.`name`, 255) < 3
group by mn.groom_full, bn.dad_full
having count(*) = 1

-- Type = 16
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 16
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 0 or type = 1)
join names_synonyms as ns_female on 
        ns_female.group_id = (select group_id from names_synonyms where name  = bnc_female.`name` group by bnc_female.name)
join names_synonyms as ns_male on  
        ns_male.group_id = (select group_id from names_synonyms where name = bnc_male.name group by bnc_male.name)  
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            ns_male.`name` = mn.groom_first and mn.bride_first = ns_female.`name`

-- Type = 17
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 17
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id
join marriage_names_christen as mnc_female on 
        mnc_female.marriage_certificate_id = mn.marriage_certificate_id and mnc_female.type = 0
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            bnc_male.`name` = mnc_male.`name` and mnc_female.`name`= bnc_female.`name`
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 18
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 18
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id
join marriage_names_christen as mnc_female on 
        mnc_female.marriage_certificate_id = mn.marriage_certificate_id and mnc_female.type = 0
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            damlevlim256(bnc_male.`name` , mnc_male.`name` , 100) < 3 and damlevlim256(mnc_female.`name`, bnc_female.`name`, 100) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 19 (= 18 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 19
from birth_marriage_potential as pot
join birth_names as bn
        on bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  (mn.bride_full = bn.mom_full or bn.dad_full = mn.groom_full)
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 20 (= 17 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 20
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id
join marriage_names_christen as mnc_female on 
        mnc_female.marriage_certificate_id = mn.marriage_certificate_id and mnc_female.type = 0
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            bnc_male.`name` = mnc_male.`name` and mnc_female.`name`= bnc_female.`name`
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 21 (= 15 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 21
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc on 
        bnc.birth_certificate_id = bn.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 1)
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = bnc.`name` group by bnc.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and damlevlim256(mn.groom_first, ns.`name`, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 22 (= 14 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 22
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc on 
        bnc.birth_certificate_id = bn.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 0)
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = bnc.`name` group by bnc.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and damlevlim256(mn.bride_first, ns.`name`, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 23 (= 13 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 23
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 2)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = mns.`name` group by mns.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and damlevlim256(bn.dad_first, ns.`name`, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 24 (= 12 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 24
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 1)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and damlevlim256(bn.mom_first, mns.`name`, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 25 (= 10 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 25
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 2)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and damlevlim256(mns.`name`, bn.dad_first, 100) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 26 (= 9 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 26
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bns on 
        bns.birth_certificate_id = bn.birth_certificate_id and bns.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and mns.`name` = bns.`name`
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 27 (= 8 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
            damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, 27
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bns on 
        bns.birth_certificate_id = bn.birth_certificate_id and bns.type = 1
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and mns.`name` = bns.`name`
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 28 (= 7 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 28
from birth_marriage_potential as pot
join birth_names as bn
        on bn.birth_certificate_id = pot.birth_certificate_id and 
        bn.birth_certificate_id not in (
                select birth_certificate_id from birth_names_christen where type = 1 or type = 2 
        )
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and   damlevlim256(bn.mom_full, mn.bride_full, 255) < 3 and
          damlevlim256(bn.dad_full, mn.groom_full, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 29
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 29
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id 
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(mnc_male.name, bnc_male.name, 255) < 3
             and damlevlim256(bn.mom_first, mn.bride_first, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 30
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 30
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and 
            damlevlim256(bn.dad_first, mn.groom_first, 255) < 3 and damlevlim256(bn.mom_first, mn.bride_first, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 31 (=30 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 31
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and 
            damlevlim256(bn.dad_first, mn.groom_first, 255) < 3 and damlevlim256(bn.mom_first, mn.bride_first, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 32
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 32
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mnc_bride on 
        mnc_bride.marriage_certificate_id = mn.marriage_certificate_id and mnc_bride.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_dad on 
        ns_dad.group_id = (select group_id from names_synonyms where name = bn.dad_first group by name)
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and damlevlim256(ns_dad.name, mn.groom_first, 255)  < 3
            and damlevlim256(mnc_bride.name, bn.mom_first, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 33 (=32 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 33
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mnc_bride on 
        mnc_bride.marriage_certificate_id = mn.marriage_certificate_id and mnc_bride.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_dad on 
        ns_dad.group_id = (select group_id from names_synonyms where name = bn.dad_first group by name)
where
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and damlevlim256(ns_dad.name, mn.groom_first, 255)  < 3
            and damlevlim256(mnc_bride.name, bn.mom_first, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 34
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 34
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_dad on 
        ns_dad.group_id = (select group_id from names_synonyms where name = bn.dad_first group by name)
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(bn.mom_first, mn.bride_first, 255)  < 3
            and damlevlim256(ns_dad.name, mn.groom_first, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 35 (=34 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 35
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_dad on 
        ns_dad.group_id = (select group_id from names_synonyms where name = bn.dad_first group by name)
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(bn.mom_first, mn.bride_first, 255)  < 3
            and damlevlim256(ns_dad.name, mn.groom_first, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 36
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 36
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_male on  
        ns_male.group_id = (select group_id from names_synonyms where name = bnc_male.name group by bnc_male.name) 
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(bn.mom_first, mn.bride_first, 255)  < 3
            and damlevlim256(ns_male.name, mnc_male.name, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 37 (=36 met plaats != plaats)
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 37
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_male on  
        ns_male.group_id = (select group_id from names_synonyms where name = bnc_male.name group by bnc_male.name) 
where
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(bn.mom_first, mn.bride_first, 255)  < 3
            and damlevlim256(ns_male.name, mnc_male.name, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 38 
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 38
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_dad on 
        ns_dad.group_id = (select group_id from names_synonyms where name = bn.dad_first group by name)
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(bn.mom_first, mn.bride_first, 255)  <= 3
            and damlevlim256(ns_dad.name, mn.groom_first, 255)  <= 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 39
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 39
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mnc_groom on 
        mnc_groom.marriage_certificate_id = mn.marriage_certificate_id and mnc_groom.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_dad on 
        ns_dad.group_id = (select group_id from names_synonyms where name = bn.dad_first group by name)
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(bn.mom_first, mn.bride_first, 255)  < 3
            and damlevlim256(ns_dad.name, mnc_groom.name, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 40
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 40
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_dad on
        bnc_dad.birth_certificate_id = bn.birth_certificate_id  and bnc_dad.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
join names_synonyms as ns_groom on 
        ns_groom.group_id = (select group_id from names_synonyms where name = mn.groom_first group by name)
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(bn.mom_first, mn.bride_first, 255)  < 3
            and damlevlim256(ns_groom.name, bnc_dad.name, 255)  < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 41
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 41
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen_all as bnc_mom on 
        bnc_mom.birth_certificate_id = bn.birth_certificate_id and bnc_mom.type = 1
join birth_names_christen_all as bnc_dad on 
        bnc_dad.birth_certificate_id = bn.birth_certificate_id and bnc_dad.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen_all as mnc_bride on 
        mnc_bride.marriage_certificate_id = mn.marriage_certificate_id and mnc_bride.type = 0
join marriage_names_christen_all as mnc_groom on 
        mnc_groom.marriage_certificate_id = mn.marriage_certificate_id and mnc_groom.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and bc.plaats = mc.plaats
            and damlevlim256(bnc_dad.name, mnc_groom.name, 255) < 3
            and damlevlim256(bnc_mom.name, mnc_bride.name, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 42
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 42
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen_all as bnc_mom on 
        bnc_mom.birth_certificate_id = bn.birth_certificate_id and bnc_mom.type = 1
join names_synonyms as bnc_mom_syn on 
        bnc_mom_syn.group_id = (select group_id from names_synonyms where name = bnc_mom.name group by name)
join birth_names_christen_all as bnc_dad on 
        bnc_dad.birth_certificate_id = bn.birth_certificate_id and bnc_dad.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen_all as mnc_bride on 
        mnc_bride.marriage_certificate_id = mn.marriage_certificate_id and mnc_bride.type = 0
join marriage_names_christen_all as mnc_groom on 
        mnc_groom.marriage_certificate_id = mn.marriage_certificate_id and mnc_groom.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and bc.plaats = mc.plaats
            and damlevlim256(bnc_dad.name, mnc_groom.name, 255) < 3
            and damlevlim256(bnc_mom_syn.name, mnc_bride.name, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id

-- Type = 43
INSERT ignore INTO test.birth_marriage(birth_certificate_id, marriage_certificate_id, distance_mom, distance_dad, type)
select bn.birth_certificate_id, mn.marriage_certificate_id,  damlevlim256(bn.mom_full, mn.bride_full, 255), 
damlevlim256(bn.dad_full, mn.groom_full, 255) , 43
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen_all as bnc_mom on 
        bnc_mom.birth_certificate_id = bn.birth_certificate_id and bnc_mom.type = 1
join birth_names_christen_all as bnc_dad on 
        bnc_dad.birth_certificate_id = bn.birth_certificate_id and bnc_dad.type = 2
join names_synonyms as bnc_dad_syn on 
        bnc_dad_syn.group_id = (select group_id from names_synonyms where name = bnc_dad.name group by name)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen_all as mnc_bride on 
        mnc_bride.marriage_certificate_id = mn.marriage_certificate_id and mnc_bride.type = 0
join marriage_names_christen_all as mnc_groom on 
        mnc_groom.marriage_certificate_id = mn.marriage_certificate_id and mnc_groom.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where 
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and bc.plaats = mc.plaats
            and damlevlim256(bnc_dad_syn.name, mnc_groom.name, 255) < 3
            and damlevlim256(bnc_mom.name, mnc_bride.name, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id






-- Deleted from potential table
delete from birth_marriage_potential where birth_certificate_id in (
select birth_certificate_id
from birth_marriage)
;









select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bns on 
        bns.birth_certificate_id = bn.birth_certificate_id and bns.type = 1
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 3) and mns.`name` = bns.`name`
group by mn.groom_full, bn.dad_full
having count(*) = 1

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bns on 
        bns.birth_certificate_id = bn.birth_certificate_id and bns.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and mns.`name` = bns.`name`
group by mn.bride_full, bn.mom_full
having count(*) = 1

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 2)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.mom_full, mn.bride_full, 255) < 5) and mns.`name` = bn.dad_first
group by mn.bride_full, bn.mom_full
having count(*) = 1

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 1)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and mns.`name` = bn.mom_first
group by mn.groom_full, bn.dad_full
having count(*) = 1

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 1)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and damlevlim256(bn.mom_first, mns.`name`, 255) < 3
group by mn.groom_full, bn.dad_full
having count(*) = 1

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id and bn.birth_certificate_id not in (select birth_certificate_id from birth_names_christen where type = 1)
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_names_christen as mns on 
        mns.marriage_certificate_id = mn.marriage_certificate_id and mns.type = 0
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = mns.`name` group by mns.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and damlevlim256(bn.mom_first, ns.`name`, 255) < 3
group by mn.groom_full, bn.dad_full
having count(*) = 1

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc on 
        bnc.birth_certificate_id = bn.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 0)
join names_synonyms as ns on 
        ns.group_id = (select group_id from names_synonyms where name  = bnc.`name` group by bnc.name)
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and  
            (damlevlim256(bn.dad_full, mn.groom_full, 255) < 5) and damlevlim256(mn.bride_first, ns.`name`, 255) < 3
group by mn.groom_full, bn.dad_full
having count(*) = 1


select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 0 or type = 1)
join names_synonyms as ns_female on 
        ns_female.group_id = (select group_id from names_synonyms where name  = bnc_female.`name` group by bnc_female.name)
join names_synonyms as ns_male on  
        ns_male.group_id = (select group_id from names_synonyms where name = bnc_male.name group by bnc_male.name)  
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            ns_male.`name` = mn.groom_first and mn.bride_first = ns_female.`name`
group by mn.groom_full, bn.dad_full
having count(*) = 1

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id not in (
              select marriage_certificate_id from marriage_names_christen where  type = 0 or type = 1)
join names_synonyms as ns_female on 
        ns_female.group_id = (select group_id from names_synonyms where name  = bnc_female.`name` group by bnc_female.name)
join names_synonyms as ns_male on  
        ns_male.group_id = (select group_id from names_synonyms where name = bnc_male.name group by bnc_male.name)  
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            ns_male.`name` = mn.groom_first and mn.bride_first = ns_female.`name`

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id
join marriage_names_christen as mnc_female on 
        mnc_female.marriage_certificate_id = mn.marriage_certificate_id and mnc_female.type = 0
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            bnc_male.`name` = mnc_male.`name` and mnc_female.`name`= bnc_female.`name`
group by bn.birth_certificate_id, mn.marriage_certificate_id

select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_names_christen as bnc_female on 
        bnc_female.birth_certificate_id = bn.birth_certificate_id and bnc_female.type = 1
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id and mn.marriage_certificate_id
join marriage_names_christen as mnc_female on 
        mnc_female.marriage_certificate_id = mn.marriage_certificate_id and mnc_female.type = 0
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 and 
            damlevlim256(bnc_male.`name` , mnc_male.`name` , 100) < 3 and damlevlim256(mnc_female.`name`, bnc_female.`name`, 100) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id



select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats, mc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0 
group by bn.birth_certificate_id, mn.marriage_certificate_id
limit 1000



select bn.birth_certificate_id as bid, mn.marriage_certificate_id as mid,  bn.mom_full, mn.bride_full, damlevlim256(bn.mom_full, mn.bride_full, 255) as dis_bride , 
bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn.groom_full, 255)  as dis_groom, YEAR(bc.datum) - YEAR(mc.datum)  as dis_date, bc.plaats, mc.plaats
from birth_marriage_potential as pot
join birth_names as bn on
        bn.birth_certificate_id = pot.birth_certificate_id
join birth_certificates as bc on 
        bc.birth_certificate_id = bn.birth_certificate_id
join birth_names_christen as bnc_male on 
        bnc_male.birth_certificate_id = bn.birth_certificate_id and bnc_male.type = 2
join marriage_names as mn on 
        mn.marriage_certificate_id = pot.marriage_certificate_id 
join marriage_names_christen as mnc_male on 
        mnc_male.marriage_certificate_id = mn.marriage_certificate_id and mnc_male.type = 1
join marriage_certificates as mc on 
        mc.marriage_certificate_id = mn.marriage_certificate_id
where mc.plaats = bc.plaats and
            YEAR(bc.datum) - YEAR(mc.datum) < 40 and YEAR(bc.datum) - YEAR(mc.datum) > 0  and damlevlim256(mnc_male.name, bnc_male.name, 255) < 3
             and damlevlim256(bn.mom_first, mn.bride_first, 255) < 3
group by bn.birth_certificate_id, mn.marriage_certificate_id