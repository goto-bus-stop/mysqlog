-- WTFTJ Blog Engine

DELIMITER //

DROP FUNCTION IF EXISTS ShowPage //
CREATE FUNCTION ShowPage(content TEXT)
RETURNS TEXT
BEGIN
  RETURN (
    SELECT REPLACE(cont, '${content}', content)
    FROM templates
    WHERE name = 'layout'
  );
END //

DROP FUNCTION IF EXISTS GetUrlParam //
CREATE FUNCTION GetUrlParam(param VARCHAR(100))
RETURNS TEXT
BEGIN
  RETURN (SELECT value FROM params WHERE name = param);
END //

DROP FUNCTION IF EXISTS GetStringParam //
CREATE FUNCTION GetStringParam(qs TEXT, param VARCHAR(100))
RETURNS TEXT
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE j INT DEFAULT 0;
  SET i = LOCATE(CONCAT(param, '='), qs) + LENGTH(param) + 1;
  SET j = LOCATE('&', qs, i + 1);
  IF j THEN
    RETURN SUBSTRING(qs, i, j - i);
  ELSE
    RETURN SUBSTRING(qs, i);
  END IF;
END //

DROP FUNCTION IF EXISTS LoggedIn //
CREATE FUNCTION LoggedIn()
RETURNS INT
BEGIN
  RETURN 1;
END //

DROP FUNCTION IF EXISTS AddComment //
CREATE FUNCTION AddComment(post INT, user INT, content TEXT)
RETURNS INT
BEGIN
  INSERT INTO comments ( pid, uid, content ) VALUES ( post, user, content );
  RETURN 1;
END //

DELIMITER ;