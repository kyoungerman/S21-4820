
DROP TABLE if exists name_list cascade ;
DROP TABLE if exists us_state cascade ;

CREATE TABLE us_state (
	state_id       UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
	state_name     text NOT NULL,
	state          char varying (2) NOT NULL,
	FIPS_code      char varying (2) NOT NULL,
	area_rank      int not null default 9999,
	area_sq_mi     numeric not null default 0,
	population     int not null default 0,
	fed_area       int   not null default 0,
	gdp_growth     float null default 0.0,
	gdp            float null default 0.0
);

CREATE UNIQUE INDEX us_state_uidx1 on us_state ( state );

