#!/usr/bin/perl
# What: tag stl documentation for use from gvim.
# How: wget http://www.sgi.com/tech/stl/STL_doc.zip; unzip stl_doc.zip
#      cd stl_doc; perl stl_tags.pl > tags
# In ~/.vimrc put this:
#   :set tags^=stl_doc/tags  
#   au BufReadPost */stl/*.html  :silent exe ":!c:/ opera/6*/opera.exe ".expand("%:p") | bd 
# Usage: vim file.cpp
#        :ta vector -> Opera will display stl_doc/vector.html
# AUTHOR: Mohsin Ahmed, http://www.cs.albany.edu/~mosh 

# make tags for html files listed stl_index.html
open(INDEX,"stl_index.html") or die "no stl_index.html?";
while(<INDEX>){ $files{$1}++ if m/href="(\w+?.html)"/; } close INDEX;

foreach $htmlf (keys %files){
    open(FILE,"$htmlf") or die "cannot read $htmlf";
    $lineno = $member=0;
    while(<FILE>){ $lineno++;
        s,&gt;,>,g; s,&lt;,<,g; s,&amp;,&,g; # html quadgraphs
        if( m,^<Title>([\w\s]+), ){ $tag = $1; # tag single word titles
            next if $tag_seen{$tag}++ || $tag =~ m/\s/;
            push @mytaglist,"$tag\t$htmlf\t/<Title>/;\" STL/Title\n";
            next;
        }
        $members++ if m/<h3>Members/i; # collect members in /Members/..eof()
        $members=0 if m,</table>,i;
        if( $members && m,^<tt>(.+?)</tt>, ){
                $tag=$1; 
                $tag = $1 if $tag =~ m/\b(\S+)\(/;  # purge proto
                next if $tag =~ /href=/;  # skip urls.
                $tag =~ s,^operator(\S+),$1,; # purge sugar
                my $file = $htmlf; $file =~ s,\..*,,;
                push @mytaglist,"$tag\t$htmlf\t$lineno;\" STL/Member\n"  # member
                        unless $seen{"$tag.$file"}++;
                $tag = "$file\::$tag";   # class::member
                push @mytaglist,"$tag\t$htmlf\t$lineno;\" STL/Class::Member\n" 
                    unless $tag_seen{$tag}++;
                    
        }
    }
    close FILE;
}
print sort @mytaglist;            
