#!/usr/bin/make -f
# -*- makefile -*-

PREFIX=/usr/local

install:
	install -d $(DESTDIR)$(PREFIX)/share/textadept/modules/yang
	install -d $(DESTDIR)$(PREFIX)/share/textadept/lexers
	install modules/yang/*.lua $(DESTDIR)$(PREFIX)/share/textadept/modules/yang
	install lexers/*.lua $(DESTDIR)$(PREFIX)/share/textadept/lexers
