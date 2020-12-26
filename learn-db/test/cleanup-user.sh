#!/bin/bash

d200 <<XZX
\\c q8s
delete from "t_q8s_user" where "username" = 'q8s.co:$1';
\\q
XZX
