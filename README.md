# NAME

Perl::Critic::Policy::ControlStructures::ProhibitEmptyConditionalBlocks - Write no if, elsif, else or unless with nothing in its block.

# VERSION

version 0.001

# Perl::Critic::Policy::ControlStructures::ProhibitEmptyConditionalBlocks

A branch with nothing in it is a branch that does nothing, written out so the
reader has to work that out.  Say what does happen instead: invert the
condition, or return early.

```
if ( $query->{raw} ) {          # reported
    # raw skips the filters.
}
elsif ( @acls ) {
    ...
}

# raw skips the filters.
return if $query->{raw};
...
```

A comment does not make a block less empty.  Put it beside the code that the
condition guards, where it explains something.

## PROHIBITED

```
if ($x) {}                      # each of these blocks
if ($x) { # nothing to do       # holds no statement
}
unless ($x) {}
if ($x) { f() } elsif ($y) {}
if ($x) { f() } else {}
if ($x) { ; }                   # a null statement is none
```

## ALLOWED

```perl
if ($x) { f() }
f() if $x;                      # no block
while ( waitpid( -1, WNOHANG ) > 0 ) {}    # a loop, not a conditional
sub noop {}                     # a sub, not a conditional
```

## CAVEATS

Only `if`, `elsif`, `else` and `unless` are read.  An empty loop body can
be the point of the loop, when its condition does the work, so loops are left
alone.

Each empty block is a violation of its own, reported at the keyword that opens
it.

## METHODS

### supported\_parameters

### default\_severity

### default\_themes

### applies\_to

### violates

# AUTHORS

Current Maintainers:

- George S. Baugh <george@troglodyne.net>

# COPYRIGHT AND LICENSE

Copyright (c) 2026 Troglodyne LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
