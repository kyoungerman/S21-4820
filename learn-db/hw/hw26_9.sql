
DROP TABLE IF EXISTS ct_tag ;

CREATE TABLE ct_tag ( 
	tag_id uuid DEFAULT uuid_generate_v4() not null primary key,
	tag_word text not null
);

CREATE INDEX ct_tag_p1 on ct_tag ( tag_word );

