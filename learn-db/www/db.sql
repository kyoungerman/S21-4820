create table tmp1 (
	un text,
	db text
);

insert into tmp1 values 
  ( 'app.example.com:ubalogun@uwyo.edu', 'sa01' )
, ( 'app.example.com:tbourque@uwyo.edu', 'sa02' )
, ( 'app.example.com:wbrant@uwyo.edu', 'sa03' )
, ( 'app.example.com:tbrown64@uwyo.edu', 'sa04' )
, ( 'app.example.com:dcaruthe@uwyo.edu', 'sa05' )
, ( 'app.example.com:cchave12@uwyo.edu', 'sa06' )
, ( 'app.example.com:pday2@uwyo.edu', 'sa07' )
, ( 'app.example.com:adelaura@uwyo.edu', 'sa08' )
, ( 'app.example.com:rdurnan@uwyo.edu', 'sa09' )
, ( 'app.example.com:afinch2@uwyo.edu', 'sa10' )
, ( 'app.example.com:wfrost2@uwyo.edu', 'sa11' )
, ( 'app.example.com:afulle12@uwyo.edu', 'sa12' )
, ( 'app.example.com:jgegax@uwyo.edu', 'sa13' )
, ( 'app.example.com:egorman2@uwyo.edu', 'sa14' )
, ( 'app.example.com:jhanse25@uwyo.edu', 'sa15' )
, ( 'app.example.com:chutson1@uwyo.edu', 'sa16' )
, ( 'app.example.com:sjimerso@uwyo.edu', 'sa17' )
, ( 'app.example.com:ikelly@uwyo.edu', 'sa18' )
, ( 'app.example.com:ikiefer1@uwyo.edu', 'sa19' )
, ( 'app.example.com:jkilpat1@uwyo.edu', 'sa20' )
, ( 'app.example.com:yleong@uwyo.edu', 'sa21' )
, ( 'app.example.com:tlinse@uwyo.edu', 'sa22' )
, ( 'app.example.com:jlucid@uwyo.edu', 'sa23' )
, ( 'app.example.com:amaljani@uwyo.edu', 'sa24' )
, ( 'app.example.com:jmalone9@uwyo.edu', 'sa25' )
, ( 'app.example.com:wmalone1@uwyo.edu', 'sa26' )
, ( 'app.example.com:smeel@uwyo.edu', 'sa27' )
, ( 'app.example.com:mmoore52@uwyo.edu', 'sa28' )
, ( 'app.example.com:zmoore5@uwyo.edu', 'sa29' )
, ( 'app.example.com:cmyers18@uwyo.edu', 'sa30' )
, ( 'app.example.com:jogirima@uwyo.edu', 'sa31' )
, ( 'app.example.com:bostrem@uwyo.edu', 'sa32' )
, ( 'app.example.com:lpinter@uwyo.edu', 'sa33' )
, ( 'app.example.com:tredding@uwyo.edu', 'sa34' )
, ( 'app.example.com:areiche1@uwyo.edu', 'sa35' )
, ( 'app.example.com:croach1@uwyo.edu', 'sa36' )
, ( 'app.example.com:tselvig@uwyo.edu', 'sa37' )
, ( 'app.example.com:pspires@uwyo.edu', 'sa38' )
, ( 'app.example.com:astepehn@uwyo.edu', 'sa39' )
, ( 'app.example.com:asummer5@uwyo.edu', 'sa40' )
, ( 'app.example.com:zswope1@uwyo.edu', 'sa41' )
, ( 'app.example.com:jtuttle5@uwyo.edu', 'sa42' )
, ( 'app.example.com:gtvedt@uwyo.edu', 'sa43' )
, ( 'app.example.com:evanwig@uwyo.edu', 'sa44' )
, ( 'app.example.com:bwabscha@uwyo.edu', 'sa45' )
, ( 'app.example.com:rwallac7@uwyo.edu', 'sa46' )
, ( 'app.example.com:nwhitham@uwyo.edu', 'sa47' )
, ( 'app.example.com:kyounge1@uwyo.edu', 'sa48' )
, ( 'app.example.com:abando@uwyo.edu', 'sa50' )
, ( 'app.example.com:cdepaol1@uwyo.edu', 'sa51' )
, ( 'app.example.com:myraiken@uwyo.edu', 'sa52' )
, ( 'app.example.com:pschlump1@uwyo.edu', 'sa53' )
, ( 'app.example.com:pschlump2@uwyo.edu', 'sa54' )
, ( 'app.example.com:rolson14@uwyo.edu', 'sa55' )
, ( 'app.example.com:testlogin@gmail.com', 'bobo0001' )
;


--select * from ct_login limit 1;
--               user_id                | pg_acct  | class_no | lang_to_use | misc 
----------------------------------------+----------+----------+-------------+------
-- 7a955820-050a-405c-7e30-310da8152b6d | bobo0001 | 4010-BC  | Go          | {}

insert inot ct_login ( user_id, pg_acct )
	select t1.id, t2.db
	from t_ymux_user as t1
		join tmp1 as t2 on ( t2.un = t1.email )
	where not exists (
		select 1
		from ct_login as t3
		where t3.user_id = t1.user_id
		)
;
