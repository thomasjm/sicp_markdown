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
sed -i 's/^>/> /g' $OUT

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

# Remove extra spaces in bullets and block quotes
perl -i -pe 's/^-\s+/- /g' $OUT
perl -i -pe 's/^>\s+/> /g' $OUT

# Make footnotes better behaved
perl -i -pe 's/^\[\^(\d+)\^\]\([^\)]*\)\{[^}]*\}/\[\^$1\]:/g' $OUT
# Clean up citations to footnotes
perl -i -pe 's/\[\^(\d+)\^\]\([^\)]*\)\{[^}]*\}/\[\^$1\]/g' $OUT

# Turn footnotes into inline footnotes
python inliner.py $OUT $OUT

# Make exercise blocks not indented
# Do this before moving MathJax block maths to their own lines, because that can break
# up an exercise
python deindent_exercises.py $OUT $OUT

# Make sure MathJax block maths are on their own lines
perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)/\n$1\n/sgm' $OUT
