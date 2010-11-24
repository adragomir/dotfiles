#!/usr/bin/perl
#
# perfbrowse.perl -- CGI browser for PERFORCE
#
# $Id: //public/perforce/utils/perfbrowse/perfbrowse.perl#4 $
#
# Point P4PORT and P4CLIENT differently if you're not using the defaults.
# PATH is set to pick up the Perforce client program.
#
# Updated by Jeff Marshall at Paragon Software, Inc.
# (jam@paragon-software.com)
#
# Fixed for 99.1 by Rob Chandhok <chandhok@within.com>
#   - Anywhere the program was looking for "Date:", I made it also accept
#     headers like "Access:" and "Update:"
#
# Updated 11/18/99 by Alan Bird
#               Support for filenames/directories with spaces
#
# Please email me your improvements
#
# My changes:
#   - Added white background
#   - New browsing goodies -- like:
#     o clients
#     o users
#     o opened files, by client and user
#     o branches
#     o labels
#     o jobs
#     o files within a given client
#   - Footer on every page with a link to the "top browser page" and links
#     to the browsing functionality listed above
#   - Also put in hyperlinks anywhere a perforce user, client or mail address
#     is seen.
#
# Tested with p4d 98.2 on a solaris 2.6 sparc server.
#
# Note: I'm not a perl programmer...

#***************************************************************************
# Configuration Section
#***************************************************************************

# Set environment variables needed for Perforce

$ENV{'P4PORT'}   = "perforceserver:port";
$ENV{'P4CLIENT'} = "perforceclient";
$ENV{'P4USER'}   = "username";
$ENV{'P4PASSWD'} = "XXXXXXX";

# Boilerplate

$myname = $ENV{SCRIPT_NAME};

$BLUE = qq(<font color="#0000FF">);
$GREEN = qq(<font color="#00B000">);
$RED = qq(<font color="#B00000">);
$END = qq(</font>);

$ADD = $BLUE;
$ADDEND = $END;
$DEL = "<STRIKE>$RED";
$DELEND = "$END</STRIKE>";

$MAXCONTEXT = 30;
$NCONTEXT = 10;

@HTMLHEADER = (
	"Content-type: text/html\n",
	"\n",
	"<html>\n",
	"<head>\n" );

@HTMLBODY = (
        "</head>\n",
        "<body bgcolor=\"#ffffff\">\n" );

@HTMLERROR = (
	"Content-type: text/html\n",
	"\n",
	"<html>\n",
	"<head>\n",
	"<body bgcolor=\"#ffffff\">\n" );

@OTHER_FOOTERS = ();
#
# Switch on ARGV[0]
#

# handle isindex compatibility

unshift( @ARGV, "\@changes" ) if( @ARGV && @ARGV[0] !~ m!^@! );

################################
#
# No arguments. 
#
#	Put up the introductory screen.
#
################################

