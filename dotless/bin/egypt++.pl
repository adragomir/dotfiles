#!/usr/bin/perl -w

=head1 NAME

egypt - create call graph from gcc RTL dump

=head1 SYNOPISIS

 egypt [--omit function,function,...] <rtl-file>... | dotty -
 egypt [--omit function,function,...] <rtl-file>... | dot <dot-options>
    
=head1 DESCRIPTION

Egypt is a simple tool for creating call graphs of C programs.

=head1 OPTIONS

=over 8

=item omit

Omit the given functions from the call graph.  Multiple function names
may be given separated by commas.

=head1 HOW IT WORKS

Egypt neither analyzes source code nor lays out graphs.  Instead, it
leaves the source code analysis to GCC and the graph layout to
Graphviz, both of which better at their respective jobs than egypt
could ever hope to be itself.  Egypt is just a small Perl script that
acts as glue between these existing tools.

Egypt takes advantage of GCC's capability to dump an intermediate
representation of the program being compiled into a file (a I<RTL
file>); this file is much easier to extract information from than a
C source file.  Egypt extracts information about function calls and
functions taking the addresses of other functions from the RTL file,
and massages it into the format used by Graphviz.

=head1 GENERATING THE RTL FILE

Compile the program or source file you want to create a call graph for
with gcc, adding the option "-dr" to CFLAGS.  This option causes gcc
to dump its intermediate code representation of each file it compiles
into a .rtl file.

For example, the following works for many programs:

   make clean
   make CFLAGS=-dr

=head1 VIEWING THE CALL GRAPH

To view the call graph in an X11 window, run egypt with one or
more .rtl files as command line arguments and pipe its output to the
B<dotty> program from the Graphviz package.  For example, if you
compiled F<foo.c> with C<gcc -dr> to generate F<foo.c.rtl>, use

    egypt foo.c.rtl | dotty -

=head1 PRINTING THE CALL GRAPH

To generate a PostScript version of the call graph for printing, use
the B<dot> program from the Graphviz package.  For example, to generate
a callgraph in the file F<callgraph.ps> fitting everything on a US
letter size page in landscape mode, try

   egypt foo.c.rtl | dot -Grotate=90 -Gsize=8.5,11 -Tps -o callgraph.ps

For nontrivial programs, the graph may end up too small
to comfortably read.  If that happens, try N-up printing:

   egypt foo.c.rtl | dot -Gpage=8.5,11 -Tps -o callgraph.ps

You can also try playing with other B<dot> options such as
B<-Grankdir> and B<-Gratio>, or for a different style of graph, try
using B<neato> instead of B<dot>.  See the Graphwiz documentation for
more information about the various options available for
customizing the style of the graph.

=head1 READING THE CALL GRAPH

Function calls are displayed as solid arrows.  A dotted arrow means
that the function the arrow points from takes the address of the
function the arrow points to; this typically indicates that the latter
function is being used as a callback.

=head1 WHY IS IT CALLED EGYPT?

Egypt was going to be called B<rtlcg>, short for I<RTL Call Graph>,
but it turned out to be one of those rare cases where ROT13'ing the
name made it easier to remember and pronounce.

=head1 SEE ALSO

L<gcc>, L<dotty>, L<dot>, L<neato>

=head1 COPYRIGHT

Copyright 1994-2003 Andreas Gustafsson

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

Andreas Gustafsson

=cut

use strict;
use warnings;
use Getopt::Long;

use vars qw($VERSION);

$VERSION = "1.3";

# A data structure containing information about potential function
# calls.  This is a reference to a hash table where the key is a
# the name of a function (the caller) and the value is a reference
# to another hash table indexed by the name of a symbol referenced
# by the caller (the potential callee) and a value of "direct"
# (if the reference is a direct function call) or "indirect"
# (if the reference is a non-function-call symbol reference;
# if the referenced symbol itself turns out to be a function,
# this will be considered an indirect function call).

my $calls = { };

# The current function
my $curfunc;

# Functions to omit
my @omit = ();

# Mapping from symbol reference types to dot styles
my $styles = {
    direct => 'solid',
    indirect => 'dotted'
};

GetOptions('omit=s' => \@omit);
@omit = split(/,/, join(',', @omit));

sub demangle {
    my $mangled = shift;
    $mangled = `echo $mangled | c++filt`;
    $mangled =~ s/\(void\)/()/g;
    chomp($mangled);
    return $mangled;
}

sub strip_return_type {
    my $type = shift;
    $type =~ s/[\w\d\:\* ]* ([\w\d\:]*\()/$1/;
    return $type;
}

sub cpp_func_name_to_node_name {
    my $func = shift;
    $func =~ s/\(.*//g;
    $func =~ s/.* //g;
    $func =~ s/[^\w\d]/_/g;
    $func =~ s/_*$//g;
    return $func;
}

while (<>) {
    chop;
    if (/^;; Function (.*)$/) {
        $curfunc = cpp_func_name_to_node_name(strip_return_type($1));
    }
    if (/^.*\(call.*"(.*)".*$/) {
	my $callee = cpp_func_name_to_node_name(demangle($1));
	$calls->{$curfunc}->{$callee} = "direct";
    } elsif (/^.*\(symbol_ref.*"(.*)".*$/) {
	my $callee = cpp_func_name_to_node_name(demangle($1));
	$calls->{$curfunc}->{$callee} = "indirect";
    }
}

delete @$calls{@omit};

print "digraph callgraph {\n";

foreach my $caller (keys %{$calls}) {
    foreach my $callee (keys %{$calls->{$caller}}) {
	# If the referenced symbol is not a function, ignore it.
	next unless $caller && $callee && exists($calls->{$callee});
	my $reftype = $calls->{$caller}->{$callee};
	my $style = $styles->{$reftype};
	print "$caller -> $callee [style=$style];\n";
    }
}
print "\n}\n";
