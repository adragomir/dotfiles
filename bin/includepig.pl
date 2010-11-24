#!/usr/bin/perl

use strict;
use warnings;

# this is a perl script to find out which include files expand the most,
# and thereby slow down compiles the most.

my @include_dirs = (".");
my @include_files = ();
my @ignore_files = ();

# hash of references to hashes.  Values store information about a parsed
# include file.  The keys include:
#     LINES -- the number of lines in the file
#     TRANSITIVE_LINES -- the number of lines in the file plus all the files 
#                         it includes, recusively.
my %parsed_files;

# the keys of this hash form a set.  the values are ignored. 
my %couldnt_find_files = ();

sub main {
	parse_args();

	for my $file (@include_files) {
		parse_include_file_recursively($file);
	}

#	for my $filename (keys %parsed_files) {
#		calculate_transitive_lines($filename);
#		print_parsed_info($filename);
#	}

	print_parsed_info_as_dot_graph();
}

sub parse_args {
	my $next_is_include = 0;
	my $next_is_ignore = 0;
	for my $arg (@ARGV) {
		# -I means to add a directory to our search path
		if ($next_is_include) {
			$arg =~ s/[\/\\]$//;	# remove trailing slashes
			push @include_dirs, $arg;
			$next_is_include = 0;
		}
		elsif ($next_is_ignore) {
			push @ignore_files, $arg;
			$next_is_ignore = 0;
		}
		elsif ($arg eq "--ignore") {
			$next_is_ignore = 1;
		}
		elsif ($arg eq "-I") {
			$next_is_include = 1;
		}
		else {
			push @include_files, $arg;
		}
	}
}

sub parse_include_file_recursively {
	my ($file) = @_;
	return if exists $parsed_files{$file};

	my $found_file = find_include_file($file);
	if ($found_file) {
		my $info = parse_include_file($found_file);
		$parsed_files{$file} = $info;
		for my $includee (@{$info->{INCLUDEES}}) {
			parse_include_file_recursively($includee);
		}
	}
	else {
		if (!exists $couldnt_find_files{$file}) {
			print STDERR "Couldn't find file \"$file\"\n";
			$couldnt_find_files{$file} = 1;
		}
	}
}

sub parse_include_file {
	my ($file) = @_;

	open INCLUDE, "<$file";
	my $info = {
		LINES => 0,
		INCLUDEES => [],
	};
	for my $line (<INCLUDE>) {
		$info->{LINES} ++;
		if ($line =~ /^\s*#include ["<](.*)[>"]/) {
			push @{$info->{INCLUDEES}}, $1;
		}
	}
	close INCLUDE;

	return $info;
}

sub calculate_transitive_lines {
	my ($filename) = @_;
	my $info = $parsed_files{$filename};
	return unless $info;

	my $lines = $info->{LINES};
	# store transitive lines before recursing, in case we have include loops
	$info->{TRANSITIVE_LINES} = $lines; 
	for my $includee (@{$info->{INCLUDEES}}) {
		calculate_transitive_lines($includee);
		my $other_info = $parsed_files{$includee};
		if ($other_info) {
			$lines += $other_info->{TRANSITIVE_LINES};
		}
	}
	# store it again after recursing, now that it includes includee lines
	$info->{TRANSITIVE_LINES} = $lines; 
}

sub print_parsed_info {
	my ($filename) = @_;
	my $info = $parsed_files{$filename};
	return unless $info;
	my $lines = $info->{LINES};
	my $transitive_lines = $info->{TRANSITIVE_LINES};
	print "File $filename has $lines lines, $transitive_lines transitively\n";
}

sub sanitize_dot_node_name {
	my ($name) = @_;
	#$name =~ s/\..*//;
	$name =~ s/\W/_/g;
	if ($name eq "Node") {
		$name = "Node_";
	}
	return $name;
}

sub print_parsed_info_as_dot_graph {
	my ($filename) = @_;

	print "digraph callgraph {\n";

	for my $filename (keys %parsed_files) {
		my $info = $parsed_files{$filename};
		next unless $info;
		$filename = sanitize_dot_node_name($filename);
		for my $includee (@{$info->{INCLUDEES}}) {
			next unless $parsed_files{$includee};
			next if in_list($filename, @ignore_files);
			next if in_list($includee, @ignore_files);
			print $filename;
			print " -> ";
			print sanitize_dot_node_name($includee);
			print "\n";
		}
	}
	print "}\n";
}

sub find_include_file {
	my ($file) = @_;
	if (-r $file) { 
		return $file;
	}
	for my $dir (@include_dirs) {
		if (-r "$dir/$file") {
			return "$dir/$file";
		}
	}
	return undef;
}

sub in_list {
	my ($needle, @haystack) = @_;
	for my $straw (@haystack) {
		return 1 if ($needle eq $straw);
	}
	return 0;
}

main();

