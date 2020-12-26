#!/bin/bash

mkdir -p ./out
wget -o ./out/ct_video.1 -O ./out/ct_video.2 'http://localhost:7001/api/v1/ct_video'

wget -o ./out/ct_per_user.1 -O ./out/ct_per_user.2 'http://localhost:7001/api/v1/ct_video_per_user'
			
#URIPath:   "/api/v1/ct_video_per_user",

wget -o ./out/ct_per_questions.1 -O ./out/ct_per_questions.2 'http://localhost:7001/api/v1/ct_video_questions'
