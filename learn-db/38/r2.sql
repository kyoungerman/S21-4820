DROP TABLE if exists temp_a;
CREATE TEMP TABLE temp_a (
    "QUERY_PLAN" text
);


DO
$$
DECLARE
	rec record;
BEGIN

	FOR rec IN EXECUTE 'EXPLAIN VERBOSE select version()' 
	LOOP
		--  RAISE NOTICE 'rec=%', row_to_json(rec);
		insert into temp_a ( "QUERY_PLAN" )
			select rec."QUERY PLAN";
	END LOOP;

END
$$ LANGUAGE plpgsql;

select *
from temp_a;
