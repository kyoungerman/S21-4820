#!/bin/bash

go build
mkdir -p ./out ./log
./validate_script "t_reg_pin" "t_reg_info" "t_phone_no" "t_physical_loc" "t_address_type" 
goimports -w out/x.go

