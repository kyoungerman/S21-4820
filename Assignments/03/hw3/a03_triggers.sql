CREATE OR REPLACE function a03_title_index_ins_upd()
RETURNS trigger as $$
DECLARE 
    lang text;
BEGIN
    lang = 'english';
    NEW.words = 
        setweight (to_tsvector (lang::regconfig, coalesce(NEW.title, '')), 'A') ||
        setweight (to_tsvector (lang::regconfig, coalesce(NEW.body, '')), 'B')  
        ;
        RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

DROP TRIGGER if exists a03_title_index on a03_title;

CREATE TRIGGER a03_title_index
    BEFORE INSERT OR UPDATE ON a03_title
    FOR EACH ROW
    EXECUTE PROCEDURE a03_title_index_ins_upd()
;


CREATE OR REPLACE function a03_timestamp_upd()
RETURNS trigger as $$
DECLARE
    new_time timestamp;
BEGIN
    new_time = current_timestamp;
    NEW.updated = new_time;
    RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

DROP TRIGGER if exists a03_update_time on a03_title;

CREATE TRIGGER a03_update_time
    BEFORE UPDATE ON a03_title
    FOR EACH ROW
    EXECUTE PROCEDURE a03_timestamp_upd()
;