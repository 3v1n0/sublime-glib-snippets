file_name_regex = $${1/ /-/g}
CamelCaseTypeRegex = $${1/[\W_]*([^_\W]+)[\W_]*/\u\1/g}
function_name_regex = $${1/([^\w])|(\w)/(?1_:\L\2)/g}
MACRO_TYPE_REGEX = $${1/([\w]+)|([\W_])/\U\1(?2_:)/g}
OBJECT_TYPE_REGEX = $${1/^[\W_]*([^_\W]+)[\W_]+[^_\W].*|([^_\W]+).*/\U\2\1_TYPE_/}$${1/(^[\W_]*[^_\W]+[\W_]+)|([^_\W]+)|([\W_])/\U\2(?3_:)/g}
SPACE_PADDING_REGEX = $${1/./ /g}

SHELL='/bin/bash'
TEMPFILE := $(shell mktemp)
INPUTS=$(wildcard *.sublime-snippet.in)
GENERATED=$(INPUTS:.sublime-snippet.in=.sublime-snippet)

all: $(GENERATED)

define escape_regex
$(shell echo '$(1)' | sed -E 's,([\#$$%&\]),\\&,g;')
endef

%.sublime-snippet: %.sublime-snippet.in
	cp $< $(TEMPFILE)
	sed 's,@file_name_regex@,$(call escape_regex,$(file_name_regex)),g;' -i $(TEMPFILE)
	sed 's,@CamelCaseTypeRegex@,$(call escape_regex,$(CamelCaseTypeRegex)),g;' -i $(TEMPFILE)
	sed 's,@function_name_regex@,$(call escape_regex,$(function_name_regex)),g;' -i $(TEMPFILE)
	sed 's,@MACRO_TYPE_REGEX@,$(call escape_regex,$(MACRO_TYPE_REGEX)),g;' -i $(TEMPFILE)
	sed 's,@OBJECT_TYPE_REGEX@,$(call escape_regex,$(OBJECT_TYPE_REGEX)),g;' -i $(TEMPFILE)
	sed 's,@SPACE_PADDING_REGEX@,$(call escape_regex,$(SPACE_PADDING_REGEX)),g' -i $(TEMPFILE)
	mv $(TEMPFILE) $@

clean:
	rm -f *.sublime-snippet
