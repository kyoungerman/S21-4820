
drop table city_data ;

-- "city","city_ascii","state_id","state_name","county_fips","county_name","lat","lng","population","density","source","military","incorporated","timezone","ranking","zips","id"
create table city_data (
	"city" text,
	"city_ascii" text,
	"state_id" varchar(2),
	"state_name" text,
	"county_fips" text,
	"county_name" text,
	"lat" float,
	"lng" float,
	"population" int8,
	"density" text,
	"source" text,
	"military" text,
	"incorporated" text,
	"timezone" text,
	"ranking" text,
	"zips" text,
	"id" text not null primary key
);
