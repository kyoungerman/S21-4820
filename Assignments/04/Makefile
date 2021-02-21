
DIR=../../../F20-1015
PP=`pwd`
PY= \
	a04-server.py \
	config.py \
	delete-issue-note.sql \
	sample-issues.sql \
	app_config.ini \
	database.ini
IMG=

MD= Assignment-04.md
HTML= Assignment-04.html

all: pre $(MD) $(HTML) 

pre:
	cp /dev/null open.1
.PHONEY: pre

%.md: %.raw.md $(PY) $(IMG)
	m4 -P $< >$@

%.html: %.md
	blackfriday-tool ./$< $@
	echo cat ./${DIR}/md.css $@ >/tmp/$@
	cat ./${DIR}/css/pre ./${DIR}/css/markdown.css ./${DIR}/css/post ./${DIR}/md.css ./${DIR}/css/hpre $@ ./${DIR}/css/hpost >/tmp/$@
	mv /tmp/$@ ./$@
	echo "file://${PP}/$@" >>open.1

