SELECT adsrc  
	FROM pg_attrdef  
	WHERE adrelid = (
		SELECT oid 
		FROM pg_class 
		WHERE relname = 'department'
	)
;