#if (!@ARGV) {
#    print @HTMLHEADER,
#	"<title>Perforce Browser</title>\n",
#	@HTMLBODY,
#	"<center><h1>Perforce Browser</h1>\n</center>",
#	"<i>This browser allows you to view information about your",
#    	" Perforce server.\n",
#	"The first step is to select what you want to view</i>\n",
#	"<hr>";
#
#    print "<li>", &url( "\@browse", "Browse Depots"), "\n";
#    print "<li>", &url( "\@users", "Browse Users"), "\n";
#    print "<li>", &url( "\@clients", "Browse Clients"), "\n";
#    print "<li>", &url( "\@jobs", "Browse Jobs"), "\n";
#}
if ( !@ARGV) {

    if ($ENV{CODELINES}) {
	open( P4, "$ENV{CODELINES}" ) || &bail( "No codelines file." );
	@CODELINES = <P4>;
    }
    else
    {
	# Default codelines data is just a simple list of everything.
	# If $CODELINES is set in the environment, the codelines comes
	# from that.  The format is:
	#
	#	description1
	#	//path1
	#	description2
	#	//path2

	@CODELINES = (
		      "Full Depot Source\n",
		      "//depot/...\n");
    }

    print 
	@HTMLHEADER,
	"<title>Perforce Change Browser</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce Change Browser</h1>\n</center>",
	"<i>This browser allows you to view the history of a Perforce depot.\n",
	"The first step is to select the files you want history for.</i>\n",
	"<isindex prompt=\"Click below or type a file pattern here: \">\n";

    foreach ( @CODELINES )
    {
	chop;

	if( m:^/: )
	{
	    print "<li>", &url( "\@changes+$_", $_ ), "\n";
	}
	elsif( !/^\s*$/ )
	{
	    print "</blockquote><p><h3>$_</h3><blockquote>\n";
	}
    }
}
elsif ( @ARGV[0] eq "\@users" ) {
    &p4open( 'P4', "users|" );

    print @HTMLHEADER,
	"<title>Perforce Users</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce Users</h1>\n</center>",
	"<i>This browser allows you to view information about ",
	" Perforce users.\n",
	"The first step is to select which user you want to view</i>\n",
	"<hr>";

    print
	"<table cellpadding=1>",
	"<tr align=left><th>User<th>Email<th>Full Name",
	"<th>Last Accessed</tr>\n";

    # Sample:
    # jam <jam@bar.com> (Jeffrey A. Marshall) accessed 1998/07/03

    while( <P4> ) {
#	print "<tr><td>$_</tr>\n";
	if (local( $user, $email, $fullname, $accessed ) = 
	    /(\S+) <(\S+)> \((.*)\) accessed (\S+)/)
	{
	    print "<tr>",
	    	  "<td>", &url ( "\@user+$user", "$user"),
		  "<td>", &mailto ( "$email" ),
	    	  "<td>", "$fullname",
		  "<td>", "$accessed",
	       	  "</tr>\n";
	}
    }
    print "</table>\n";
    close P4;
} elsif ( @ARGV[0] eq "\@user" ) {
    local( $user, $email, $access, $fullname, $jobview );
    $user = $ARGV[1];
    &p4open ('P4', "user -o $user|");

    while (<P4>)
    {
	next if (/^User:/);
	next if (/^Email:/ && (( $email ) = /^Email:\s*(.*)$/ ));
	next if (/^Access:/ && (( $access ) = /^Access:\s*(.*)$/ ));
	next if (/^FullName:/ && (( $fullname ) = /^FullName:\s*(.*)$/ ));
	next if (/^JobView:/ && (( $jobview ) = /^JobView:\s*(.*)$/ ));
	last if (/^Reviews:/);
    }

    print @HTMLHEADER,
	"<title>Perforce User Information for $user</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce User Information for $user</h1>\n</center>",
	"<i>This browser allows you to view information about ",
	" a given Perforce user.</i>\n<hr>",
	"<h3>Full Name</h3><pre>        $fullname</pre>\n",
	"<h3>Email</h3><pre>        ", &mailto ("$email"), "</pre>\n",
	"<h3>Last Access</h3><pre>        $access</pre>\n",
	"<h3>JobView</h3><pre>        $jobview</pre>\n",
	"<h3>Reviews</h3>\n<pre>";

    while (<P4>)
	{
	   print;
	}
    print "</pre>\n";
    close P4;
    @OTHER_FOOTERS = (" | ",
		      , &url ("\@opened+user+$user",
			      "Files Opened by $user"));
} elsif ( @ARGV[0] eq "\@clients" ) {
    &p4open( 'P4', "clients|" );

    print @HTMLHEADER,
	"<title>Perforce Clients</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce Clients</h1>\n</center>",
	"<i>This browser allows you to view information about ",
	" Perforce clients.\n",
	"The first step is to select which client you want to view</i>\n",
	"<hr>";

    print
	"<table cellpadding=1>",
	"<tr align=left><th>Client<th>Date<th>Root Directory",
	"<th>Description</tr>\n";

    # Sample:
    # Client oak.template 1998/06/25 root /tmp 'OAK client template '

    while( <P4> ) {
	if (local( $client, $date, $root, $descrip ) = 
	    /Client (\S+) (\S+) root (\S+) '(.*)'/)
	{
	    print "<tr>",
	    	  "<td>", &url ( "\@client+$client", "$client"),
		  "<td>$date",
		  "<td>$root",
		  "<td>$descrip",
	       	  "</tr>\n"
	}
    }
    print "</table>\n";
    close P4;
} elsif ( @ARGV[0] eq "\@client" ) {
    local( $client, $date, $owner, $root, $opts );
    $client = $ARGV[1];
    &p4open ('P4', "client -o $client|");

    while (<P4>)
    {
	next if (/^Client:/);
	next if (/^Date:/ && (( $date ) = /^Date:\s*(.*)$/ ));
	next if (/^Access:/ && (( $date ) = /^Access:\s*(.*)$/ ));
	next if (/^Owner:/ && (( $owner ) = /^Owner:\s*(\S+)$/ ));
	last if (/^Description:/);
    }

    print @HTMLHEADER,
    	"<title>Perforce Client Information for $client</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce Client Information for $client</h1>\n</center>",
	"<i>This browser allows you to view information about ",
    	" a given Perforce client.</i>\n<hr>";

    if ("$date" eq "") {
	print "<h3>Client <i>$client</i> doesn't exist</h3>";
    }
    else
    {
	print "<h3>Date</h3><pre>        $date</pre>\n",
	      "<h3>User</h3><pre>        ",
	      &url ("\@user+$owner", "$owner"), "</pre>\n",
	      "<h3>Description</h3><pre>\n";

	while (<P4>)
	{
	   next if (/^$/);
	   last if (/^Root:/ && (( $root ) = /^Root:\s*(.*)$/ ));
	   print;
	}
	while (<P4>)
	{
	   next if (/^Options:/ && (( $opts ) = /^Options:\s*(.*)$/ ));
	   last if (/^View:/);
        }
	print "</pre><h3>Root Directory</h3><pre>        $root</pre>\n",
    	  "<h3>Options</h3><pre>        $opts</pre>\n",
	  "<h3>View</h3><pre>";
	while (<P4>)
	{
	    last if (/^$/);
	    print;
	}
	print "</pre>";
    }
    close P4;
    @OTHER_FOOTERS = (" | ", &url ("\@files+\@$client", "Files in $client"),
		      " | ", &url ("\@opened+client+$client", "Files Opened in $client"));
} elsif ( @ARGV[0] eq "\@jobs" ) {
    &p4open( 'P4', "jobs|" );

    print @HTMLHEADER,
	"<title>Perforce Jobs</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce Jobs</h1>\n</center>",
	"<i>This browser allows you to view information about ",
    	" Perforce Jobs.\n",
	"The first step is to select which job you want to view</i>\n",
	"<hr>";

    print
	"<table cellpadding=1>",
	"<tr align=left><th>Job Name<th>Date<th>User",
	"<th>Status<th>Description</tr>\n";

    # Sample:
    # job000011 on 1998/07/03 by jam *open* 'Another test. '

    while( <P4> ) {
	if (local( $name, $date, $user, $status, $descrip ) = 
	    /^(\S+) on (\S+) by (\S+) \*(\S+)\* '(.*) '$/)
	{
	    print "<tr>",
	    	  "<td>", &url ( "\@job+$name", "$name"),
		  "<td>$date",
	    	  "<td>", &url ( "\@user+$user", "$user"),
		  "<td>$status",
		  "<td>$descrip",
	       	  "</tr>\n";
	}
    }
    print "</table>\n";
    close P4;
} elsif ( @ARGV[0] eq "\@branches" || @ARGV[0] eq "\@labels" ) {
    local ($type, $cmd, $viewer);

    if (@ARGV[0] eq "\@branches")
      {
	$type = "Branch";
	$cmd = "branches";
	$viewer = "branch";
      }
    else
      {
	$type = "Label";
	$cmd = "labels";
	$viewer = "label";
      }
    &p4open( 'P4', "$cmd|" );

    print @HTMLHEADER,
	"<title>Perforce ${type}es</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce ${type}es</h1>\n</center>",
	"<i>This browser allows you to view information about ",
    	" Perforce ${type}es.\n",
	"The first step is to select which $viewer you want to view</i>\n",
	"<hr>",
	"<table cellpadding=1>",
	"<tr align=left><th>$type Name<th>Date<th>Description</tr>\n";

    # Sample:
    # Branch test 1998/07/03 'Created by jam. '
    # Label example-label.template 1998/06/26 'Label tempalte for the example '

    while( <P4> ) {
	if (local( $name, $date, $descrip ) = 
	    /^$type (\S+) (\S+) '(.*) '$/)
	{
	    print "<tr>",
	    	  "<td>", &url ( "\@$viewer+$name", "$name"),
		  "<td>$date",
	    	  "<td>$descrip",
	       	  "</tr>\n";
	}
    }
    print "</table>\n";
    close P4;
} elsif ( @ARGV[0] eq "\@branch" || @ARGV[0] eq "\@label") {
    local( $type, $cmd, $name, $date, $owner, $opts, $filespec );

    $name = $ARGV[1];

    if (@ARGV[0] eq "\@branch")
      {
        $type = "Branch";
        $cmd = "branch";
	$filespec = "//$name/...";
      }
    else
      {
        $type = "Label";
	$cmd = "label";
	$filespec = "+\@$name";
      }

    &p4open ('P4', "$cmd -o $name|");

    while (<P4>)
    {
	next if (/^$type:/);
	next if (/^Date:/ && (( $date ) = /^Date:\s*(.*)$/ ));
	next if (/^Access:/ && (( $date ) = /^Access:\s*(.*)$/ ));
	next if (/^Update:/ && (( $date ) = /^Update:\s*(.*)$/ ));
	next if (/^Owner:/ && (( $owner ) = /^Owner:\s*(\S+)$/ ));
	last if (/^Description:/);
    }

    print @HTMLHEADER,
    	"<title>Perforce $type Information for $name</title>\n",
	@HTMLBODY,
	"<center><h1>Perforce $type Information for $name</h1>\n</center>",
	"<i>This browser allows you to view information about ",
    	" a given Perforce $cmd.</i>\n<hr>";

    if ("$date" eq "") {
	print "<h3>$type <i>$name</i> doesn't exist</h3>";
    }
    else
    {
	print "<h3>Date</h3><pre>        $date</pre>\n",
	      "<h3>User</h3><pre>        ",
	      &url ("\@user+$owner", "$owner"), "</pre>\n",
	      "<h3>Description</h3><pre>\n";

	while (<P4>)
	{
	   next if (/^$/);
	   last if (/^View:/);
	   last if (/^Options:/ && (( $opts ) = /^Options:\s*(.*)$/ ));
	   print;
	}

	print "</pre>";

	if ("$opts" ne "")
	  {
	    print "<h3>Options</h3><pre>        $opts</pre>\n";
	    while (<P4>)
 	     {
	       last if (/^View:/);
	     }
	  }
	print "<h3>View</h3><pre>";
	$filespec = "" if ("$cmd" eq "branch");
	while (<P4>)
	{
	    last if (/^$/);
	    if ("$cmd" eq "branch")
	      {
	        local ($spec) = /^\s*\S+ (\S+)$/;
		$filespec = "$filespec+$spec";
	      }
	    print;
	}
	print "</pre>";
    }
    close P4;

    @OTHER_FOOTERS = (" | ", &url ("\@files$filespec", "Files in this $type"));
}
################################
#
# changes [ path ]
#
#	show changes for path
#
################################

