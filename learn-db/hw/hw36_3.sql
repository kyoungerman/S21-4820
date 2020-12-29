CREATE or REPLACE FUNCTION function_name ( parameter_list varchar )
RETURNS varchar 
AS $$
DECLARE
	data text;
BEGIN

	SELECT 'PASS'
		INTO data
		FROM ct_config 
		WHERE config_id = 1;
	IF not found THEN
		data = 'FAIL';
	END IF;

	RETURN data;
END;
$$ LANGUAGE plpgsql;
