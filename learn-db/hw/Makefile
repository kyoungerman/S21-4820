
DIR=../../../F20-1015
PP=`pwd`

PY= \
	all.sql \
	ans-hw29.sql \
	city_copy.sql \
	city.sql \
	hw01_0.setup.sql \
	hw01_1.sql \
	hw02_1.sql \
	hw02_2.sql \
	hw02_2.test01.sql \
	hw03_1.sql \
	hw03_1.test01.sql \
	hw03_2.sql \
	hw03_3.sql \
	hw03_4.sql \
	hw03_5.sql \
	hw04_1.sql \
	hw04_2.sql \
	hw04_2.test01.sql \
	hw04_3.sql \
	hw05_0.sql \
	hw05_0.test01.sql \
	hw05_1.sql \
	hw05_2.sql \
	hw06_1.sql \
	hw06_1.test01.sql \
	hw06_2.sql \
	hw06_3.sql \
	hw06_4.sql \
	hw08_1.sql \
	hw09_1.sql \
	hw09_2.sql \
	hw09_3.sql \
	hw09_4.sql \
	hw10_1.sql \
	hw11_1.sql \
	hw11_2.sql \
	hw11_3.sql \
	hw12_1.sql \
	hw12_2.sql \
	hw12_3.sql \
	hw12_4.sql \
	hw13_1.sql \
	hw13_2.sql \
	hw13_3.sql \
	hw13_4.sql \
	hw14_1.sql \
	hw14_2.sql \
	hw15_1.sql \
	hw15_2.sql \
	hw16_1.sql \
	hw17_1.sql \
	hw17_2.sql \
	hw17_3.sql \
	hw17_4.sql \
	hw17_5.sql \
	hw17_6.sql \
	hw18_1.sql \
	hw18_2.sql \
	hw19_1.sql \
	hw20_1.sql \
	hw20_2.sql \
	hw21_1.sql \
	hw22_1.sql \
	hw22_2.sql \
	hw23_1.sql \
	hw24_1.sql \
	hw25_1.sql \
	hw25_2.sql \
	hw26_10.sql \
	hw26_11.sql \
	hw26_1.sql \
	hw26_2.sql \
	hw26_3.sql \
	hw26_4.sql \
	hw26_5.sql \
	hw26_6.sql \
	hw26_7.sql \
	hw26_8.sql \
	hw26_9.sql \
	hw28_1.sql \
	hw29_1.sql \
	hw29_2.sql \
	hw31_1.sql \
	hw31_2.sql \
	hw31_4.sql \
	hw32_1.sql \
	hw32_2.sql \
	hw32_3.sql \
	hw32_5.sql \
	hw33_1.sql \
	hw33_2.sql \
	hw35_1.sql \
	hw35_2.sql \
	hw36_3.sql \
	hw36_4.sql \
	hw37_1.sql \
	hw37_2.sql \
	hw37_3.sql \
	hw37_4.sql \
	hw37_5.sql \
	old1.sql \
	s1.sql \
	s2.sql \
	s3.sql \
	test-select.sql
#endPY

IMG= \
	PostgreSQL-Full-Outer-Join.png \
	PostgreSQL-Full-Outer-Unique-Join.png \
	PostgreSQL-Inner-Join.png \
	PostgreSQL-Left-Outer-Join.png
#endIMG

HTML= \
	hw01.html \
	hw02.html \
	hw03.html \
	hw04.html \
	hw05.html \
	hw06.html \
	hw07.html \
	hw08.html \
	hw09.html \
	hw10.html \
	hw11.html \
	hw12.html \
	hw13.html \
	hw14.html \
	hw15.html \
	hw16.html \
	hw17.html \
	hw18.html \
	hw19.html \
	hw20.html \
	hw21.html \
	hw22.html \
	hw23.html \
	hw24.html \
	hw25.html \
	hw26.html \
	hw27.html \
	hw28.html \
	hw29.html \
	hw30.html \
	hw31.html \
	hw32.html \
	hw34.html
#endHTML

MD= \
	hw01.md \
	hw02.md \
	hw03.md \
	hw04.md \
	hw05.md \
	hw06.md \
	hw07.md \
	hw08.md \
	hw09.md \
	hw10.md \
	hw11.md \
	hw12.md \
	hw13.md \
	hw14.md \
	hw15.md \
	hw16.md \
	hw17.md \
	hw18.md \
	hw19.md \
	hw20.md \
	hw21.md \
	hw22.md \
	hw23.md \
	hw24.md \
	hw25.md \
	hw26.md \
	hw27.md \
	hw28.md \
	hw29.md \
	hw30.md \
	hw31.md \
	hw32.md \
	hw34.md
#endMD

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

run_all:
	psql -a <all.sql >all.out

make: m1 m2 m3
.PHONEY: make m1 m2 m3

m1:
	rm -f ,*.sql
	ls *.sql >,a
	ed ,a <ed.make1.ed
	ed Makefile <ed.make2.ed

m2:
	ls hw*.md | grep -v raw >,a
	ed ,a <ed.make1.ed
	ed Makefile <ed.make3.ed

m3:
	ls hw*.md | grep -v raw >,a
	ed ,a <ed.make5.ed
	ed Makefile <ed.make4.ed


gitupdate:
	git add -A .
	git commit -m "New Lessons"
	git push

