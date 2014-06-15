/*
	Test Case for levenshtein() and levenshtein_ratio() Stored Functions.
	To run them:
	* install STK/Unit: https://launchpad.net/stk-unit
	* run strins.sql and this file in MariaDB or MySQL
	* run the following statement:
		CALL stk_unit.tc('test_string_lib');
	* if something go wrong in the tests, please report to Federico Razzoli: santec@riseup.net
*/


DELIMITER ||


DROP DATABASE IF EXISTS `test_string_lib`;
CREATE DATABASE `test_string_lib`;
USE `test_string_lib`;


DROP PROCEDURE IF EXISTS `test_levenshtein`;
CREATE PROCEDURE `test_levenshtein`()
BEGIN
	-- with NULL
	CALL `stk_unit`.`assert_null`((SELECT `string_lib`.`levenshtein`(NULL, '12345')), '');
	CALL `stk_unit`.`assert_null`((SELECT `string_lib`.`levenshtein`('12345', NULL)), '');
	CALL `stk_unit`.`assert_null`((SELECT `string_lib`.`levenshtein`(NULL, NULL)), '');
	
	-- with empty param
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('', '12345')), 5, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('12345', '')), 5, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('', '')), 0, '');
	
	-- identical
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('12345', '12345')), 0, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('x', 'x')), 0, '');
	
	-- different
	
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('_____', '12345')), 5, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('123', '12345')), 2, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('345', '12345')), 2, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('234', '12345')), 2, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('_234_', '12345')), 2, '');
	
	-- reverse params
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('12345', '_____')), 5, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('12345', '123')), 2, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('12345', '345')), 2, '');
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('12345', '234')), 2, '');
	
	CALL `stk_unit`.`assert_equals`((SELECT `string_lib`.`levenshtein`('12345', '1___5')), 3, '');
END;


DROP PROCEDURE IF EXISTS `test_levenshtein_ratio`;



||
DELIMITER ;
