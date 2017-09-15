#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE=$1
OUT=$SCRIPTDIR/$2

pandoc $FILE --wrap=none --from=html-raw_html --to=markdown-raw_html-header_attributes  -o $OUT

# Fix image links
python fig_inserter.py $FILE $OUT
# Remove lines that just say "SVG"
perl -i -pe 's/^SVG\n//gm' $OUT

# Delete the first 3 lines of the file since they are just navigation links
sed -i 1,3d $OUT

# Fix code block headers
sed -i 's/{.lisp/{.scheme/g' $OUT
sed -i 's/ .prettyprinted style=""//g' $OUT

# Make sure block quotes have a space for empty lines
sed -i 's/^>$/> /g' $OUT

# Remove div lines
perl -i -pe 's/<\/div>\n//g' $OUT
perl -i -pe 's/<div .*\n//g' $OUT

# Remove link thingies
# perl -i -pe 's/ ?\[\]\(\)\{#[^}]*\}//g' $OUT
perl -i -pe 's/ ?\[\]\{#[^}]*\}//g' $OUT
#perl -i -pe 's/\[\]\(\)\{#[^}]*\}//g' $OUT
#perl -i -pe 's/\{#[^}]*\}//g' $OUT

# Convert spans to plain text
#perl -i -pe 's/<span[^>]*>([^<]*)<\/span>/$1/g' $OUT
perl -i -pe 's/\[([^\]]*)\]\{[^}]*\}/ $1/g' $OUT

# Convert headings to be larger so we don't end up with level 4 headings
sed -i 's/^### /# /g' $OUT
sed -i 's/^#### /## /g' $OUT
sed -i 's/^##### /### /g' $OUT

# Remove extra spaces in headings
perl -i -pe 's/^#\s+/# /g' $OUT
perl -i -pe 's/^##\s+/## /g' $OUT
perl -i -pe 's/^###\s+/### /g' $OUT

# Make exercise blocks not indented
# Do this before moving MathJax block maths to their own lines, because that can break up an exercise
# Do this before removing extra space block quotes, because that would deindent the exercises
python deindent_exercises.py $OUT $OUT

# Remove extra spaces in bullets and block quotes
perl -i -pe 's/^-\s+/- /g' $OUT
perl -i -pe 's/^>\s+/> /g' $OUT

# Make footnotes better behaved
perl -i -pe 's/^\[\^(\d+)\^\]\([^\)]*\)\{[^}]*\}/\[\^$1\]:/g' $OUT
# Clean up citations to footnotes
perl -i -pe 's/\[\^(\d+)\^\]\([^\)]*\)\{[^}]*\}/\[\^$1\]/g' $OUT

# Turn footnotes into inline footnotes
python inliner.py $OUT $OUT

# Make sure MathJax block maths are on their own lines
# perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)/\n\n$1\n\n/sgm' $OUT
perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)/\n\n$1\n\n/sgm' $OUT
# We might have over-spaced, some, so fix this
# Remove extra newlines at the end
perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)\n\n\n\n/$1\n\n/sgm' $OUT
perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)\n\n\n/$1\n\n/sgm' $OUT
# Remove extra newlines at the beginning
perl -i -pe 'BEGIN {undef $/;} s/\n\n\n\n(\$\$[^\$]+\$\$)/\n\n$1/sgm' $OUT
perl -i -pe 'BEGIN {undef $/;} s/\n\n\n(\$\$[^\$]+\$\$)/\n\n$1/sgm' $OUT

# Remove the footnotes heading at the bottom
perl -i -pe 's/## Footnotes//g' $OUT

# Remove extra newlines at end of file
# https://unix.stackexchange.com/questions/81685/how-to-remove-multiple-newlines-at-eof
awk '/^$/ {nlstack=nlstack "\n";next;} {printf "%s",nlstack; nlstack=""; print;}' $OUT > tmp.md
cp tmp.md $OUT
