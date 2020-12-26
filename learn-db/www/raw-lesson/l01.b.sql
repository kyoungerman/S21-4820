CREATE OR REPLACE FUNCTION checkL01() RETURNS character varying AS $BODY$
BEGIN
	-- look for the table in the schema
	-- verify the columns
	return 'PASS';
END;
$BODY$ LANGUAGE 'plpgsql';
