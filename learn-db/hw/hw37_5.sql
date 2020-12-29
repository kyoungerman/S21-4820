CREATE or REPLACE FUNCTION login_correct ( un varchar, pw varchar )
RETURNS varchar 
AS $$
DECLARE
	data text;
BEGIN

	BEGIN
		SELECT 'VALID-USER'
			INTO data
			FROM example_users as t1
			WHERE t1.email = un
			  AND t1.password = crypt(pw, t1.password)
			;
		IF not found THEN
			data = 'Incorrect username or password.';
		END IF;
	EXCEPTION	
		WHEN no_data_found THEN
			data = 'Incorrect username or password.';
		WHEN too_many_rows THEN
			data = 'Incorrect username or password.';
		WHEN others THEN
			data = 'Incorrect username or password.';
	END;

	RETURN data;
END;
$$ LANGUAGE plpgsql;

select login_correct ( 'pschlump@uwyo.edu', 'my-very-bad-password' );

select login_correct ( 'pschlump@uwyo.edu', 'my-VERY-bad-password' );

