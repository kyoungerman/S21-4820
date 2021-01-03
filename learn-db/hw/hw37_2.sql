
DROP TABLE IF EXISTS example_users ;

CREATE TABLE example_users (
	id SERIAL PRIMARY KEY,
	email TEXT NOT NULL UNIQUE,
	password TEXT NOT NULL
);


CREATE OR REPLACE function example_users_insert()
RETURNS trigger AS $$
DECLARE 
	l_salt text;
	l_pw text;
BEGIN
	select gen_salt('bf')
		into l_salt;
	l_pw = NEW.password;
	NEW.password = crypt(l_pw, l_salt);
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER example_users_insert_trig
BEFORE insert or update ON example_users
FOR EACH ROW
EXECUTE PROCEDURE example_users_insert();

