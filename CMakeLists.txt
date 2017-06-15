CMAKE_MINIMUM_REQUIRED(VERSION 2.5)
PROJECT("sublime-glib-snippets")

set(file_name_regex "\${1/ /-/g}")
set(CamelCaseTypeRegex "\${1/[\\W_]*([^_\\W]+)[\\W_]*/\\u\\1/g}")
set(function_name_regex "\${1/([^\\w])|(\\w)/(?1_:\\L\\2)/g}")
set(MACRO_TYPE_REGEX "\${1/([\\w]+)|([\\W_])/\\U\\1(?2_:)/g}")
set(OBJECT_TYPE_REGEX "\${1/^[\\W_]*([^_\\W]+)[\\W_]+[^_\\W].*|([^_\\W]+).*/\\U\\2\\1_TYPE_/}\${1/(^[\\W_]*[^_\\W]+[\\W_]+)|([^_\\W]+)|([\\W_])/\\U\\2(?3_:)/g}")
set(SPACE_PADDING_REGEX "\${1/./ /g}")

configure_file(GObject.sublime-snippet.in GObject.sublime-snippet @ONLY)
