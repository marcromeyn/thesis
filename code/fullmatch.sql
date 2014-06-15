SELECT COUNT(one_mar) FROM (SELECT COUNT(*) as one_mar
  FROM test.birth_certificates as births
  INNER JOIN test.full_names_birth as birth_names
    ON births.birth_certificate_id = birth_names.birth_certificate_id
  INNER JOIN test.full_names_marriage as marriage_names
    ON marriage_names.bride = birth_names.mom AND
      marriage_names.groom = birth_names.dad
  GROUP BY births.birth_certificate_id
  HAVING COUNT(*) = 1) AS a;