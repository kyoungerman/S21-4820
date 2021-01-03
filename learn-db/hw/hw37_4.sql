SELECT id 
FROM example_users as t1
WHERE t1.email = 'pschlump@uwyo.edu'
  AND t1.password = crypt('my-very-bad-password', t1.password)
;
