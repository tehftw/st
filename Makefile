# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC=$(wildcard src/*.c)
src_headers=$(wildcard src/*.h)


binary=out/st
manpage=out/st.1


mansrc=$(wildcard doc/*.man)
mansrc_patch=$(wildcard doc/patch/*.man)


all: options out binary $(manpage) $(binary)


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

$(binary): out $(SRC) $(src_headers)
	$(CC) -o $@ $(SRC) $(STDFLAGS) $(STLDFLAGS) $(STCFLAGS)

man: $(manpage)

$(manpage): out $(mansrc) $(mansrc_patch)
	cat doc/st.man $(mansrc_patch) doc/footer.man > out/st.1

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
	 st-$(VERSION)
	tar -cf - st-$(VERSION) | gzip > st-$(VERSION).tar.gz
	rm -rf st-$(VERSION)


install: $(binary) $(manpage)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f out/st $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" $(manpage) > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	tic -sx st.info
	@echo Please see the README file regarding the terminfo entry of st.


uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1


.PHONY: all options clean dist install uninstall
