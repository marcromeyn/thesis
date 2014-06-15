SELECT first_name, middle_name, last_name, COUNT(*)
  FROM memorix.blog_reference_person
  WHERE first_name != ''
  GROUP BY first_name, middle_name, last_name
  HAVING COUNT(*) > 1;

SELECT SUM(persons) FROM( SELECT COUNT(*) as persons
  FROM memorix.blog_reference_person
  WHERE first_name != ''
  GROUP BY first_name, middle_name, last_name
  HAVING COUNT(*) > 1) as a;

SELECT COUNT(*) FROM test;

ALTER TABLE test.full_names_birth AUTO_INCREMENT = 0;

DELETE FROM test.full_names_birth WHERE birth_certificate_id > 0;

INSERT INTO test.birth_full_names(birth_certificate_id, child, mom, dad)
  SELECT birth_certificate_id,
    REPLACE(CONCAT_WS(' ', TRIM(vnamenkind), TRIM(tussenvkind), TRIM(achternkind)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornm), TRIM(tussenvm), TRIM(achtm)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornv), TRIM(tussenvv), TRIM(achtv)), '  ', ' ')
  FROM test.birth_certificates;

INSERT INTO test.full_names_marriage(marriage_certificate_id, bride, groom,
                                     dad_bride, dad_groom, mom_groom, mom_bride)
  SELECT marriage_certificate_id,
    REPLACE(CONCAT_WS(' ', TRIM(voornamenb), TRIM(tussenvb), TRIM(achtb)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornamenbg), TRIM(tussenvbg), TRIM(achtbg)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornvb), TRIM(tussvvb), TRIM(achtvb)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornvbg), TRIM(tussvvbg), TRIM(achtvbg)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornmbg), TRIM(tussvmbg), TRIM(achtmbg)), '  ', ' '),
    REPLACE(CONCAT_WS(' ', TRIM(voornmb), TRIM(tussvmb), TRIM(achtmb)), '  ', ' ')
  FROM test.marriage_certificates;

SELECT births.birth_certificate_id, birth_names.mom, birth_names.dad, marriage_names.marriage_certificate_id
  FROM test.birth_certificates as births
  INNER JOIN test.full_names_birth as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.full_names_marriage as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad;

SELECT COUNT(*) FROM test.marriage_certificates;


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


# Find the marriage certificate of the childs parents

SELECT COUNT(one_mar) FROM (SELECT COUNT(*) as one_mar
  FROM test.birth_certificates as births
  INNER JOIN test.full_names_birth as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.full_names_marriage as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad
  GROUP BY births.birth_certificate_id
  HAVING COUNT(*) = 1) AS a;

SELECT COUNT(one_mar) FROM (SELECT COUNT(*) as one_mar
  FROM test.birth_certificates as births
  INNER JOIN test.full_names_birth as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.full_names_marriage as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad
  INNER JOIN test.full_names_birth as birth_dad ON
      birth_dad.child = birth_names.dad AND
      birth_dad.dad = marriage_names.dad_groom AND
      birth_dad.mom = marriage_names.mom_groom
  INNER JOIN test.full_names_birth as birth_mom ON
      birth_mom.child = birth_names.mom AND
      birth_mom.dad = marriage_names.dad_bride AND
      birth_mom.mom = marriage_names.mom_bride
  GROUP BY births.birth_certificate_id
  HAVING COUNT(*) = 1) AS a;




SELECT COUNT(doubles), SUM(doubles) FROM (SELECT COUNT(*) AS doubles FROM test.full_names_marriage as a
  INNER JOIN test.full_names_marriage as b ON
    a.bride = b.bride AND
    a.groom = b.groom
  GROUP BY a.groom, a.bride
  HAVING COUNT(*) > 1) AS a;

