#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -f ../*.md

./process.sh $SCRIPTDIR/sicp/html/1_002e1.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/1_002e2.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/1_002e3.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/2_002e1.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/2_002e2.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/2_002e3.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/2_002e4.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/2_002e5.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/3_002e1.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/3_002e2.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/3_002e3.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/3_002e4.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/3_002e5.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/4_002e1.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/4_002e2.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/4_002e3.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/4_002e4.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/5_002e1.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/5_002e2.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/5_002e3.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/5_002e4.xhtml ..
./process.sh $SCRIPTDIR/sicp/html/5_002e5.xhtml ..
