DROP PROCEDURE IF EXISTS Route;

DELIMITER //

CREATE PROCEDURE Route(IN url VARCHAR(100), IN POST TEXT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE j INT DEFAULT 1;
  DECLARE varLoc INT DEFAULT 1;

  SET url = (SELECT SUBSTRING(url, LENGTH(value) + 1) FROM config WHERE name = 'base');
  SET @func = (
    SELECT p.func
    FROM pages p, routes r
    WHERE url REGEXP r.path AND p.name = r.resolve
  );

  SET @parseAs = (SELECT parseAs FROM routes WHERE url REGEXP path);

  -- URL parameters will be stored in here
  CREATE TEMPORARY TABLE params (
    name VARCHAR(50) NOT NULL,
    value VARCHAR(100) NOT NULL
  );

  -- Append slashes so the url parser doesn't stop too early
  IF RIGHT(@parseAs, 1) != '/' THEN
    SET @parseAs = CONCAT(@parseAs, '/');
  END IF;
  IF RIGHT(url, 1) != '/' THEN
    SET url = CONCAT(url, '/');
  END IF;

  -- While there is an @var in the url, walk over both the given url and the
  -- parser reference url, finding the corresponding parts of both
  -- then store them in the `params` table
  -- @todo Make this work for any url and not just @vars enclosed by slashes
  WHILE varLoc != 0 DO

    SET varLoc = LOCATE('@', @parseAs, i);
    SET i = LOCATE('/', @parseAs, i + 1);
    SET j = LOCATE('/', url, j + 1);

    IF varLoc - 1 = i THEN
      SET @name = SUBSTRING(@parseAs, varLoc + 1, LOCATE('/', @parseAs, varLoc) - varLoc - 1);
      SET @value = SUBSTRING(url, j + 1, LOCATE('/', url, j + 1) - j - 1);
      INSERT INTO params VALUES(@name, @value);
    END IF;

  END WHILE;

  SET @POST = POST;
  PREPARE st FROM @func;
  EXECUTE st;
  DEALLOCATE PREPARE st;

END//

DELIMITER ;