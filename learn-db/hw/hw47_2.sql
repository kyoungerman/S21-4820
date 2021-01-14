SELECT * 
	FROM test_collection 
	WHERE data->>'name' = 'bob'
;
