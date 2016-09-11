# csafe

## What is csafe?

csafe is a Perl script that scans for the usage of potentially dangerous functions in c/c++ code and suggests replacements.

## Usage:

perl csafe.pl /name/of/c/c++/directory

## Example output:

============ Running csafe v1.0.0 ============
   -> directory: /Users/user/Desktop/examplelib
   -> datetime: Sun Sep 11 02:33:48 2016
   -> file types: .c, .cpp

/src/convert/convert.c:524: Use of potentially dangerous function memcpy: Consider replacing with memcpy_s
/src/convert/profiler.c:228: Use of potentially dangerous function sprintf: Consider replacing with snprintf
/src/common/utils.c:192: Use of potentially dangerous function memcpy: Consider replacing with memcpy_s
/src/core.c:55: Use of potentially dangerous function strlen: Consider replacing with strnlen_s
/src/core.c:77: Use of potentially dangerous function strncpy: Consider replacing with strlcpy/strcpy_s
/src/core.c:1963: Use of potentially dangerous function strlen: Consider replacing with strnlen_s
/src/data/helper.c:313: Use of potentially dangerous function sscanf: Consider replacing with sscanf_s

============ END REPORT csafe v1.0.0 ============

## Contributions:

Copyright Chandler Freeman, 2016
