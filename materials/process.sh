#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE=$1
OUTFOLDER=$SCRIPTDIR/$2
TMP=$SCRIPTDIR/wip.md

pandoc $FILE --wrap=none --from=html-raw_html --to=markdown-raw_html-header_attributes -o $TMP

# Fix image links
python fig_inserter.py $FILE $TMP
# Remove lines that just say "SVG"
perl -i -pe 's/^SVG\n//gm' $TMP

# Delete the first 3 lines of the file since they are just navigation links
sed -i 1,3d $TMP

# Fix code block headers
sed -i 's/{.lisp/{.scheme/g' $TMP
sed -i 's/ .prettyprinted style=""//g' $TMP

# Make sure block quotes have a space for empty lines
sed -i 's/^>$/> /g' $TMP

# Remove div lines
perl -i -pe 's/<\/div>\n//g' $TMP
perl -i -pe 's/<div .*\n//g' $TMP

# Remove link thingies
# perl -i -pe 's/ ?\[\]\(\)\{#[^}]*\}//g' $TMP
perl -i -pe 's/ ?\[\]\{#[^}]*\}//g' $TMP
#perl -i -pe 's/\[\]\(\)\{#[^}]*\}//g' $TMP
#perl -i -pe 's/\{#[^}]*\}//g' $TMP

# Convert spans to plain text
#perl -i -pe 's/<span[^>]*>([^<]*)<\/span>/$1/g' $TMP
perl -i -pe 's/\[([^\]]*)\]\{[^}]*\}/ $1/g' $TMP

# Convert headings to be larger so we don't end up with level 4 headings
sed -i 's/^### /# /g' $TMP
sed -i 's/^#### /## /g' $TMP
sed -i 's/^##### /### /g' $TMP

# Remove extra spaces in headings
perl -i -pe 's/^#\s+/# /g' $TMP
perl -i -pe 's/^##\s+/## /g' $TMP
perl -i -pe 's/^###\s+/### /g' $TMP

# Make exercise blocks not indented
# Do this before moving MathJax block maths to their own lines, because that can break up an exercise
# Do this before removing extra space block quotes, because that would deindent the exercises
python deindent_exercises.py $TMP $TMP

# Remove extra spaces in bullets and block quotes
perl -i -pe 's/^-\s+/- /g' $TMP
perl -i -pe 's/^>\s+/> /g' $TMP

# Make footnotes better behaved
perl -i -pe 's/^\[\^(\d+)\^\]\([^\)]*\)\{[^}]*\}/\[\^$1\]:/g' $TMP
# Clean up citations to footnotes
perl -i -pe 's/\[\^(\d+)\^\]\([^\)]*\)\{[^}]*\}/\[\^$1\]/g' $TMP

# Turn footnotes into inline footnotes
python inliner.py $TMP $TMP

# Make sure MathJax block maths are on their own lines
# perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)/\n\n$1\n\n/sgm' $TMP
perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)/\n\n$1\n\n/sgm' $TMP
# We might have over-spaced, some, so fix this
# Remove extra newlines at the end
perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)\n\n\n\n/$1\n\n/sgm' $TMP
perl -i -pe 'BEGIN {undef $/;} s/(\$\$[^\$]+\$\$)\n\n\n/$1\n\n/sgm' $TMP
# Remove extra newlines at the beginning
perl -i -pe 'BEGIN {undef $/;} s/\n\n\n\n(\$\$[^\$]+\$\$)/\n\n$1/sgm' $TMP
perl -i -pe 'BEGIN {undef $/;} s/\n\n\n(\$\$[^\$]+\$\$)/\n\n$1/sgm' $TMP

# Remove the footnotes heading at the bottom
perl -i -pe 's/## Footnotes//g' $TMP

# Remove extra newlines at end of file
# https://unix.stackexchange.com/questions/81685/how-to-remove-multiple-newlines-at-eof
awk '/^$/ {nlstack=nlstack "\n";next;} {printf "%s",nlstack; nlstack=""; print;}' $TMP > tmp.md
cp tmp.md $TMP


# Figure out the title this document should have and move it there
OUT="$OUTFOLDER/$(cat $TMP | grep "# " -m 1 | cut -c 3-).md"
echo "Out: $OUT"
cp $TMP "$OUT"
