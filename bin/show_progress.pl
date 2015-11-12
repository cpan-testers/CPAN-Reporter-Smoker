#!/usr/bin/env perl

use warnings;
use strict;
use IO::Socket;
use Storable qw(thaw);
use constant MY_ECHO_PORT => 2007;
use constant MAX_MSG_LEN => 5000;

my $port = shift || MY_ECHO_PORT;

$SIG{INT} = sub { exit 0 };

my $sock = IO::Socket::INET->new(Proto => 'udp', LocalPort => $port) or die $@;

my $msg_in;

warn "servicing incoming requests...\n";

while(1) {

    next unless $sock->recv($msg_in, MAX_MSG_LEN);
    my $status_ref = thaw($msg_in);
    my $peer_host = gethostbyaddr($sock->peeraddr, AF_INET) || $sock->peerhost;
    my $peer_port = $sock->peerport;
    my $length = length($msg_in);

    my ($curr_dists, $total_dists, $dps) = ( $status_ref->{curr_dists},$status_ref->{total_dists},$status_ref->{dps} );

    print '+----------------------------------------+', "\n";
    print 'CPAN::Reporter::Smoker quick stats:', "\n";
    print "Received $length bytes from [$peer_host, $peer_port]\n";
    print "Doing $curr_dists of $total_dists ($dps)\n";

    #$msg_out = reverse $msg_in;
    #$sock->send($msg_out) or die "send(): $!\n";

}

$sock->close;
