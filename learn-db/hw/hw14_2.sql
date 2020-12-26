
CREATE OR REPLACE function name_list_upd()
RETURNS trigger AS 
$$
BEGIN
  NEW.updated := current_timestamp;
  RETURN NEW;
END
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER name_list_trig
BEFORE update ON name_list
FOR EACH ROW
EXECUTE PROCEDURE name_list_upd();

