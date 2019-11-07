-- DADO PELO STOR

USE guest;

-- Exercício 1 
-- Código inicial de getMovieCharge e registerMovieStream.

DROP FUNCTION IF EXISTS getChargeValue;
DROP PROCEDURE IF EXISTS registerMovieStream;

DELIMITER $


CREATE FUNCTION 
getChargeValue(stream_time DATETIME, movie_id INT, customer_id INT)
RETURNS DECIMAL(4,2)
BEGIN
  DECLARE c DECIMAL(4,2);
  DECLARE movie_duration INT;
  DECLARE country_name VARCHAR(128);
  DECLARE region_name VARCHAR(128);

  SELECT Duration INTO movie_duration
  FROM MOVIE WHERE MovieId = movie_id;

  SET c = 0.5 + 0.01 * movie_duration;

  IF HOUR(stream_time) >= 21 THEN
    SET c = c + 0.75;
    IF WEEKDAY(stream_time) >= 4 THEN
      SET c = c + 0.75;
    END IF;
  END IF;

  -- A COMPLETAR: valor acrescido em função 
  -- do país ou região do cliente como pedido.


  RETURN c;
END $

CREATE PROCEDURE registerMovieStream
(IN movie_id INT,  IN customer_id INT,  IN time DATETIME,
 OUT charge DECIMAL(4,2), OUT stream_id INT)
BEGIN
  -- Obtém valor a cobrar usando função getChargeValue()
  -- A COMPLETAR: modifique a chamada para incluir customer_id  
  SET charge = getChargeValue(time, movie_id);

  -- Insere registo na tabela STREAM.
  INSERT INTO STREAM(CustomerId, MovieId, StreamDate, Charge)
  VALUES(customer_id, movie_id, time, charge);

  -- Obtém id de registo inserido (função LAST_INSERT_ID)
  SET stream_id = LAST_INSERT_ID();
END $

DELIMITER ;

-- Exercício 2
DROP PROCEDURE IF EXISTS string_split;

DELIMITER $

CREATE PROCEDURE string_split
(IN string TEXT, IN sep CHAR(1), OUT num INT)
BEGIN
  DECLARE pos INT;
  DECLARE aux TEXT;
  DECLARE str text;

  -- Tabela temporária para os resultados 
  CREATE TEMPORARY TABLE IF NOT EXISTS STRING_SPLIT_RESULTS
  (
    Num INT NOT NULL,
    Str TEXT NOT NULL 
  );
  
  -- Limpa resultados anteriores
  DELETE FROM STRING_SPLIT_RESULTS;

  -- Encontra strings delimitadas pelo separador,
  -- e por cada string insere uma entrada em STRING_SPLIT_RESULTS.
  SET aux = string;
  SET num = 0;
  REPEAT
    SET pos = INSTR(aux, BINARY sep);

    IF POS > 0 THEN
      SET str = SUBSTRING(aux, 1, pos - 1);
      SET aux = SUBSTRING(aux, pos + 1, LENGTH(aux) - pos);
    ELSE 
      SET str = aux; 
    END IF;

    SET num = num + 1;

    INSERT INTO STRING_SPLIT_RESULTS(Num, Str)
    VALUES(num, str);
  UNTIL pos = 0
  END REPEAT;
END $

DELIMITER ;

-- Exercício 3
DROP PROCEDURE IF EXISTS registerMovie; 
DELIMITER $

CREATE PROCEDURE 
registerMovie(
  IN title TEXT, 
  IN year INT, 
  IN duration INT, 
  IN actor_name_list TEXT, 
  IN genre_label_list TEXT, 
  OUT movie_id INT)
