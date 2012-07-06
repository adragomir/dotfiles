#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use strict;

use Irssi;

our $VERSION = '0.1';
our %IRSSI   = (
    authors     => 'Michael Greb',
    contact     => 'michael@thegrebs.com mikegrb @ irc.(perl|oftc).net',
    name        => 'local-growl',
    description => 'Sends out Growl notifications',
    license     => 'BSD',
);

my $GROWL_COMMAND = "/usr/local/bin/growlnotify";

sub on_message_private {
    my ( $server_rec_ref, $msg, $nick, $address ) = @_;
    return unless Irssi::settings_get_bool('growl_show_private_messages');
    send_growl( "$nick sent a private message", $msg, 'Private message' );
}

sub on_print_text {
    my ( $text_dest_rec_ref, $text, $stripped ) = @_;

    return
        unless Irssi::settings_get_bool('growl_show_hilights')
            && ( $text_dest_rec_ref->{'level'} & MSGLEVEL_HILIGHT );

    my $title = 'Highlight in ' . $text_dest_rec_ref->{'target'};
    send_growl( $title, $stripped, 'Hilight' );
}

## based on Growl::Tiny::notify 0.0.3 by Alex White (wu)
## Copyright (c) 2009, VVu@geekfarm.org All rights reserved.

sub send_growl {
    return unless Irssi::settings_get_bool('growl_enabled');
    my ( $title, $subject, $identifier ) = @_;

    my @command_line_args = (
        Irssi::settings_get_str('growl_growlnotifypath'),
        '-n', 'irssi', '-d', $identifier, '-t', $title, '-m', $subject,
    );

    push @command_line_args, '-s' if Irssi::settings_get_bool('growl_sticky');
    if ( Irssi::settings_get_str('growl_image_path') ) {
        push @command_line_args, '--image',
            Irssi::settings_get_str('growl_image_path');
    }

    return system(@command_line_args) ? 0 : 1;
}

Irssi::settings_add_bool( $IRSSI{'name'}, 'growl_show_private_messages', 1 );
Irssi::settings_add_bool( $IRSSI{'name'}, 'growl_show_hilights',         1 );
Irssi::settings_add_bool( $IRSSI{'name'}, 'growl_sticky',                0 );
Irssi::settings_add_bool( $IRSSI{'name'}, 'growl_enabled',               1 );
Irssi::settings_add_str( $IRSSI{'name'}, 'growl_growlnotifypath', '/usr/local/bin/growlnotify' );
Irssi::settings_add_str( $IRSSI{'name'}, 'growl_image_path', '' );

Irssi::signal_add_last( 'message private', 'on_message_private' );
Irssi::signal_add_last( 'print text',      'on_print_text' );

Irssi::print( $IRSSI{name} . ' ' . $VERSION . ' loaded' );
unless ( Irssi::settings_get_bool('growl_enabled') ) {
    Irssi::print('growl_enabled is FALSE by default');
    Irssi::print('Run "/set growl" for a list of settings');
}

1;
