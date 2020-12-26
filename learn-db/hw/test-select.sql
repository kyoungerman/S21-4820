
-- from: https://stackoverflow.com/questions/11948131/postgresql-writing-dynamic-sql-in-stored-procedure-that-returns-a-result-set

CREATE OR REPLACE FUNCTION test_select ( stmt varchar )
RETURNS SETOF text AS $$
DECLARE
   -- sql text := 'SELECT real_name FROM name_list';
	l_dummy text;
BEGIN
   -- RETURN QUERY EXECUTE sql ;
   RETURN QUERY EXECUTE stmt ;
END
$$ LANGUAGE plpgsql;
