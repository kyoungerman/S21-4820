CREATE OR REPLACE function ct_homework_ins()
RETURNS trigger AS $$
BEGIN
	insert into ct_homework_ans (
		user_id,
		homework_id
	) select 
		t1.user_id,
		NEW.homework_id
	from ct_login as t1
	where not exists (
			select 1 as "found"
			from ct_homework_ans t2
			where t2.user_id = t1.user_id			
			  and t2.homework_id = NEW.homework_id
		)
	;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


DROP TRIGGER if exists ct_homework_trig_ins_upd on ct_homework;

CREATE TRIGGER ct_homework_trig_ins_upd
after insert or update ON ct_homework
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_ins();






CREATE OR REPLACE function ct_homework_del()
RETURNS trigger AS $$
BEGIN
	update ct_homework_ans t3
		set completed = 'x'
		where t3.homework_id = NEW.homework_id
		  and t3.completed = 'n'
	;
	RETURN OLD;
END
$$ LANGUAGE 'plpgsql';


DROP TRIGGER if exists ct_homework_trig_del on ct_homework;

CREATE TRIGGER ct_homework_trig_del
BEFORE delete ON ct_homework
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_del();








CREATE OR REPLACE function ct_login_ins()
RETURNS trigger AS $$
BEGIN
	insert into ct_homework_ans (
		user_id,
		homework_id
	) select 
		NEW.user_id,
		t1.homework_id
	from ct_homework as t1
	where not exists (
			select 1 as "found"
			from ct_homework_ans t2
			where t2.user_id = NEW.user_id			
			  and t2.homework_id = t1.homework_id
		)
	;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


drop TRIGGER if exists ct_login_trig on ct_login;

CREATE TRIGGER ct_login_trig
after insert ON ct_login
FOR EACH ROW
EXECUTE PROCEDURE ct_login_ins();
