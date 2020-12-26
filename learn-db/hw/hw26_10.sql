
DROP TABLE IF EXISTS ct_tag ;

CREATE TABLE ct_tag_homework ( 
	tag_id 		uuid not null,
	homework_id uuid not null
);

CREATE UNIQUE INDEX ct_tag_homework_p1 on ct_tag_homework ( hoemwork_id, tag_id );
CREATE UNIQUE INDEX ct_tag_homework_p2 on ct_tag_homework ( tag_id, homework_id );

