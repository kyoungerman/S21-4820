create table ct_config (
	config_id serial primary key check ( config_id = 1 ),
	application_name text
);
