DROP TABLE if exists ct_homework_ans ;
CREATE TABLE ct_homework_ans (
	  homework__ans_id			uuid DEFAULT uuid_generate_v4() not null primary key
	, homework_id				uuid not null
	, user_id					uuid not null
	, points					int not null default 0
	, completd					char(1) default 'n' not null
	, updated		 			timestamp
	, created 					timestamp default current_timestamp not null
);


create unique index ct_homework_ans_u1 on ct_homework_ans ( homework_id, user_id );
create unique index ct_homework_ans_u2 on ct_homework_ans ( user_id, homework_id );


-- homework_id is fk to ct_homework
ALTER TABLE ct_homework_ans
	ADD CONSTRAINT homework_id_fk
	FOREIGN KEY (homework_id)
	REFERENCES ct_homework (homework_id)
;

-- user_id is fk to ct_login
ALTER TABLE ct_homework_ans
	ADD CONSTRAINT user_id_fk
	FOREIGN KEY (user_id)
	REFERENCES ct_login (user_id)
;


CREATE OR REPLACE function ct_homework_ans_upd()
RETURNS trigger AS $$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER ct_homework_ans_trig
BEFORE update ON ct_homework_ans
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_ans_upd();

