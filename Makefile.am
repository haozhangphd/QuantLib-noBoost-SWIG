SUBDIRS = Python

EXTRA_DIST = \
	ChangeLog.txt \
	LICENSE.TXT \
	News.txt \
	Readme.txt \
	autogen.sh


dist-hook:
	mkdir -p $(distdir)/SWIG
	cp -p ./SWIG/*.i $(distdir)/SWIG

