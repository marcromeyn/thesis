SELECT * FROM test.birth_marriage;

SELECT COUNT(*) FROM test.birth_marriage;
SELECT COUNT(*) FROM test.birth_names_full WHERE dad = '';

SELECT COUNT(count) FROM (SELECT COUNT(*) as count
FROM birth_names_full as bn, marriage_names_full as mn
WHERE
    bn.birth_certificate_id NOT IN(
        SELECT birth_certificate_id FROM birth_marriage
    ) AND
    bn.child != '' AND bn.mom != '' AND bn.dad != '' AND
    bn.mom = mn.bride AND
    damlevlim256(bn.dad, mn.groom, 255) < 5
GROUP BY bn.birth_certificate_id
HAVING COUNT(*) = 1) as a
;

SELECT COUNT(count) FROM (SELECT COUNT(*) as count
FROM birth_names_full as bn, marriage_names_full as mn
WHERE
    bn.birth_certificate_id NOT IN(
        SELECT birth_certificate_id FROM birth_marriage
    ) AND
    bn.child != '' AND bn.mom != '' AND bn.dad != '' AND
    bn.dad = mn.groom AND
    damlevlim256(bn.mom, mn.bride, 255) < 5
GROUP BY bn.birth_certificate_id
HAVING COUNT(*) = 1) as a
;

SELECT bn.birth_certificate_id, bn.dad, mn.groom, mn.marriage_certificate_id
FROM birth_names_full as bn, marriage_names_full as mn
WHERE
    bn.birth_certificate_id NOT IN(
        SELECT birth_certificate_id FROM birth_marriage
    ) AND
    bn.child != '' AND bn.mom != '' AND bn.dad != '' AND
    bn.mom = mn.bride AND
    damlevlim256(bn.dad, mn.groom, 255) < 5
GROUP BY bn.birth_certificate_id
HAVING COUNT(*) = 1;

SELECT COUNT(*)
FROM  marriage_names_full as mn,
    (select bn2.mom, bn2.dad
        from birth_names_full as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM birth_marriage
        ) AND
        bn2.child != '' AND bn2.mom != '' AND bn2.dad != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM marriage_names_full as mn2
        WHERE bn.dad = mn2.groom AND
                damlevlim256(bn.mom, mn2.bride, 255) < 5
        ORDER BY damlevlim256(bn.mom, mn2.bride, 255) ASC
        LIMIT 1)
;

SELECT bn.dad, mn.groom, damlevlim256(bn.dad, mn.groom, 255) as lev
FROM  marriage_names_full as mn,
    (select bn2.mom, bn2.dad
        from birth_names_full as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM birth_marriage
        ) AND
        bn2.child != '' AND bn2.mom != '' AND bn2.dad != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM marriage_names_full as mn2
        WHERE bn.mom = mn2.bride AND
                damlevlim256(bn.dad, mn2.groom, 255) < 5
        ORDER BY damlevlim256(bn.dad, mn2.groom, 255) ASC
        LIMIT 1)
;

SELECT bn.dad_full, mn.groom_full, damlevlim256(bn.dad_full, mn2.groom_full, 255) as lev
FROM  marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM marriage_names as mn2
        WHERE bn.mom_full = mn2.bride_full AND
                damlevlim256(bn.dad_last, mn2.groom_last, 255) < 2 AND
                damlevlim256(bn.dad_first, mn2.groom_first, 255) < 8
        ORDER BY damlevlim256(bn.dad_full, mn2.groom_full, 255) ASC
        LIMIT 1)
;

SELECT COUNT(*)
FROM  marriage_names as mn,
    (select bn2.mom_full, bn2.mom_first, bn2.mom_middle, bn2.mom_last,
        bn2.dad_full, bn2.dad_first, bn2.dad_middle, bn2.dad_last
        from birth_names as bn2
        where bn2.birth_certificate_id  NOT IN (
            SELECT birth_certificate_id FROM birth_marriage
        ) AND
        bn2.child_full != '' AND bn2.mom_full != '' AND bn2.dad_full != ''
    ) as bn
WHERE
    mn.marriage_certificate_id = (SELECT mn2.marriage_certificate_id as mid
        FROM marriage_names as mn2
        WHERE bn.dad_full = mn2.groom_full AND
                damlevlim256(bn.mom_last, mn2.bride_last, 255) < 2 AND
                damlevlim256(bn.mom_first, mn2.bride_first, 255) < 8
        ORDER BY damlevlim256(bn.mom_full, mn2.bride_full, 255) ASC
        LIMIT 1)
;