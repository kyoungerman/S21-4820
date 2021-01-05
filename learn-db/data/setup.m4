
m4_changequote(`[[[', `]]]')

m4_define([[[m4_uuid_type]]],[[[uuid]]])

m4_define([[[m4_updTrig]]],[[[

CREATE OR REPLACE function $1_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER $1_trig
BEFORE update ON "$1"
FOR EACH ROW
EXECUTE PROCEDURE $1_upd();

]]])

m4_define([[[m4_updTrigChkUpdateOk]]],[[[

CREATE OR REPLACE function $1_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	IF EXISTS (SELECT "id" FROM "$1" WHERE id = NEW.id and "update_ok" = 'no') THEN
		RAISE EXCEPTION 'signed data locked - no update';
	END IF;
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER $1_trig
BEFORE update ON "$1"
FOR EACH ROW
EXECUTE PROCEDURE $1_upd();

]]])