BEGIN
  DECLARE n INT;
  DECLARE i INT;
  DECLARE actor_id INT; 
  DECLARE genre_id INT; 

  -- Insere entrada em MOVIE.
  INSERT INTO MOVIE(Title, Year, Duration)
  VALUES(title, year, duration);

  SET movie_id = LAST_INSERT_ID();

  CALL string_split(actor_name_list, ',', n);

  SET i = 1; 
  WHILE i <= n DO
    -- A COMPLETAR: 
    -- Processa lista de actores, inserindo entradas em MOVIE_ACTOR.

    SET i = i + 1;
  END WHILE;

  CALL string_split(genre_label_list, ',', n);

  SET i = 1; 
  WHILE i <= n DO
    -- A COMPLETAR: 
    -- Processa lista de géneros, inserindo entradas em MOVIE_GENRE.

    SET i = i + 1;
  END WHILE;
END $ 
DELIMITER ;

-- Exercício 4
DROP PROCEDURE IF EXISTS registerMovie2; 
DELIMITER $

CREATE PROCEDURE 
registerMovie2(
  IN title TEXT, 
  IN year INT, 
  IN duration INT, 
  IN actor_name_list TEXT, 
  IN genre_label_list TEXT, 
  OUT movie_id INT)
BEGIN

  -- A COMPLETAR

END $ 
DELIMITER ;

-- Exercício 5


DROP TRIGGER IF EXISTS beforeMovieInsertion;
DROP TRIGGER IF EXISTS beforeStreamInsertion;
DROP TRIGGER IF EXISTS beforeStreamUpdate;

DELIMITER $

CREATE TRIGGER beforeMovieInsertion
BEFORE INSERT ON MOVIE FOR EACH ROW
BEGIN
  -- 99999 designa um código de erro da aplicação
  DECLARE error CONDITION FOR SQLSTATE '99999';
  -- Valida ano
  IF NEW.Year < 1900 THEN
    SIGNAL error SET MESSAGE_TEXT = 'Invalid year!';
  END IF;
  -- Valida duração
  IF NEW.Duration <= 0 THEN
    SIGNAL error SET MESSAGE_TEXT = 'Invalid duration!';
  END IF;
END $


CREATE TRIGGER beforeStreamInsertion
BEFORE INSERT ON STREAM FOR EACH ROW 
BEGIN
  -- A COMPLETAR

END $

CREATE TRIGGER beforeStreamUpdate
BEFORE UPDATE ON STREAM FOR EACH ROW 
BEGIN
  -- A COMPLETAR

END $

DELIMITER ;

-- Exercício 6
DROP TRIGGER IF EXISTS beforeDepartmentInsert;
DROP TRIGGER IF EXISTS beforeDepartmentUpdate;
DROP TRIGGER IF EXISTS afterDepartmentInsert;
DROP TRIGGER IF EXISTS afterDepartmentUpdate;
DROP PROCEDURE IF EXISTS ensureNotDepartmentManager;
DROP PROCEDURE IF EXISTS defineCEOAsSupervisor;
DELIMITER $

CREATE TRIGGER beforeDepartmentInsert
BEFORE INSERT ON DEPARTMENT FOR EACH ROW
BEGIN
  CALL ensureNotDepartmentManager(NEW.Manager);
END $

CREATE TRIGGER beforeDepartmentUpdate
BEFORE UPDATE ON DEPARTMENT FOR EACH ROW
BEGIN
  DECLARE ceo_id INT;
  IF NEW.Manager <> OLD.Manager THEN
    CALL ensureNotDepartmentManager(NEW.Manager);
  END IF;
END $

CREATE PROCEDURE
ensureNotDepartmentManager(IN staff_id INT)
BEGIN
  DECLARE is_manager BOOL;
  DECLARE error CONDITION FOR SQLSTATE '99999';
  SET is_manager = FALSE;
  SELECT TRUE INTO is_manager
  FROM DEPARTMENT WHERE Manager = staff_id;
  IF is_manager THEN
    SIGNAL error
    SET MESSAGE_TEXT = 'No staff member can supervise more than one department!';
  END IF;
END $

CREATE TRIGGER afterDepartmentInsert
AFTER INSERT ON DEPARTMENT FOR EACH ROW
BEGIN
   -- A COMPLETAR
END $

CREATE TRIGGER afterDepartmentUpdate
AFTER UPDATE ON DEPARTMENT FOR EACH ROW
BEGIN
   -- A COMPLETAR
END $

DELIMITER ;

