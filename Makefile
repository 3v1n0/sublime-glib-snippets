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

define replace_var_pattern
's,@$(1)@,$(call escape_regex,$($(1))),g'
endef

%.sublime-snippet: %.sublime-snippet.in
	sed -e $(call replace_var_pattern,file-name-regex) \
	    -e $(call replace_var_pattern,CamelCaseTypeRegex) \
	    -e $(call replace_var_pattern,function_name_regex) \
	    -e $(call replace_var_pattern,MACRO_TYPE_REGEX) \
	    -e $(call replace_var_pattern,NAMESPACE_REGEX) \
	    -e $(call replace_var_pattern,CLASS_NAME_REGEX) \
	    -e $(call replace_var_pattern,OBJECT_TYPE_REGEX) \
	    -e $(call replace_var_pattern,SPACE_PADDING_REGEX) \
	    $< > $@

clean:
	rm -f *.sublime-snippet
