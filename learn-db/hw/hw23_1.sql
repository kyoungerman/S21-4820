WITH
	mystery_employess as ( select sum(pay) total_pay  from name_list where state = 'WY' ),
	normal_employees as ( select sum(pay) total_pay from name_list where state in ( 'NJ', 'NY' ) )
SELECT round( ( tWY.total_pay / ( tWY.total_pay + tEast.total_pay ) ) * 100.0, 2)  as relative_pay
FROM 
	mystery_employess  as tWY
	, normal_employees  as tEast
;
