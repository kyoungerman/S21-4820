----------------------------------------------------------------------------------
--This file creates foreign key relationships and triggers for all of the tables--
----------------------------------------------------------------------------------

------Add Foreign Key relationships------

ALTER TABLE i_issue
    ADD CONSTRAINT issue_state_id_fk1
    FOREIGN KEY (state_id)
    REFERENCES i_state (id)
;

ALTER TABLE i_issue
    ADD CONSTRAINT issue_severity_id_fk1
    FOREIGN KEY (severity_id)
    REFERENCES i_severity (id)
;

ALTER TABLE i_note
    ADD CONSTRAINT note_issue_id_fk1
    FOREIGN KEY (issue_id)
    REFERENCES i_issue (id)
;

------Create timestamp on insert row-----

CREATE OR REPLACE function i_timestamp_ins()
RETURNS trigger as $$
DECLARE 
    new_time timestamp;
BEGIN
    new_time = current_timestamp;
    NEW.created = new_time;
    RETURN NEW;
END
    $$ LANGUAGE 'plpgsql'
;

DROP TRIGGER IF EXISTS issue_create_time on i_issue;

CREATE TRIGGER issue_create_time
    BEFORE INSERT ON i_issue
    FOR EACH ROW
    EXECUTE PROCEDURE i_timestamp_ins()
;

DROP TRIGGER IF EXISTS note_create_time on i_note;

CREATE TRIGGER note_create_time
    BEFORE INSERT ON i_note
    FOR EACH ROW
    EXECUTE PROCEDURE i_timestamp_ins()
;

------Create timestamp on update row-----
CREATE OR REPLACE function i_timestamp_upd()
RETURNS trigger as $$
DECLARE 
    new_time timestamp;
BEGIN
    new_time = current_timestamp;
    NEW.updated = new_time;
    RETURN NEW;
END
    $$ LANGUAGE 'plpgsql'
;

DROP TRIGGER IF EXISTS issue_update_time on i_issue;

CREATE TRIGGER issue_update_time
    BEFORE UPDATE ON i_issue
    FOR EACH ROW
    EXECUTE PROCEDURE i_timestamp_upd()
;

DROP TRIGGER IF EXISTS note_update_time on i_note;

CREATE TRIGGER note_update_time
    BEFORE UPDATE ON i_note
    FOR EACH ROW
    EXECUTE PROCEDURE i_timestamp_upd()
;


------Update tsvector------
CREATE OR REPLACE function index_ins_upd()
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

DROP TRIGGER IF EXISTS issue_words on i_issue;

CREATE TRIGGER issue_words
    BEFORE UPDATE OR INSERT on i_issue
    FOR EACH ROW
    EXECUTE PROCEDURE index_ins_upd()
;

DROP TRIGGER IF EXISTS note_words on i_note;

CREATE TRIGGER note_words
    BEFORE UPDATE OR INSERT on i_note
    FOR EACH ROW
    EXECUTE PROCEDURE index_ins_upd()
;

------Alter Sequence------
ALTER SEQUENCE i_state_id_seq RESTART WITH 12;

ALTER SEQUENCE i_severity_id_seq RESTART WITH 9;