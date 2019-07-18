# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC=$(wildcard src/*.c)
src_headers=$(wildcard src/*.h)

scripts=$(wildcard scripts/*)
scripts_names=$(patsubst scripts/%,%,$(scripts))


binary=out/st
manpage=out/st.1


mansrc=$(wildcard doc/*.man)
mansrc_patch=$(wildcard doc/patch/*.man)


all: options out $(manpage) $(binary)


options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"


out:
	mkdir out


src/config.h:
	cp src/config.def.h src/config.h


binary: $(binary)


man: $(manpage)


$(binary): out $(SRC) $(src_headers)
	$(CC) -o $@ $(SRC) $(STDFLAGS) $(STLDFLAGS) $(STCFLAGS)


$(manpage): out $(mansrc) $(mansrc_patch) extract-shortcuts.sh src/config.h
	sed "s/VERSION/$(VERSION)/g" doc/st.man > $(manpage)
	./extract-shortcuts.sh >> $(manpage)
	cat doc/sh-patches.man $(mansrc_patch) >> $(manpage)
	cat doc/footer.man >> $(manpage)


clean:
	rm -rf out/ st-$(VERSION).tar.gz



dist: clean
	mkdir -p st-$(VERSION)\
	 st-$(VERSION)/src\
	 st-$(VERSION)/doc/patch
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
	 st.info\
	 doc/\
	 src/\
	 scripts/\
	 patches/\
	 st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -rf st-$(VERSION)


echo-install-scripts:
	@echo $(patsubst scripts/%,$(DESTDIR)$(PREFIX)/%,$(scripts))


install-scripts: $(scripts)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp $(scripts) $(DESTDIR)$(PREFIX)/bin/
	chmod 775 $(patsubst scripts/%,$(DESTDIR)$(PREFIX)/bin/%,$(scripts))


install-binary: $(binary)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(binary) $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	tic -sx st.info


install-manpage: $(manpage)
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	cp -f $(manpage) $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1


install: install-binary install-manpage install-scripts
	@echo Please see the README file regarding the terminfo entry of st.


uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1


.PHONY: all options clean dist install uninstall echo-install-scripts install-manpage install-binary install-scripts
