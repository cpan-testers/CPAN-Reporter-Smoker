#!/usr/bin/env perl

use warnings;
use strict;
use IO::Socket;
use Storable qw(thaw);
use Getopt::Std;
use constant MY_ECHO_PORT => 2007;
use constant MAX_MSG_LEN => 5000;

my %opts;
getopts('hp:l:',\%opts);

if (exists($opts{h})) {
    print <<BLOCK;
Small UDP server to receive notification of CPAN::Reporter smokers.
Usage:
-h: this help message
-p: port to listen to (default to 2007)
-l: local address to bind to (default to "localhost")
BLOCK
    exit 0;
}

my ($port,$local_addr);

if (exists($opts{p})) {
    $port = $opts{p};
} else {
    $port = 2007;
}

if (exists($opts{l})) {
    $local_addr = $opts{l};
} else {
    $local_addr = 'localhost';
}

$SIG{INT} = sub { exit 0 };

my $sock = IO::Socket::INET->new(Proto => 'udp', LocalPort => $port, LocalAddr => $local_addr) or die $@;

warn "servicing incoming requests...\n";

while(1) {

    my $msg_in;
    next unless $sock->recv($msg_in, MAX_MSG_LEN);
    my $status_ref = thaw($msg_in);
    my $peer_host = gethostbyaddr($sock->peeraddr, AF_INET) || $sock->peerhost;
    my $peer_port = $sock->peerport;
    my $length = length($msg_in);

    my ($curr_dists, $total_dists, $dpm) = ( $status_ref->{curr_dists},$status_ref->{total_dists},$status_ref->{dpm} );

    print '+----------------------------------------+', "\n";
    print 'CPAN::Reporter::Smoker quick stats:', "\n";
    print "Received $length bytes from [$peer_host, $peer_port]\n";
    print "Doing $curr_dists of $total_dists ($dpm)\n";

    #$msg_out = reverse $msg_in;
    #$sock->send($msg_out) or die "send(): $!\n";

}

$sock->close;
