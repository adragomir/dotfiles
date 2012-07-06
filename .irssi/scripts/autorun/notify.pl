##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl
##       /script load notify
##

use strict;
use Irssi;
use vars qw($VERSION %IRSSI);
use HTML::Entities;
use YAML;

$VERSION = "0.01";
%IRSSI = (
    authors     => 'Andrei Dragomir, Luke Macken, Paul W. Frields',
    contact     => 'adragomir@gmail.com, lewk@csh.rit.edu, stickster@gmail.com',
    name        => 'notify.pl',
    description => 'Use libnotify to alert user to hilighted messages',
    license     => 'GNU General Public License',
    url         => 'http://lewk.org/log/code/irssi-notify',
);

Irssi::settings_add_str('notify', 'notify_icon', 'gtk-dialog-info');
Irssi::settings_add_str('notify', 'notify_time', '5000');
my $configfile = "$ENV{HOME}/.irssi/notify.yaml";
my $config = {
    %{ YAML::LoadFile($configfile) || {} },
};
# Store most recently received data to prevent duplicate paging events
my ($lastnick, $lasttext, $laststicky);

sub sanitize {
  my ($text) = @_;
  encode_entities($text);
  return $text;
}

#
#__* supress duplicates
#
# Store the last several messages.  If we get a duplicate message,
# then avoid sending multiple pages.  Duplicates occur when a message
# matches more than one message, e.g. a public message in a monitored
# channel that contains a hilighted word.
sub supress_duplicates {
    my ($nick, $text, $sticky) = @_;

    Irssi::print( "Last seen: .$lastnick.:.$lasttext." );

    # already alerted for this one
    if (
        $lastnick &&
        $nick eq $lastnick &&
        $lasttext &&
        $text eq $lasttext
       ) {
        # Message was already alerted.  If this one is sticky and the
        # last one wasn't, then allow the alert to run again in sticky
        # mode.
        unless ($sticky && !$laststicky) {
            return 1;
        }
    }

    $lastnick = $nick;
    $lasttext = $text;
    $laststicky = $sticky;

    # no match
    return undef;
}

sub notify {
    my ($server, $summary, $message) = @_;

    # Make the message entity-safe
    $summary = sanitize($summary);
    $message = sanitize($message);

    my $cmd = "EXEC - notify-send" .
	" -i " . Irssi::settings_get_str('notify_icon') .
	" -t " . Irssi::settings_get_str('notify_time') .
	" -- '" . $summary . "'" .
	" '" . $message . "'";

    $server->command($cmd);
}
 
sub print_text_notify {
    return unless ($config->{"hilight.enable"});
  
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};
    my $channel = $dest->{target};

    #return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    #my $sender = $stripped;
    #$sender =~ s/^\<.([^\>]+)\>.+/\1/ ;
    #$stripped =~ s/^\<.[^\>]+\>.// ;
    #my $summary = $dest->{target} . ": " . $sender;
    if (($dest->{level} & (MSGLEVEL_HILIGHT|MSGLEVEL_MSGS)) &&
        ($dest->{level} & MSGLEVEL_NOHILIGHT) == 0) {

        # Pull nick and text from $stripped
        $stripped =~ m|^\<(.*?)\>\s+(.*)$|;
        my ($nick, $text) = ($1, $2);
        return undef unless ($nick && $text);

        unless (supress_duplicates($nick, $text, 0)) {
            my $summary = $channel . ": " + $nick;
            notify($server, $summary, $text);
        }
    }
}

sub message_public_notify {
    return unless ($config->{"public.enable"});
    my ($server, $msg, $nick, $address, $target) = @_;
    return unless ($nick && $msg && $server);

    # If growl is true for this channel
    my $channel = lc($target);
    if ($config->{"public.channels"}->{$channel}) {
        my $sticky;

        if ($config->{"public.channels"}->{$channel} eq "sticky") {
            $sticky = 1;
        }

        unless (supress_duplicates($nick, $msg, $sticky)) {
            notify($server, "Public message ".$nick, $msg);
        }
    }
}

sub message_private_notify {
    return unless ($config->{"private.enable"});
    my ($server, $msg, $nick, $address) = @_;

    return unless ( $nick && $msg && $server);
    unless (supress_duplicates($nick, $msg, 0)) {
        notify($server, "Private message from ".$nick, $msg);
    }
}

sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};

    return if (!$dcc);
    notify($server, "DCC ".$dcc->{type}." request", $dcc->{nick});
}

sub notify_plugin {
    my ($command, @args) = split('\s+', $_[0]);

    if ($command eq 'config') {
        my $param = shift @args;
        $param = "$param";

        unless (defined($config->{"$param"})) {
            Irssi::print( "ERROR: config param $param not defined" );
            return undef;
        }

        my $ref = ref $config->{$param};

        if ($ref eq "HASH") {
            my ($subparam, $value) = @args;

            if ($value eq 'delete') {
                Irssi::print("Deleting param $param->$subparam");
                delete $config->{$param}->{$subparam};
            } else {
                Irssi::print("Setting value for $param->$subparam to $value");
                $config->{$param}->{$subparam} = $value;
            }
        } else {
            my $value = shift @args;
            Irssi::print "Setting param $param to value $value";
            $config->{$param} = $value;
        }
    } elsif ($command eq 'dump') {
        my $dump = Data::Dumper->new( [ $config ] );
        Irssi::print( $dump->Dump );
    } elsif ($command eq 'save') {
        Irssi::print( "Saving config file" );
        YAML::DumpFile( $configfile, $config );
    } elsif ($command eq 'load') {
        Irssi::print( "Loading config file" );
        $config = {
                   %{ YAML::LoadFile( $configfile ) || {} },
                  };
    } else {
        Irssi::print("Usage: notify_plugin <command> <arguments>");

        Irssi::print("\nAvailable Commands:");
        Irssi::print("config  <param> <value>  set simple values");
        Irssi::print("dump    display the current config");
        Irssi::print("save    save the config to the config file");
        Irssi::print("load    load config stored in file.  loses changes made since last save.");

        Irssi::print("\nValid config params:");
        Irssi::print("    private.enable = enable alerts for private messages");
        Irssi::print("    private.sticky = sticky alerts for private messages");
        Irssi::print("    hilight.enable = enable alerts for hilighted text");
        Irssi::print("    hilight.sticky = sticky alerts for hilighted text");
        Irssi::print("    public.channels #channelname sticky|nosticky");

        Irssi::print("\nExamples:");
        Irssi::print("/notify_plugin dump");
        Irssi::print("/notify_plugin save");
        Irssi::print("/notify_plugin load");
        Irssi::print("/notify_plugin config private.enable 0");
        Irssi::print("/notify_plugin config hilight.enable 1");
        Irssi::print("/notify_plugin config hilight.sticky 1");
        Irssi::print("/notify_plugin config public.channels #mychan sticky");
        Irssi::print("              messages to #mychan are enabled sticky");
        Irssi::print("/notify_plugin config public.channels #mychan delete");
    }
}

Irssi::signal_add_last('print text', 'print_text_notify');
Irssi::signal_add_last('message public', 'message_public_notify');
Irssi::signal_add_last('message private', 'message_private_notify');
Irssi::signal_add_last('dcc request', 'dcc_request_notify');
Irssi::command_bind("notify_plugin", "notify_plugin");
