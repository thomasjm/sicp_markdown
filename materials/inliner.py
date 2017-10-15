#!/usr/bin/env python

import re

# inliner - converts reference-style Markdown endnotes to
# Pandoc Markdown's inline footnotes

# by Louis Goddard <louisgoddard@gmail.com>

# Usage: python inliner.py [input.markdown] [output.markdown]

import sys

with open(sys.argv[1], "r") as input:
    text = input.read()

counter = 3

def getRef(counter):
    return "[^" + str(counter) + "]:"

def getCite(counter):
    return "[^" + str(counter) + "]"

while True:
    match = re.search("\[\^(\d+)\]:", text)
    if match is None: break

    counter = int(match.group(1))

    ref = getRef(counter)
    nextRef = getRef(counter + 1)
    cite = getCite(counter)

    try:
        refStart = text.index(ref)
        refEnd = text.index("\n", refStart)
    except ValueError:
        print("Couldn't find ref %d, stopping" % counter)
        break

    note = "^[" + text[(refStart + (len(str(counter)) + 5)):refEnd] + "]"
    text = text.replace(cite, note)
    # text = re.sub("\[\^%d\](?!:)" % counter, note, text)

    print("Processed footnote %d" % counter)

# Cut off the references from the end
match = re.search("\n\^\[", text)
if match:
    text = text[0:match.start()]

with open(sys.argv[2], "w") as output:
    output.write(text)
