
-- CREATE TABLE ct_homework_grade (
-- 	  user_id		uuid not null						-- 1 to 1 map to user	
-- 	, homework_id		uuid not null						-- assignment
-- 	, tries			int default 0 not null				-- how many times did they try thisa
-- 	, pass			text default 'No' not null			-- Did the test get passed
-- 	, pts			int default 0 not null				-- points awarded
--  	, updated 		timestamp
--  	, created 		timestamp default current_timestamp not null
-- );


CREATE OR REPLACE FUNCTION grade_hw_no( p_user_id uuid, p_homework_id uuid, p_pts int ) RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
	l_rv text;
	l_pass text;
	l_found int;
BEGIN
	l_rv = 'PASS';
	if p_pts > 0 then
		l_pass = 'yes';
	else 
		l_pass = 'no';
	end if;

	select 1 
		into l_found
		from ct_homework_grade
		where homework_id = p_homework_id 
		  and user_id = p_user_id
		;

	if not found then
		insert into ct_homework_grade ( user_id, homework_id, tries, pass, pts )
			values ( p_user_id, p_homework_id, 1, l_pass, p_pts );
	else
		update ct_homework_grade
			set tries = tries + 1
				, pass = l_pass
				, pts = greatest ( pts, p_pts )
			where homework_id = p_homework_id 
			  and user_id = p_user_id
			;
	end if;

	RETURN l_rv;
END;
$$;

