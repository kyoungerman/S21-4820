-- "city","city_ascii","state_id","state_name","county_fips","county_name","lat","lng","population","density","source","military","incorporated","timezone","ranking","zips","id"
COPY city_data( "city","city_ascii","state_id","state_name","county_fips","county_name","lat","lng","population","density","source","military","incorporated","timezone","ranking","zips","id" )
	FROM '/home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4820/learn-db/hw/uscities.csv'
	DELIMITER ','
	CSV HEADER;
