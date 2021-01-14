
-- fmt.Printf("insert into ct_val_homework ( val_id, lesson_name, val_type, val_data  ) values ( '%s', %d, '%s', '%s' );\n", t1, nno, u[0], u[1])
DROP TABLE ct_val_homework ;
CREATE TABLE ct_val_homework (
	val_id uuid not null primary key,
	lesson_name int not null,
	val_type text not null,
	val_data text not null
);

-- fmt.Printf("insert into ct_file_list ( file_list_uuid, lesson_name, file_name ) values ( '%s', %d, '%s' );\n", t1, nno, u[0])
DROP TABLE ct_file_list ;
CREATE TABLE ct_file_list (
	file_list_id uuid not null primary key,
	lesson_name int not null,
	file_name text not null
);

