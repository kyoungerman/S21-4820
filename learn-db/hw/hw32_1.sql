DROP  TABLE if exists ct_config_row ;

CREATE TABLE ct_config_row (
	  id				serial not null primary key
	, name 				text not null check ( name in (
							'security_method',
							'encryption'
						) )
	, ty 				text not null default 'str'
	, value 			text 
	, i_value 			bigint
	, b_value 			boolean
);

CREATE UNIQUE INDEX ct_config_row_p1 on ct_config_row ( name );