elsif( $ARGV[0] eq "\@changes" ) {

    &p4open( 'P4', "changes -l $ARGV[1]|" );

    print 
	@HTMLHEADER,
	"<title>Changes for $ARGV[1]</title>\n",
	@HTMLBODY,
	"<center><h1>Changes for $ARGV[1]</h1></center>\n",
	"<i>This form displays the changes for the files you've selected.\n",
	"Click on the change number to see details of a change.  Changes\n",
	"are listed in reverse chronological order, so you see what's\n",
	"most recent first.</i>\n",
	"<hr><dl>\n";

    while (<P4>) {

        s/&/&amp;/g;
        s/\"/&quot;/g;
        s/</&lt;/g;
        s/>/&gt;/g;

	if( local( $change, $on, $user, $client ) = /^Change (\d+) on (\S+) by (\S+)@(\S+)$/ ) 
	{
	    print 
		"<dt>", &url( "\@describe+$change", "Change $change" ),
		" on $on by ", &url ("\@user+$user", "$user"),
		"\@", &url ("\@client+$client", "$client"), "<dd>\n";
	} 
	else 
	{
	    chop;
	    print "<tt>$_</tt><br>\n";
	}
    }

    print "</dl>\n";

    close P4;
}

################################
#
# describe change
#
#	describe a change
#
################################

