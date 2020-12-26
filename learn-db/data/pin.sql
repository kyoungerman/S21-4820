

-- Did not login Error: select c_validate_2fa_pin ( $1, $2, $3 ) username = [pschlump@gmail.com] user_id [] pin2fa [768659] raw [{"status":"error","msg":"Unable to find user.","code":"3843","status_code":401}] error %!s(<nil>) at:File: /Users/pschlump/go/src/gitlab.com/pschlump/PureImaginationServer/auth_check/auth_handlers.go LineNo:421
select c_validate_2fa_pin ( 'app.example.com:pschlump@gmail.com', '', '768659' );

select output from t_output;

