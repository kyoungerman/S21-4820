CREATE FOREIGN TABLE table1_import (
  col1 text,
  col2 text
) SERVER import OPTIONS ( filename '/home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4280/learn-db/hw/hw42_03.csv', format 'csv' );
