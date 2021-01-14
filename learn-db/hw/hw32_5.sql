CREATE OR REPLACE FUNCTION ct_config_row_prevent_delete() 
RETURNS trigger AS $$
BEGIN            
	IF OLD.config_id = 1 THEN
		RAISE EXCEPTION 'cannot delete configuration row';
	END IF;
END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER ct_config_row_prevent_delete 
	BEFORE DELETE ON ct_config_row
	FOR EACH ROW EXECUTE PROCEDURE ct_config_row_prevent_delete();
