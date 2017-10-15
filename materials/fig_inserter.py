#!/usr/bin/env python

import re

# inliner - converts reference-style Markdown endnotes to
# Pandoc Markdown's inline footnotes

# by Louis Goddard <louisgoddard@gmail.com>

# Usage: python inliner.py [input.markdown] [output.markdown]

import sys

with open(sys.argv[1], "r") as input:
    html = input.read()

with open(sys.argv[2], "r") as input:
    markdown = input.read()

# First, look for link tags

for match in re.finditer("<a id=\"(Figure[^\"]*)\"", html):
    link = match.groups(1)
    print("Link was %s" % link)

    # The next line should be an object tag containing the SVG path; parse this out
    pos = match.start()
    while html[pos] != '\n': pos += 1
    pos += 1

    obj = ""
    while html[pos] != '\n':
        obj += html[pos]
        pos += 1

    svgPath = ""
    parts = obj.split(" ")
    for part in parts:
        separated = part.split("=")
        if len(separated) < 2: continue

        lhs = separated[0]
        rhs = separated[1]

        if lhs == "data":
            svgPath = rhs[1:-1]
            break
    print("svgPath: %s" % svgPath)

    # Also parse out the width and height
    width = ""
    height = ""
    widthMatch = re.search("width: ([^;]*)ex;", obj)
    if widthMatch: width = widthMatch.groups(1)[0]
    heightMatch = re.search("height: ([^;]*)ex;", obj)
    if heightMatch: height = heightMatch.groups(1)[0]
    # Convert the width and height to pixels at a rate of 12px = 1ex
    width = 12 * float(width)
    height = 12 * float(height)
    print("Width: %s" % width)
    print("Height: %s" % height)

    # Find where this link occurs in the Markdown and replace it with a Markdown image link
    print(link)
    toFind = "[]{#" + link[0] + "}"
    print("toFind: %s" % toFind)
    markdown = markdown.replace(toFind, "![](%s %sx%s)" % (svgPath, width, height))


with open(sys.argv[2], "w") as output:
    output.write(markdown)
