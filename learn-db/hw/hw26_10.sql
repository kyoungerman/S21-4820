
DROP TABLE IF EXISTS ct_tag_homework ;

CREATE TABLE ct_tag_homework ( 
	tag_id 		uuid not null,
	homework_id uuid not null,
	primary key ( homework_id, tag_id )
);

CREATE UNIQUE INDEX ct_tag_homework_u1 on ct_tag_homework ( tag_id, homework_id );

