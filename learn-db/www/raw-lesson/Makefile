
FN=l01
DIR=../..
PP=`pwd`

PY= l01.a.sql l01.b.sql

all: ${FN}.md 

xall: ${FN}.html 

${FN}.md: ${FN}.raw.md $(PY)
	m4 -P ${FN}.raw.md >${FN}.md

${FN}.html: ${FN}.md
	blackfriday-tool ./${FN}.md ${FN}.html
	echo cat ./${DIR}/md.css ${FN}.html >/tmp/${FN}.html
	cat ./${DIR}/css/pre ./${DIR}/css/markdown.css ./${DIR}/css/post ./${DIR}/md.css ./${DIR}/css/hpre ${FN}.html ./${DIR}/css/hpost >/tmp/${FN}.html
	mv /tmp/${FN}.html ./${FN}.html
	echo "file://${PP}/${FN}.html" >open.1

aa:
	echo "file://${PP}/${FN}.html" >open.1
