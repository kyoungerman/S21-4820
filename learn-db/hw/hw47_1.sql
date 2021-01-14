CREATE TABLE test_collection (
	id serial primary key not null,
	data JSONB
);

CREATE INDEX test_collection_gin_1 ON test_collection USING gin (data);

insert into test_collection ( data ) values	
	( '{"name":"bob"}' )
;
