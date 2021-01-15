
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
	l_h_no text;
BEGIN
	l_rv = 'PASS';
	if p_pts > 0 then
		l_pass = 'yes';
	else 
		l_pass = 'no';
	end if;

	select homework_no
		into l_h_no
		from ct_homework	
		where homework_id = p_homework_id
		;

	if not found then
		l_rv = 'FAIL';
	end if;

	if l_rv = 'PASS' then

		select 1 
			into l_found
			from ct_homework_grade
			where homework_id = p_homework_id 
			  and user_id = p_user_id
			;

		if not found then
			insert into ct_homework_grade ( user_id, homework_id, tries, pass, pts, homework_no )
				values ( p_user_id, p_homework_id, 1, l_pass, p_pts, l_h_no );
		else
			update ct_homework_grade
				set tries = tries + 1
					, pass = l_pass
					, pts = greatest ( pts, p_pts )
					, homework_no = l_h_no
				where homework_id = p_homework_id 
				  and user_id = p_user_id
				;
		end if;

	end if;


	RETURN l_rv;
END;
$$;

CREATE UNIQUE index ct_homework_grade_u1 on ct_homework_grade ( homework_id, user_id );
CREATE UNIQUE index ct_homework_grade_u2 on ct_homework_grade ( homework_no, user_id );
CREATE UNIQUE index ct_homework_u4 on ct_homework ( homework_no );

CREATE OR REPLACE FUNCTION grade_hw_migrate( ) RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
	l_rv text;
	l_id uuid;
	f record;
BEGIN
	l_rv = 'PASS';

	for f in select * from ct_homework_grade loop
		select homework_id
			into l_id			
			from ct_homework
			where homework_no = f.homework_no		
		;
		if not found then
	
		else
			update ct_homework_grade
				set homework_id = l_id
				where homework_id = f.homework_id		
				  and user_id = f.user_id
			;
		end if;	
	end loop;

	RETURN l_rv;
END;
$$;

select grade_hw_migrate( ) ;

select grade_hw_no ( '7a955820-050a-405c-7e30-310da8152b6d',  'd66aae56-b399-42ef-5486-519e19c80d05', 10 );

	
