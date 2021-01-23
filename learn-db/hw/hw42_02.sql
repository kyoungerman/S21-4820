DROP FOREIGN TABLE if exits table1_import ;

CREATE FOREIGN TABLE table1_import (
	col1 text,
	col2 text
) SERVER import OPTIONS ( filename '/home/uw4820/hw42_03.csv', format 'csv' );
