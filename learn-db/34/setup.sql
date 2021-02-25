DROP TABLE if exists temp_a;
CREATE TABLE temp_a (
	seq					serial not null primary key,
	id 					uuid not null,
	created 			timestamp default current_timestamp not null,
    query_plan 			text
);
create index temp_a_p1 on temp_a ( id , seq );

CREATE OR REPLACE FUNCTION f_explain( p_id text, p_stmt text )
	RETURNS void AS $$
DECLARE
	rec record;
BEGIN

	DELETE FROM temp_a where created < now() - interval '1 hour' or id = p_id::uuid;

	FOR rec IN EXECUTE p_stmt
	LOOP
		--  RAISE NOTICE 'rec=%', row_to_json(rec);
		insert into temp_a ( id, query_plan )
			select p_id::uuid, rec."QUERY PLAN";
	END LOOP;

END
$$ LANGUAGE plpgsql;


-- DELETE FROM temp_a where created < now() - interval '1 hour' or id = '527b00e6-dd14-4096-5c57-d2d9563182d1';

SELECT f_explain ( '527b00e6-dd14-4096-5c57-d2d9563182d1', 'explain verbose select 12 from name_list' ); 

SELECT *
	FROM temp_a
	WHERE id = '527b00e6-dd14-4096-5c57-d2d9563182d1'
	ORDER BY seq
;