elsif( $ARGV[0] eq "\@describe" ) {

    &p4open( 'P4', "describe -s $ARGV[1]|" );

    $_ = <P4>;

    ( local($chn, $user, $client, $date, $time) = 
	/^Change (\d+) by (\S*)@(\S*) on (\S*) (\S*)$/ )
	|| &bail( $_ );

    print 
	@HTMLHEADER,
	"<title>Change $chn</title>\n",
	@HTMLBODY,
	"<center><h1>Change $chn</h1></center>\n",
	"<i>This form displays the details of a change.  For each of the\n",
	"files affected, you can click on:\n",
	"<ul>\n",
	"<li>Filename -- to see the complete file history\n",
	"<li>Revision Number -- to see the file text\n",
	"<li>Action -- to see the deltas (diffs)\n",
	"</ul></i>",
	"<hr><pre>\n",
	"<strong>Author        </strong>", &url ("\@user+$user", "$user"), "\n",
	"<strong>Client        </strong>", &url ("\@client+$client", "$client"), "\n",
	"<strong>Date          </strong>$time $date\n",
	"</pre><hr>\n",
	"<h2>Description</h2>\n",
	"<pre>\n";

    while(<P4>) {
	next if /^\s*$/;
	last if /^Jobs fixed/;
	last if /^Affected files/;
	print $_;
    }

    print
	"</pre>",
	"<hr>\n";

    # display jobs

    if( /^Jobs fixed/ )
    {
	print 
	    "<h2>Jobs Fixed</h2>\n",
	    "<ul>\n";

	while ( <P4> ) {
	    local( $job, $time, $user, $client );

	    while( ( $job, $time, $user, $client ) = 
		/(\S*) fixed on (\S*) by (\S*)@(\S*)/ )
	    {
		print
		    "<li><h3>",
		    &url( "\@job+$job", $job ),
		    "</h3><pre>\n";

		while(<P4>) {
		    last if /^\S/;
		    print $_;
		}

	    }

	    print "</pre>\n";

	    last if /^Affected files/;
	}

	print 
	    "</dl>",
	    "<hr>\n";
    }

    print
	"<h2>Files</h2>\n",
	"<ul>\n",
	"<table cellpadding=1>",
	"<tr align=left><th>File<th>Rev<th>Action</tr>\n";

    # Sample:
    # ... //depot/main/p4/Jamrules#71 edit

    while(<P4>) {

        # (alb) I changed the following match expression 7/30/99
        # It was /^\.\.\. (\S*)#(\d*) (\S*)$/
        # it wouldn't match filenames with spaces
        if( local( $file, $rev, $act ) = /^\.\.\. (.*)#(\d*) (\S*)$/ )
        {
                $fileurl = $file;
                $fileurl =~ s/ /%20/;
            print
                "<tr>",
                "<td>", &url( "\@filelog+$fileurl", "$file" ),
                "<td>", &url( "\@print+$fileurl+$rev", "$rev" ),
                "<td>", &url( "\@diff+$fileurl+$rev+$act", "$act" ),
		"</tr>\n";
	    }
    }
    print
	"</table></ul>\n";

    close P4;
}

################################
#
# filelog file 
#
#	show filelog of the file
#
################################

elsif ($ARGV[0] eq "\@filelog") {

    local( $name ) = $ARGV[1];

    &p4open( 'P4', "filelog \"$name\"|" );

    $name = <P4>;
    chop $name;

    print 
	@HTMLHEADER,
	"<title>Filelog $name</title>\n",
	@HTMLBODY,
	"<center><h1>Filelog $name</h1></center>\n",
	"<i>This form shows the history of an individual file across\n",
	"changes.  You can click on the following:\n",
	"<ul>\n",
	"<li>Revision Number -- to see the file text\n",
	"<li>Action -- to see the deltas (diffs)\n",
	"<li>Change -- to see the complete change description, including\n",
	"other files.\n",
	"</ul></i>",
	"<hr>\n";

    print
        &dop4pr($name,"Click here for line by line annotation of who changed each line of this file and when (can take a few minutes)"),
        "<BR><B>WARNING: THIS TAKES A LOT OF CPU, DON'T JUST CLICK FOR GIGGLES!</B>",
        "<hr>\n";

    print
	"<table cellpadding=1>",
	"<tr align=left><th>Rev<th>Action<th>Date",
	"<th>User\@client<th>Change<th>Desc</tr>\n";

    # Sample:
    # ... #78 change 1477 edit on 04/18/1996 by user@client 'Fix NT mkdi'

    while( <P4> ) {
	if (local( $rev, $change, $act, $date, $user, $client, $edit_type, $desc ) =
	    /^\.\.\. \#(\d+) \S+ (\d+) (\S+) on (\S+) by (\S*)@(\S*) \((\S+)\) '(.*)'/)
	{
	    if ($act eq 'branch') {
		$_ = <P4>;
		my ($fromname,$fromrev) = /^.*branch from (\S+?)\#(\d+).*/;
		print
		    "<tr>",
		    "<td>", &url( "\@print+$name+$rev", "$rev" ),
		    "<td>", &url( "\@filelog+$fromname+$fromrev", $act ),
		    "<td>$date",
		    "<td>", &url ("\@user+$user", "$user"), "\@",
		    	    &url ("\@client+$client", "$client"),
		    "<td>", &url( "\@describe+$change", "$change" ),
		    "<td><tt>$desc</tt>",
		    "</tr>\n";
	    }
	    elsif ($act eq 'delete') {
		print
		    "<tr>",
		    "<td>", &url( "\@print+$name+$rev", "$rev" ),
		    "<td>$DEL$act$DELEND",
		    "<td>$date",
		    "<td>", &url ("\@user+$user", "$user"), "\@",
		    	    &url ("\@client+$client", "$client"),
		    "<td>", &url( "\@describe+$change", "$change" ),
		    "<td><tt>$desc</tt>",
		    "</tr>\n";
	    }
	    else {
		print
		    "<tr>",
		    "<td>", &url( "\@print+$name+$rev", "$rev" ),
		    "<td>", &url( "\@diff+$name+$rev+$act", $act ),
		    "<td>$date",
		    "<td>", &url ("\@user+$user", "$user"), "\@",
		    	    &url ("\@client+$client", "$client"),
		    "<td>", &url( "\@describe+$change", "$change" ),
		    "<td><tt>$desc</tt>",
		    "</tr>\n";
	    }
	}
    }

    print "</table>\n";

    close P4;
}
elsif ($ARGV[0] eq "\@files") {
    &p4open( 'P4', "files @ARGV[1..$#ARGV]|" );
    print 
	@HTMLHEADER,
	"<title>Files for $ARGV[1..$#ARGV]</title>\n",
        @HTMLBODY,
	"<center><h1>Files for @ARGV[1..$#ARGV]</h1></center>\n",
	"<i>This form displays files in the depot for a given revision.\n",
	"For each of the files, you can click on:\n",
	"<ul>\n",
	"<li>Filename -- to see the complete file history\n",
	"<li>Revision Number -- to see the file text\n",
	"<li>Action -- to see the deltas (diffs)\n",
	"<li>Change -- to see the complete change description, including\n",
	"other files.\n",
	"</ul></i>",
	"<hr>\n";

    print
	"<h3>Files</h3>\n",
	"<ul>\n",
	"<table cellpadding=1>",
	"<tr align=left><th>File<th>Rev<th>Action<th>Change</tr>\n";

    # Sample:
    # //example/find/TypeExpr.java#1 - add change 5 (ktext)

    while(<P4>) {
	if( local( $file, $rev, $act, $change, $type ) =
	    /^(\S+)#(\d*) - (\S+) change (\d*) \((\S+)\)$/ )
	{
	    print 
		"<tr>",
		"<td>", &url( "\@filelog+$file", "$file" ),
		"<td>", &url( "\@print+$file+$rev", "$rev" ),
		"<td>", &url( "\@diff+$file+$rev+$act", "$act" ),
		"<td>", &url( "\@describe+$change", "$change" ),
#		"<td>", "$type",
		"</tr>\n";
	}
    }
    print
	"</table></ul>\n";

    close P4;
}
elsif ($ARGV[0] eq "\@opened") {
    &p4open( 'P4', "opened -a|" );

    print 
	@HTMLHEADER,
	"<title>Opened files for @ARGV[1..$#ARGV]</title>\n",
	@HTMLBODY,
	"<center><h1>Opened files for @ARGV[1..$#ARGV]</h1></center>\n",
	"<i>This form displays files opened by the specified @ARGV[1].\n",
	"For each of the files, you can click on:\n",
	"<ul>\n",
	"<li>Filename -- to see the complete file history\n",
	"<li>Revision Number -- to see the file text\n",
	"<li>User -- to see the a user description\n",
	"<li>Client -- to see the a client description\n",
	"</ul></i>",
	"<hr>\n";

    print
	"<h3>Files</h3>\n",
	"<ul>\n",
	"<table cellpadding=1>",
	"<tr align=left><th>File<th>Rev<th>Action<th>Change List",
	"<th>Type<th>User\@Client</tr>\n";

    # Sample:
    # //foo/file.java#2 - edit default change (text) by user@client

    while(<P4>) {
	if (local( $file, $rev, $act, $change, $type, $user, $client ) =
	     /^(\S+)#(\d*) - (\S+) (\S+) change \((\S+)\) by (\S+)@(\S+)$/)
	  {
	    next if ((@ARGV[1] eq "user" ? $user : $client) ne @ARGV[2]);
	    print 
		"<tr>",
		"<td>", &url( "\@filelog+$file", "$file" ),
		"<td>", &url( "\@print+$file+$rev", "$rev" ),
		"<td>$act<td>$change<td>$type",
		"<td>", &url( "\@user+$user", "$user" ), "\@",
		&url( "\@client+$client", "$client" ),
		"</tr>\n";
	}
    }
    print
	"</table></ul>\n";

    close P4;
}
################################
#
# print file rev action
#
#	print file text
#
################################

elsif ($ARGV[0] eq "\@print") {

    local($name, $rev) = @ARGV[1..2];

    &p4open( 'P4', "print \"$name\"#$rev|" );

    # Get header line
    # //depot/main/jam/Jamfile#39 - edit change 1749 (text)

    $_ = <P4>;
    local( $name, $rev, $type ) = m!^(\S+)\#(\d+) - \S+ \S+ \S+ \((\w+)\)!;

    print 
	@HTMLHEADER,
	"<title>File $name</title>\n",
	@HTMLBODY,
	"<center><h1>File $name#$rev</h1></center>\n",
	"<i>This form shows you the raw contents of a file, as long as \n",
	"it isn't binary.</i>",
	"<hr>\n";

    if( $type eq "binary" || $type eq "xbinary" )
    {
	print "<h2>$type</h2>\n";
    }
    else
    {
	print "<pre>\n";

	while( <P4> ) {
	    s/&/&amp;/g;
	    s/\"/&quot;/g;
	    s/</&lt;/g;
	    s/>/&gt;/g;
	    print $_;
	}

	print "</pre>\n";
    }

    close P4;
}

################################
#
# diff file rev action
#
#	describe a change
#
################################

elsif ($ARGV[0] eq "\@diff") {

    local( $name, $rev, $mode ) = @ARGV[1..3];
    local( $nchunk ) = 0;

    print
	@HTMLHEADER,
	"<title>$name#$rev</title>\n",
	@HTMLBODY,
	"<center><h1>$name#$rev - $mode</h1></center>\n",
	"<i>This form shows you the deltas (diffs) that lead from the\n",
	"previous to the current revision.</i>\n",
	"<hr>\n";

    if ($mode ne 'add' && $mode ne 'delete' && $mode ne 'branch') {

	local($f1) = "$name#" . ($rev - 1);
	local($f2) = "$name#" . ($rev);

        &p4open('P4', "diff2 \"$f1\" \"$f2\"|");
        $_ = <P4>;

        while (<P4>) {


	    local( $dels, $adds );

	    local( $la, $lb, $op, $ra, $rb ) = 
		/(\d+),?(\d*)([acd])(\d+),?(\d*)/;

	    next unless $ra;

	    if( !$lb ) { $lb = $op ne 'a' ? $la : $la - 1; }
	    if( !$rb ) { $rb = $op ne 'd' ? $ra : $ra - 1; }

	    $start[ $nchunk ] = $op ne 'd' ? $ra : $ra + 1;
	    $dels[ $nchunk ] = $dels = $lb - $la + 1;
	    $adds[ $nchunk ] = $adds = $rb - $ra + 1;
	    @lines[ $nchunk ] = ();

	    # deletes

	    while( $dels-- ) {
	    	$_ = <P4>; 	
		s/^. //;
		if (/[&<>]/) {
		    s/&/\&amp;/g;
		    s/</\&lt;/g;
		    s/>/\&gt;/g;
		}
		@lines[ $nchunk ] .= $_;
	    }
	    
	    # separator

	    if ($op eq 'c') {	
		$_ = <P4>; 
	    }

	    # adds

	    while( $adds-- ) {
		$_ = <P4>;
	    }

	    $nchunk++;
	}

	close P4;
    }
   
    # Now walk through the diff chunks, reading the current rev and
    # displaying it as necessary.

    print 
    	"<center><pre>",
    	"$ADD added lines $ADDEND\n",
	"$DEL deleted lines $DELEND\n",
	"</pre></center><hr><pre>\n";

    local( $curlin ) = 1;

    &p4open('P4', "print -q \"$name\"#$rev|");

    for( $n = 0; $n < $nchunk; $n++ )
    {
	# print up to this chunk.

	&catchup( 'P4', $start[ $n ] - $curlin );

	# display deleted lines -- we saved these from the diff

	if( $dels[ $n ] )
	{
		print "$DEL";
		print @lines[ $n ];
		print "$DELEND";
	}

	# display added lines -- these are in the file stream.

	if( $adds[ $n ] )
	{
		print "$ADD";
		&display( 'P4', $adds[ $n ] );
		print "$ADDEND";
	}

	$curlin = $start[ $n ] + $adds[ $n ];
    }

    &catchup( 'P4', 999999999 );

    close P4;
} 

################################
#
# job job
#
#	describe a job
#
################################

elsif ($ARGV[0] eq "\@job") {

    local( $user, $job, $status, $time, $date );

    &p4open( 'P4', "job -o $ARGV[1]|" );

    while( <P4> )
    {
	next if ( /^Job/ && ( ( $job ) = /^Job:\s(\S*)/ ) );
	next if ( /^User/ && ( ( $user ) = /^User:\s*(\S*)/ ) );
	next if ( /^Status/ && ( ( $status ) = /^Status:\s*(\S*)/ ) );
	next if ( /^Date/ && ( ( $date, $time ) = /^Date:\s*(\S*) (\S*)/ ) );
	next if ( /^Access/ && ( ( $date, $time ) = /^Access:\s*(\S*) (\S*)/ ) );
	last if ( /^Description/ );
    }

    print 
	@HTMLHEADER,
	"<title>Job $job</title>\n",
	@HTMLBODY,
	"<center><h1>Job $job</h1></center>\n",
	"<i>This form displays the details of a job.  You can click on a\n",
	"change number to see its description.\n",
	"</i>",
	"<hr><pre>\n",
        "<strong>User          </strong>", &url ("\@user+$user", "$user"), "\n",
	"<strong>Status        </strong>$status\n",
	"<strong>Date          </strong>$time $date\n",
	"</pre><hr>\n",
	"<h2>Description</h2>\n",
	"<pre>\n";

    while(<P4>) {
	print $_;
    }

    print
	"</pre>",
	"<hr>\n";

    close P4;

    # display fixes

    &p4open( 'P4', "fixes -j $ARGV[1]|" );

    $count = 0;

    while( <P4> )
    {
	print
	    "<h2>Fixes</h2>\n",
	    "<ul>\n",
	    "<table cellpadding=1>",
	    "<tr align=left><th>Change<th>Date<th>User\@Client</tr>\n"
		if( !$count++ );

	# jobx fixed by change N on 1997/04/25 by user@host

	if( local( $change, $date, $user, $client ) 
		= /^\S* fixed by change (\S*) on (\S*) by (\S*)@(\S*)/ ) 
	{
	    print 
		"<tr>",
		"<td>", &url( "\@describe+$change", "$change" ),
		"<td>", $date,
		"<td>", &url ("\@user+$user", "$user"), "\@",
			&url ("\@client+$client", "$client"),
		"</tr>\n";
	}
    }

    print "</table></ul>\n"
	if( $count );

    close P4;
}

################################
#
# None of the above.
#
################################

else {
	&bail( "Invalid invocation @ARGV" );
}

# Trailer

@HTMLFOOTER = (
	"<p align=\"center\">*&nbsp; *&nbsp; *<br>",
	&url ("", "Top"), " | ",
	&url ("\@clients", "Clients"), " | ",
	&url ("\@users", "Users"), " | ",
	&url ("\@branches", "Branches"), " | ",
	&url ("\@labels", "Labels"), " | ",
	&url ("\@jobs", "Jobs"),
	@OTHER_FOOTERS,
	"</center></body>\n");

print   @HTMLFOOTER;

##################################################################
##################################################################
#
# Subroutines.
#
##################################################################
##################################################################

sub url {
	local( $url, $name ) = @_;
	return qq(<a HREF="$myname?$url">$name</a>) ;
}

sub dop4pr {
        local( $url, $name ) = @_;
        return qq(<a HREF="dop4pr.cgi?$url">$name</a>) ;
}

sub mailto {
#	local( $uname ) = @_;
	return qq(<a HREF="mailto:@_">@_</a>) ;
}

sub bail {
	print @HTMLERROR, @_, "\n";
	die @_;
}

sub p4open {
	local( $handle, @command ) = @_;
	open( $handle, "p4 @command" ) || &bail( "p4 @command failed" );
}

# Support for processing diff chunks.
#
# skip: skip lines in source file
# display: display lines in source file, handling funny chars 
# catchup: display & skip as necessary
#

sub skip {
	local( $handle, $to ) = @_;

	while( $to > 0 && ( $_ = <$handle> ) ) {
	    $to--;
	}

	return $to;
}

sub display {
	local( $handle, $to ) = @_;

	while( $to-- > 0 && ( $_ = <$handle> ) ) {

	    if (/[&<>]/) 
	    {
		s/&/\&amp;/g;
		s/</\&lt;/g;
		s/>/\&gt;/g;
	    }
	    print $_;
	}
}

sub catchup {

	local( $handle, $to ) = @_;

	if( $to > $MAXCONTEXT )
	{
	    local( $skipped ) = $to - $NCONTEXT * 2;

	    &display( $handle, $NCONTEXT );
	    
	    $skipped -= &skip( $handle, $skipped );

	    print 
		"<hr><center><strong>",
		"$skipped lines skipped",
		"</strong></center><hr>\n" if( $skipped );

	    &display( $handle, $NCONTEXT );
	}
	else
	{
	    &display;
	}
}

