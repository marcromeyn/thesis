DELIMITER ||



/*
	levenshtein & levenshtein_ratio
	by Federico Razzoli
	santec@riseup.net
	
	levenshtein is a fork of an Arjen Lentz function (reported below).
*/

-- version: 1
DROP FUNCTION IF EXISTS `levenshtein`;
CREATE FUNCTION `levenshtein`(`s1` VARCHAR(255) CHARACTER SET utf8, `s2` VARCHAR(255) CHARACTER SET utf8)
	RETURNS TINYINT UNSIGNED
	NO SQL
	DETERMINISTIC
BEGIN
	DECLARE s1_len, s2_len, i, j, c, c_temp TINYINT UNSIGNED;
	-- max strlen=255 for this function
	DECLARE cv0, cv1 VARBINARY(256);
	
	-- if any param is NULL return NULL
	-- (consistent with builtin functions)
	IF (s1 + s2) IS NULL THEN
		RETURN NULL;
	END IF;
	
	SET s1_len = CHAR_LENGTH(s1),
		s2_len = CHAR_LENGTH(s2),
		cv1 = 0x00,
		j = 1,
		i = 1,
		c = 0;
	
	-- if any string is empty,
	-- distance is the length of the other one
	IF (s1 = s2) THEN
		RETURN 0;
	ELSEIF (s1_len = 0) THEN
		RETURN s2_len;
	ELSEIF (s2_len = 0) THEN
		RETURN s1_len;
	END IF;
	
	WHILE (j <= s2_len) DO
		SET cv1 = CONCAT(cv1, CHAR(j)),
		j = j + 1;
	END WHILE;
	
	WHILE (i <= s1_len) DO
		SET c = i,
			cv0 = CHAR(i),
			j = 1;
		
		WHILE (j <= s2_len) DO
			SET c = c + 1;
			
			SET c_temp = ORD(SUBSTRING(cv1, j, 1)) -- ord of cv1 current char
				+ (NOT (SUBSTRING(s1, i, 1) = SUBSTRING(s2, j, 1))); -- different chars? (NULL-safe)
			IF (c > c_temp) THEN
				SET c = c_temp;
			END IF;
			
			SET c_temp = ORD(SUBSTRING(cv1, j+1, 1)) + 1;
			IF (c > c_temp) THEN
				SET c = c_temp;
			END IF;
			
			SET cv0 = CONCAT(cv0, CHAR(c)),
				j = j + 1;
		END WHILE;
		
		SET cv1 = cv0,
			i = i + 1;
	END WHILE;
	
	RETURN c;
END;


-- version: 1
DROP FUNCTION IF EXISTS `levenshtein_ratio`;
CREATE FUNCTION `levenshtein_ratio`(`s1` VARCHAR(255) CHARACTER SET utf8, `s2` VARCHAR(255) CHARACTER SET utf8)
	RETURNS TINYINT UNSIGNED
	DETERMINISTIC
	NO SQL
	COMMENT 'Levenshtein ratio between strings'
BEGIN
	DECLARE s1_len TINYINT UNSIGNED DEFAULT CHAR_LENGTH(s1);
	DECLARE s2_len TINYINT UNSIGNED DEFAULT CHAR_LENGTH(s2);
	RETURN ((levenshtein(s1, s2) / IF(s1_len > s2_len, s1_len, s2_len)) * 100);
END;


-- Aren Lentz's Function
-- http://openquery.com/blog/levenshtein-mysql-stored-function

-- core levenshtein function adapted from
-- function by Jason Rust (http://sushiduy.plesk3.freepgs.com/levenshtein.sql)
-- originally from http://codejanitor.com/wp/2007/02/10/levenshtein-distance-as-a-mysql-stored-function/
-- rewritten by Arjen Lentz for utf8, code/logic cleanup and removing HEX()/UNHEX() in favour of ORD()/CHAR()
-- Levenshtein reference: http://en.wikipedia.org/wiki/Levenshtein_distance

-- Arjen note: because the levenshtein value is encoded in a byte array, distance cannot exceed 255;
-- thus the maximum string length this implementation can handle is also limited to 255 characters.


DROP FUNCTION IF EXISTS LEVENSHTEIN_lentz;
CREATE FUNCTION LEVENSHTEIN_lentz(s1 VARCHAR(255) CHARACTER SET utf8, s2 VARCHAR(255) CHARACTER SET utf8)
	RETURNS INT
	DETERMINISTIC
BEGIN
	DECLARE s1_len, s2_len, i, j, c, c_temp, cost INT;
	DECLARE s1_char CHAR CHARACTER SET utf8;
	-- max strlen=255 for this function
	DECLARE cv0, cv1 VARBINARY(256);

	SET s1_len = CHAR_LENGTH(s1),
		s2_len = CHAR_LENGTH(s2),
		cv1 = 0x00,
		j = 1,
		i = 1,
		c = 0;

	IF (s1 = s2) THEN
		RETURN (0);
	ELSEIF (s1_len = 0) THEN
		RETURN (s2_len);
	ELSEIF (s2_len = 0) THEN
		RETURN (s1_len);
	END IF;

	WHILE (j <= s2_len) DO
		SET cv1 = CONCAT(cv1, CHAR(j)),
		j = j + 1;
	END WHILE;

	WHILE (i <= s1_len) DO
		SET s1_char = SUBSTRING(s1, i, 1),
		c = i,
		cv0 = CHAR(i),
		j = 1;

		WHILE (j <= s2_len) DO
			SET c = c + 1,
			cost = IF(s1_char = SUBSTRING(s2, j, 1), 0, 1);

			SET c_temp = ORD(SUBSTRING(cv1, j, 1)) + cost;
			IF (c > c_temp) THEN
				SET c = c_temp;
			END IF;

			SET c_temp = ORD(SUBSTRING(cv1, j+1, 1)) + 1;
			IF (c > c_temp) THEN
				SET c = c_temp;
			END IF;

			SET cv0 = CONCAT(cv0, CHAR(c)),
				j = j + 1;
		END WHILE;

		SET cv1 = cv0,
		i = i + 1;
	END WHILE;

	RETURN (c);
END;


||
DELIMITER ;