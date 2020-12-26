
-- CREATE TABLE "t_qr_to" (
-- 	  "id"				m4_uuid_type() DEFAULT uuid_generate_v4() not null primary key
-- 	, "id50"			text not null
-- 	, "id10"			bigint
-- 	, "data"			text
-- 	, "n_redir"			bigint default 0 not null
-- 	, "url_to"			text
-- 	, "owner_id"		char varying (40) 
-- 	, "group_tag"		text
-- 	, "updated" 		timestamp
-- 	, "created" 		timestamp default current_timestamp not null
-- );

delete from "t_qr_to" where "id60" = 'unAun';
insert into "t_qr_to" ( "id60", "id10", "url_to" ) values ( 'unAun', '651876120', 'http://yes-I-still-love-you.com?test=77' );

