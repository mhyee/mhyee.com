---
created_at: 2010-03-05
foo: bar_
excerpt: When I started using C in CS137, one of the tips I picked up on was passing options to the compiler to request warnings.
kind: article
tags: [ gcc, 'g++', compiler, perl ]
title: "gcc/g++ compiler options"
---

When I started using C in CS137, one of the tips I picked up on was passing options to the compiler to request warnings.  This usually meant having to type a long line of options every time I wanted to compile something.  Additionally, I wasn't a big fan of the `a.out` default filenames, so I wanted to specify my own.

So I borrowed and modified a quick Perl script to do this for me: it takes the source code as the argument, and runs `gcc` on it, with all my favourite options passed to the compiler.

    #!perl
    #!/usr/bin/perl

    my $output = $ARGV[0];
    $output =~ s/(.*)\.c$/$1/;

    exec("/usr/bin/gcc @ARGV -o $output -std=c99 -lm -Wall -W -pedantic");

This takes my source file, runs `gcc` on it with arguments to use the C99 standard, enable warnings, and give the compiled file the same name as the source (without the .c extension).

I saved this as `gcc2`, changed the permissions so it'd be executable, and added this line to `.bash_login`:

    #!bash
    alias gcc2="/Users/mhyee/gcc2";

This allows me to simply type `gcc2 source.c` without the entire path.

Now that we've moved to C++ in CS138, I did the same thing for compiling C++ files.

    #!perl
    #!/usr/bin/perl

    my $output = $ARGV[0];
    $output =~ s/(.*)\.(C|cc|cpp|c\+\+|cp|cxx)$/$1/;

    exec("/usr/bin/g++ @ARGV -o $output -pedantic -Wall -Wextra -ansi");

This is similar to `gcc2` except that it's for g++ and the regex strips out a wider variety of extensions.  I called this file `gpp` and added the line to `.bash_login`:

    #!bash
    alias gpp="/Users/mhyee/gpp";

Once again, I can type `gpp source.cc` without worrying about the entire path or arguments.
