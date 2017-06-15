file-name-regex = $${1/[\W]/-/g}
CamelCaseTypeRegex = $${1/[\W_]*([^_\W]+)[\W_]*/\u\1/g}
function_name_regex = $${1/([^\w])|(\w)/(?1_:\L\2)/g}
MACRO_TYPE_REGEX = $${1/([\w]+)|([\W_])/\U\1(?2_:)/g}
NAMESPACE_REGEX  = $${1/^[\W_]*([^_\W]+)[\W_]+[^_\W].*|([^_\W]+).*/\U\2\1/}
CLASS_NAME_REGEX = $${1/(^[\W_]*[^_\W]+[\W_]+)|([^_\W]+)|([\W_])/\U\2(?3_:)/g}
OBJECT_TYPE_REGEX = $(NAMESPACE_REGEX)_TYPE_$(CLASS_NAME_REGEX)

SPACE_PADDING_REGEX = $${1/./ /g}

SHELL='/bin/bash'
INPUTS=$(wildcard *.sublime-snippet.in)
GENERATED=$(INPUTS:.sublime-snippet.in=.sublime-snippet)

all: $(GENERATED)

define escape_regex
$(shell echo '$(1)' | sed -E 's,([\#$$%&\]),\\&,g;')
endef

%.sublime-snippet: %.sublime-snippet.in
	sed -e 's,@file-name-regex@,$(call escape_regex,$(file-name-regex)),g;' \
	    -e 's,@CamelCaseTypeRegex@,$(call escape_regex,$(CamelCaseTypeRegex)),g' \
	    -e 's,@function_name_regex@,$(call escape_regex,$(function_name_regex)),g' \
	    -e 's,@MACRO_TYPE_REGEX@,$(call escape_regex,$(MACRO_TYPE_REGEX)),g' \
	    -e 's,@NAMESPACE_REGEX@,$(call escape_regex,$(NAMESPACE_REGEX)),g' \
	    -e 's,@CLASS_NAME_REGEX@,$(call escape_regex,$(CLASS_NAME_REGEX)),g' \
	    -e 's,@OBJECT_TYPE_REGEX@,$(call escape_regex,$(OBJECT_TYPE_REGEX)),g' \
	    -e 's,@SPACE_PADDING_REGEX@,$(call escape_regex,$(SPACE_PADDING_REGEX)),g' \
	    $< > $@

clean:
	rm -f *.sublime-snippet
