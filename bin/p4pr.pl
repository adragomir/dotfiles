#!/usr/bin/perl

# $Id: p4pr.perl,v 1.1 2001/06/28 05:36:40 rick Exp $

# Interpolate change information into a source listing of a p4 file.
# Takes a file name or depot filename, with #<ref> or @<change>.
# Contributed by Bob Sidebotham.

# Simplify program name, if it is a path.
$0 =~ s#.*/##;

# Execute a command, keeping the output of the command in an array.
# Returns the array, unless an error occured, in which case the an
# exception is thrown (via die) with an appropriate message.
sub command {
    my($command) = @_;
    my(@results) = `$command`;
    if ($?) {
	my($err) = ($? >> 8);
	print STDERR @results;
	die qq($0: "$command" exited with status $err.\n);
    }
    @results
}

# Fatal usage error
sub usage {
    my($err) = @_;
    die
      "$0: $err\n" .
      "usage: $0 <file> | <file>#<rev> | <file>\@<change>\n" .
      " <file> may be a client file name or depot file name.\n";
}

# Default options
$showauthor = 1;
$showchange = 1;
$showrev = 1;

# Undocumented options
if (@ARGV && $ARGV[0] =~ /^-/) {
    $showchange = 0;
}

# Parse options
while (@ARGV && $ARGV[0] =~ /^-/) {
    $opt = shift;
    if ($opt eq '-r') {
	$showrev = 1; # Show revision numbers instead of changes.
    } elsif ($opt eq '-c') {
	$showchange = 1;
    } else {
	usage("invalid option $opt"); 
    }
}

# Get file argument.
usage("file name expected") if !@ARGV;
usage("invalid argument") if @ARGV > 1;
$file = shift;

# Handle # and @ notation (only for numeric changes and revisions).
$change = $1 if $file =~ s/@(\d+)//;
$head = $1 if $file =~ s/#(\d+)//;

# Check that the file specification maps to exactly one file.
@list = command qq(p4 files $file);
if (@list > 1) {
    die("$0: the specified file pattern maps to more than one file.\n");
}

# Check that the revision is not deleted.
if ($list[0] =~ /(.*#\d+) - delete change/) {
    die("$0: revision $1 is deleted.\n")
}

# Get the fullname of the file and the history, all from
# the filelog for the file.
($fullname, @history) = command qq(p4 filelog $file);
chop($fullname);
$fullname =~ s/#.*//;
@fullname = split(m#/#, $fullname);

# Extract the revision to change number mapping. Also
# get the author of each revision, and for merged
# or copied revisions, the "branch name", which we
# use instead of an author.
for (@history) {
    if (/^\.\.\. #(\d+) change (\d+) .*? by (.*?)@/) {
	# If a change number or revision is specified, then ignore
	# later revisions.
	next if $change && $change < $2;
	next if $head && $head < $1;
	$change{$1} = $2;
	$author{$1} = $3;
	$head = $1 if !$head;
	$thisrev = $1;
	$headseen = 1;
    } else {
	# If we see a branch from, then we know that
	# previous revisions did not contribute to the current
	# revision. Don't do this, however, if we haven't seen
	# the revision we've been requested to print, yet.
	# We used to do this for copy from, but I think
	# it's better not to.
	next unless $headseen;
	if (/^\.\.\. \.\.\. (copy|branch|merge) from (\/\/.*)#/) {
	    # If merged or copied from another part of the
	    # tree, then we use the first component of the
	    # name that is different, and call that the "branch"
	    # Further, we make the "author" be the name of the
	    # branch.
	    my($type) = $1;
	    my(@from) = split(m#/#, $2);
	    for ($i = 0; $i < @from; $i++) {
		if ($from[$i] ne $fullname[$i]) {
		    $author{$thisrev} = $from[$i] if $from[$i];
		    last;
		}
	    }

	    # If branched, we don't bother getting any more
	    # history. We treat this as starting with the branch.
	    last if $type eq 'branch';
	}
    }
}

# Get first revision, and list of remaining revisions
($base, @revs) = sort {$a <=> $b} keys %change;

# Get the contents of the base revision of the file,
# purely for the purposes of counting the lines.
@text = command qq(p4 print -q $file#$base);

# For each line in the file, set the change revision
# to be the base revision.
@lines = ($base) x @text;

# For each revision from the base to the selected revision
# "apply" the diffs by manipulating the array of revision
# numbers. If lines are added, we add a corresponding 
# set of entries with the revision number that added it.
# We ignore the actual revision text--that will be merged
# with the change information later.
for $rev (@revs) {
    my($r1) = $rev - 1;
    # Apply the diffs in reverse order to maintain correctness
    # of line numbers for each range as we apply it.
    for (reverse command qq(p4 diff2 $file\#$r1 $file\#$rev)) {
	my( $la, $lb, $op, $ra, $rb ) = /^(\d+),?(\d*)([acd])(\d+),?(\d*)/;
	next unless defined($ra);
	$lb = $la if ! $lb;
	++$la if $op eq 'a';
	$rb = $ra if ! $rb;
	++$ra if $op eq 'd';
	splice @lines, $la - 1, $lb - $la + 1, ($rev) x ($rb - $ra + 1);
    }
}
			
# Get the text of the selected revision. The number of lines
# resulting from applying the diffs should equal the number of
# of lines in this revision.
($header, @text) = command qq(p4 print $file#$head);
if (@text != @lines) {
    die("$0: internal error applying diffs - please contact the author\n")
}    

# Print a pretty header. Note that the interpolated information
# at the beginning of the line is a multiple of 8 bytes (currently 24)
# so that the default tabbing of 8 characters works correctly.
my($fmt) = "%5s %15s %6s %4s %s";
@fields = ("line", "author/branch", "change", "rev", $header);
printf($fmt, @fields);
printf("$fmt\n", map('-' x length($_), @fields));

# Interpolate the change author and number into the text.
my($line) = 1;
while (@text) {
    my($rev) = shift(@lines);
    printf($fmt, $line++, $author{$rev}, $change{$rev}, $rev, shift @text);
}

