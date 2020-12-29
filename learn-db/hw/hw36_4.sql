-- using table from hw13_4.sql us_state

CREATE OR REPLACE FUNCTION getStateFipsCode() 
RETURNS SETOF us_state 
AS $$
DECLARE
    r us_state%rowtype;
BEGIN
    FOR r IN 	
		SELECT * FROM us_state
		WHERE gdp_growth > 1.0
    LOOP

        -- can do some processing here

        RETURN NEXT r; -- return current row of SELECT
    END LOOP;
    RETURN;
END
$$
LANGUAGE 'plpgsql' ;

SELECT * 
	FROM getStateFipsCode()
;
