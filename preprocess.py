#!/usr/bin/python3
import sys
import os
import argparse

def get_block(l, h):
    i = l.index('.' + h)
    j = l.index('----', i+1)
    k = l.index('----', j+1)
    return j+1, l[j+1:k]

def convert(fn, args):
    with open(fn) as f:
        lines = [line.rstrip() for line in f]
        imp_line, implementation = get_block(lines, args.imarker)
        proof_line, proof = get_block(lines, args.pmarker)

    basename = os.path.splitext(os.path.basename(fn))[0]
    header = os.path.join(args.destdir, basename + '.h')
    guard = 'HD2E_%s' % basename.upper()
    if not args.proof_only:
        with open(header, 'w') as f:
            print('#ifndef %s' % guard, file=f)
            print('#define %s' % guard, file=f)
            for line in implementation:
                print(line, file=f)
            print('#endif', file=f)

    proof_cc = os.path.join(args.destdir, basename + '.cc')
    if not args.header_only:
        with open(proof_cc, 'w') as f:
            print('#include "proof_common.h"', file=f)
            print('#line %d "%s"' % (imp_line, fn), file=f)
            for line in implementation:
                print(line, file=f)
            print('#line %d "%s"' % (proof_line, fn), file=f)
            for line in proof:
                print(line, file=f)

parser = argparse.ArgumentParser()
parser.add_argument("--imarker", help="marker for implementation",
    default="Implementation")
parser.add_argument("--pmarker", help="marker for proof", default="Proof")
parser.add_argument("--destdir", help="destination directory")
parser.add_argument("--proof-only", help="only create proof program", action='store_true')
parser.add_argument("--header-only", help="only create header", action='store_true')
parser.add_argument("filename", nargs="+")
args = parser.parse_args()

try:
    os.makedirs(args.destdir)
except os.error:
    pass


for fn in args.filename: convert(fn, args)
