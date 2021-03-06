# Generated automatically from Makefile.in by configure.
#
# This Makefile uses gmake features, by now
#

CC = gcc
CFLAGS = -g -O2 -Zmt -Wall -DNO_GETOPT -DNO_LIBPAPER 
RANLIB = ranlib

INSTALL = ./install-sh -c

LDFLAGS = -Zexe -L. -l$(TARGET) 

prefix = /usr/local
BINDIR = $(prefix)/bin
LIBDIR = $(prefix)/lib
INCDIR = $(prefix)/include
MAN1DIR = $(prefix)/man/man1
MAN3DIR = $(prefix)/man/man3
INFODIR = $(prefix)/info

# getopt may be installed or not, if not take our copy
GETOPT_O = compat/getopt.o

TARGET = barcode
LIBRARY = lib$(TARGET).a
MAN1 = $(TARGET).1
MAN3 = $(TARGET).3
INFO = doc/$(TARGET).info
HEADER = $(TARGET).h

LIBOBJECTS = library.o ean.o code128.o code39.o i25.o ps.o
EXEOBJECTS = main.o cmdline.o $(GETOPT_O)

all: $(TARGET) $(LIBRARY) $(MAN1) $(MAN3) $(INFO) sample

$(TARGET): $(LIBRARY) $(EXEOBJECTS)
	$(CC) $(CFLAGS) $(EXEOBJECTS) $(LDFLAGS) -o $(TARGET)

sample: sample.o $(LIBRARY)
	$(CC) $(CFLAGS) sample.o $(LDFLAGS) -o $@

# Avoid the standard CFLAGS, to avoid -Wall and -DNO_GETOPT
compat/getopt.o: compat/getopt.c
	$(CC) -O -c $^ -o $@

$(LIBRARY): $(LIBOBJECTS)
	$(AR) r $(LIBRARY) $(LIBOBJECTS)
	$(RANLIB) $(LIBRARY)

$(MAN1) $(MAN3): doc/doc.$(TARGET)
	awk -f doc/manpager $^


$(INFO): doc/doc.$(TARGET)
	$(MAKE) -C doc

install:
	$(INSTALL) -d $(BINDIR) $(INCDIR) $(LIBDIR) $(MAN1DIR) \
		$(MAN3DIR) $(INFODIR)
	$(INSTALL) -c $(TARGET) $(BINDIR)
	$(INSTALL) -c -m 0644 $(HEADER) $(INCDIR)
	$(INSTALL) -c -m 0644  $(LIBRARY) $(LIBDIR)
	$(INSTALL) -c -m 0644  $(MAN1) $(MAN1DIR)
	$(INSTALL) -c -m 0644  $(MAN3) $(MAN3DIR)
	$(INSTALL) -c -m 0644  $(INFO) $(INFODIR)

uninstall:
	$(RM) -f $(BINDIR)/$(TARGET)
	$(RM) -f $(INCDIR)/$(HEADER)
	$(RM) -f $(LIBDIR)/$(LIBRARY)
	$(RM) -f $(MAN1DIR)/$(MAN1)
	$(RM) -f $(MAN3DIR)/$(MAN3)
	$(RM) -f $(INDODIR)/$(INFO)

mostlyclean:
	$(RM) -f *.o */*.o *~ */*~ $(TARGET) $(LIBRARY)
	$(RM) -f  $(MAN1) $(MAN3) core sample
	$(MAKE) -C doc terse
	$(RM) -f .depend

clean: mostlyclean
	# remove the documents, too
	$(MAKE) -C doc clean

distclean: mostlyclean
	if [ -f build ]; then debian/rules clean; fi
	# remove the configure stuff as well
	$(RM) -f Makefile config.h config.log config.status config.cache


Makefile: Makefile.in configure
	./configure

configure: configure.in
	autoconf

.depend: $(wildcard *.[c])
	$(CC) $(CFLAGS) -MM $^ > $@

depend: .depend

tar:
	@if [ "x" = "x$(RELEASE)" ]; then \
	    n=`basename \`pwd\``; cd ..; tar cvf - $$n | gzip > $$n.tar.gz; \
	    echo 'you can set a numeric $$(RELEASE) to make a named tar'; \
	else \
	    mkdir ../$(TARGET)-$(RELEASE) || exit 1; \
	    cp -a . ../$(TARGET)-$(RELEASE) && cd .. && \
	        tar --exclude '*/CVS*' \
		    -cvzf $(TARGET)-$(RELEASE).tar.gz $(TARGET)-$(RELEASE); \
	fi

# print the version, as I usually forget to update it when distributing
printv:
	@grep -n VERSION $(HEADER) /dev/null
	@grep -n set.version doc/doc.$(TARGET) /dev/null
	@grep -n dpkg.-i INSTALL

# and this is how I make the distribution
distrib: $(INFO) distclean tar printv


.PHONY: all install uninstall mostlyclean clean disclean depend \
	tar printv distrib

ifeq (.depend,$(wildcard .depend))
include .depend
endif

