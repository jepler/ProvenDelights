.PHONY: default
default: all

ifeq ("$(origin V)", "command line")
BUILD_VERBOSE = $(V)
endif
ifndef BUILD_VERBOSE
BUILD_VERBOSE = 0
endif

ifeq ($(BUILD_VERBOSE),1)
Q =
A2X_DASHV := -v
else
Q = @
A2X_DASHV :=
endif

ifeq "$(findstring s,$(MAKEFLAGS))" ""
ECHO=@echo
VECHO=echo
else
ECHO=@true
VECHO=true
endif

FILES := $(wildcard proofs/*.txt)
PROOFS := $(patsubst proofs/%.txt, .o/%_proof.txt, $(FILES))
DEPS := $(patsubst proofs/%.txt, .o/%.d, $(FILES))
HEADERS := $(patsubst proofs/%.txt, gen-include/%.h, $(FILES))

-include $(DEPS)

CBMC := cbmc
CBMCFLAGS := -Iinclude -Igen-include \
	--bounds-check --div-by-zero-check --pointer-check \
	--signed-overflow-check

CXX := g++
CXXFLAGS := -Iinclude -Igen-include

.o/%.cc: proofs/%.txt preprocess.py
	$(ECHO) "GENCC" $*
	$(Q)./preprocess.py --destdir .o --proof-only $<

gen-include/%.h: proofs/%.txt preprocess.py
	$(ECHO) "GENH " $*
	$(Q)./preprocess.py --destdir $(dir $@) --header-only $<

.o/%_proof.txt: .o/%.cc
	$(ECHO) PROVE $*
	$(Q)$(CXX) $(CXXFLAGS) -MF .o/$*.d -M -MQ $@ $<
	$(Q)$(CXX) $(CXXFLAGS) -fsyntax-only $<
	$(Q)$(CBMC) $(CBMCFLAGS) $< > $@.err || true
	$(Q)if ! grep -q -F "VERIFICATION SUCCESSFUL" $@.err; then \
		echo 1>&2 "$<: VERIFICATION FAILED -- see $@.err for details"; \
		exit 1; \
	fi
	$(Q)mv -f $@.err $@

.o/prove_%:

.PHONY: proofs
proofs: $(PROOFS)

.PHONY: html
html: doc/index.html

DOCDEPS :=  structure/proofs.txt $(FILES) $(wildcard structure/*.txt) README.txt

doc/index.html: $(DOCDEPS) structure/proofs-docinfo.html
	$(ECHO) "HTML " $@
	$(Q)asciidoc -a docinfo= -n -b html5 -o $@ $<

.PHONY: pdf
pdf: doc/proofs.pdf

doc/proofs.pdf: $(DOCDEPS)
	$(ECHO) "PDF  " $@
	$(Q)a2x $(A2X_DASHV) --no-xmllint -f pdf --dblatex-opts "-o $@ -P doc.publisher.show=0 -P latex.output.revhistory=0"  $<

.PHONY: docs
docs: html pdf

.PHONY: all
all: proofs docs

Makefile: $(HEADERS)

.PHONY: clean
clean:
	$(ECHO) "CLEAN"
	$(Q)rm -rf .o doc gen-include

.PRECIOUS: .o/%.cc
$(shell mkdir -p doc)

.PHONY: prove-%
prove-%: .o/%_proof.txt
	@:

.PHONY: publish
publish: docs
	$(ECHO) "PUBLISH"
	$(V)git branch -D gh-pages || true
	$(V)./docimport.py | git fast-import --date-format=now
	$(V)git push -f origin gh-pages
