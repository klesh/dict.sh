# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

VERSION = 1.0
PREFIX = /usr/local

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f d d_youdao plainsel $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/d
	chmod 755 $(DESTDIR)$(PREFIX)/bin/d_youdao
	chmod 755 $(DESTDIR)$(PREFIX)/bin/plainsel

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/d
	rm -f $(DESTDIR)$(PREFIX)/bin/d_youdao
	rm -f $(DESTDIR)$(PREFIX)/bin/plainsel

.PHONY: install uninstall
