#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf $SCRIPTDIR/rendered
mkdir -p $SCRIPTDIR/rendered

./process.sh $SCRIPTDIR/sicp/html/1_002e1.xhtml rendered/1_1.md
./process.sh $SCRIPTDIR/sicp/html/1_002e2.xhtml rendered/1_2.md
./process.sh $SCRIPTDIR/sicp/html/1_002e3.xhtml rendered/1_3.md
./process.sh $SCRIPTDIR/sicp/html/2_002e1.xhtml rendered/2_1.md
./process.sh $SCRIPTDIR/sicp/html/2_002e2.xhtml rendered/2_2.md
./process.sh $SCRIPTDIR/sicp/html/2_002e3.xhtml rendered/2_3.md
./process.sh $SCRIPTDIR/sicp/html/2_002e4.xhtml rendered/2_4.md
./process.sh $SCRIPTDIR/sicp/html/2_002e5.xhtml rendered/2_5.md
./process.sh $SCRIPTDIR/sicp/html/3_002e1.xhtml rendered/3_1.md
./process.sh $SCRIPTDIR/sicp/html/3_002e2.xhtml rendered/3_2.md
./process.sh $SCRIPTDIR/sicp/html/3_002e3.xhtml rendered/3_3.md
./process.sh $SCRIPTDIR/sicp/html/3_002e4.xhtml rendered/3_4.md
./process.sh $SCRIPTDIR/sicp/html/3_002e5.xhtml rendered/3_5.md
./process.sh $SCRIPTDIR/sicp/html/4_002e1.xhtml rendered/4_1.md
./process.sh $SCRIPTDIR/sicp/html/4_002e2.xhtml rendered/4_2.md
./process.sh $SCRIPTDIR/sicp/html/4_002e3.xhtml rendered/4_3.md
./process.sh $SCRIPTDIR/sicp/html/4_002e4.xhtml rendered/4_4.md
./process.sh $SCRIPTDIR/sicp/html/5_002e1.xhtml rendered/5_1.md
./process.sh $SCRIPTDIR/sicp/html/5_002e2.xhtml rendered/5_2.md
./process.sh $SCRIPTDIR/sicp/html/5_002e3.xhtml rendered/5_3.md
./process.sh $SCRIPTDIR/sicp/html/5_002e4.xhtml rendered/5_4.md
./process.sh $SCRIPTDIR/sicp/html/5_002e5.xhtml rendered/5_5.md
