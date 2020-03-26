# ======================================================================
# Makefile - builds the legacy volano.com website with SiteMesh 3
# ======================================================================

# Commands
SITEMESH = java -jar $(HOME)/lib/sitemesh-3.0.2-SNAPSHOT.jar
TIDY     = $(HOME)/opt/tidy-html5-5.7.27/bin/tidy
SED      = sed

# Command options
SITEMESH_OPTS = -src src -dest tmp -config blueprint.xml

# HTML Tidy options
# https://api.html-tidy.org/tidy/quickref_next.html
tidy_html = --quiet yes --tidy-mark no --wrap 0

# Fixes the HTML Tidy output for validation
sed_type := 's/<style type="text\/css">/<style>/'
sed_html := -e $(sed_type)

# Lists of targets
src_names := $(wildcard src/*.html)
basenames := $(notdir $(src_names))
doc_names := $(addprefix docs/,$(basenames))

# ======================================================================
# Pattern Rules
# ======================================================================

tmp/%.html: src/%.html blueprint.html | tmp
	$(SITEMESH) $(SITEMESH_OPTS) $(notdir $<)

docs/%.html: tmp/%.html
	$(TIDY) $(tidy_html) $< | $(SED) $(sed_html) > $@

# ======================================================================
# Explicit Rules
# ======================================================================

.PHONY: all clean

all: $(doc_names)

tmp:
	mkdir -p $@

clean:
	rm -f docs/*.html tmp/*
