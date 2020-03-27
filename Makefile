# ======================================================================
# Makefile - builds the volano.com website with SiteMesh and Blueprint
# ======================================================================

# Commands
SITEMESH = java -jar $(HOME)/lib/sitemesh-3.0.2-SNAPSHOT.jar
TIDY     = $(HOME)/opt/tidy-html5-5.7.27/bin/tidy
COMPRESS = yui-compressor

# Command options
SITEMESH_OPTS = -src src -dest tmp -config blueprint.xml

# HTML Tidy options
# https://api.html-tidy.org/tidy/quickref_next.html
tidy_html = --quiet yes --tidy-mark no --wrap 0

# Fixes the HTML Tidy output for validation
sed_type := 's|<style type="text/css">|<style>|'
sed_html := -e $(sed_type)

# List of HTML targets
html_src := $(wildcard src/*.html)
html_out := $(addprefix docs/,$(notdir $(html_src)))

# List of CSS targets
blueprint := ie.css print.css screen.css
css_out   := $(addprefix docs/styles/,$(blueprint))

# ======================================================================
# Pattern Rules
# ======================================================================

tmp/%.html: src/%.html blueprint.html | tmp
	$(SITEMESH) $(SITEMESH_OPTS) $(notdir $<)

docs/%.html: tmp/%.html
	$(TIDY) $(tidy_html) $< | sed $(sed_html) > $@

docs/styles/%.css: tmp/%.css
	$(COMPRESS) -o $@ $<

# ======================================================================
# Explicit Rules
# ======================================================================

.PHONY: all html css clean

all: html css

html: $(html_out)

css: $(css_out)

tmp/ie.css: blueprint/ie.css css/my-ie.css
tmp/print.css: blueprint/print.css css/my-print.css
tmp/screen.css: blueprint/screen.css css/blueprint.css css/page.css css/colors.css

tmp/ie.css tmp/print.css tmp/screen.css: | tmp
	cat $^ > $@

tmp:
	mkdir -p $@

clean:
	rm -f docs/*.html docs/styles/*.css tmp/*
