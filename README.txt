== Proven Delights

This project aims to include templated C++ implementations of many of the
algorithms from http://www.hackersdelight.org/[Hacker's Delight], alongside
http://www.cprover.org/cbmc/[CBMC]  proofs of the implementations.  While the
implementations are typically trivial, that they work at all is often
nonobvious.  Proofs can show that they work for all input values.

The fully built documentation of a recent version can always be found online:
http://jepler.github.io/ProvenDelights/

=== Structure
==== The proofs/ directory
Each file in proofs/ is an asciidoc document.  It must contain a code section
lead off by ".Implementation" which implements the function as a C++ template
or inline; and a code section lead off by ".Proof" which implements a CBMC
proof of the function's properties as given in Hacker's Delight.

Where an implementation or proof needs to use the implementation of another
function, it can #include the definition.  For example, to use the
implementation of `turn_off_rightmost_ones`, simply
----
#include "turn_off_rightmost_ones.h"
----

==== The structure/ directory
The asciidoc files in this directory create a structure which is intended to
mirror the chapter and section numbering of Hacker's Delight (second edition).
To this end, it will initially contain many empty and placeholder sections.

Where appropriate, chapter and section titles the same as those in
Hacker's Delight are used for the purpose of identifying the
correspondence between the book and this body of proofs.

==== The include/ directory
This directory holds utility code to be used in proofs, such as +assume+,
+assert+, and +proof_popcnt+.

==== The gen-include/ directory
This directory holds the generated header files for each function
implemented.

==== The docs/ directory
This directory holds the generated documentation, "proofs.html" and
"proofs.pdf"

=== Compatibility and software versions
At this time, the oldest supported environment is Debian Buster.  Generally,
the oldest supported environment will be Debian stable or oldstable.

This means that the minimum versions of relevant software are:

* http://asciidoc.org/[asciidoc 8.6.10]
* http://www.cprover.org/cbmc/[cbmc 5.10]
* http://python.org[python 3.7.3]

=== Building
The software is built by invoking +make+ in the top-level directory.
By default, all functions are proven and all forms of documentation are
built.  Parallelism can be used safely (+make -j4+ for a 4-thread system, for
instance)

Other targets include +docs+, +pdf+, and +html+ to build just (one form of)
the documentation; +proofs+ to just build the proofs, and +prove-**foo**+
to just prove *foo*.

In the case of a successful proof, the output of CBMC is left in
+.o/**foo**_proof.txt+.  In the case of a failed proof, it is left in
+.o/**foo**_proof.txt.err+.

=== Contributing
Submit contributions with github pull requests to https://github.com/jepler/ProvenDelights[].
Your contributions are subject to the https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license[GitHub Terms of Service] and must therefore be offered under the Repository License, stated below.

Respect http://www.hackersdelight.org/permissions.htm[the license
of the Hacker's Delight book].  This means that code may be
incorporated from the book, but prose may not.

=== Style
For prose, use professional English writing.

For code, use basic C++; make functions templates where appropriate,
and inlines where inappropriate.  Use the general coding style of
Hacker's Delight:

* 4-space indentation
* no literal tab characters
* open curly braces don't get their own line
* include whitespace in expressions where it improves readability

=== License
This work is licensed under a
http://creativecommons.org/licenses/by-sa/4.0/[Creative Commons
Attribution-ShareAlike 4.0 International License.]

Additionally, all blocks of code marked as ".Implementation" are also covered
under the following license (commonly known as the "zlib license"):

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
