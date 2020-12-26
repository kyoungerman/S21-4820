CREATE TABLE us_state (
	state_id UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
	state_name text NOT NULL,
	state char varying (2) NOT NULL,
	FIPS_code char varying (2) NOT NULL
);
