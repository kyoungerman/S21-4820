DROP TABLE if exists ct_config ;

CREATE TABLE ct_config (
	config_id serial primary key check ( config_id = 1 ),
	application_name text
);
