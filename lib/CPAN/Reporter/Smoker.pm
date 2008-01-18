package CPAN::Reporter::Smoker;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.01_01'; 

use CPAN; 
use CPAN::HandleConfig;
use File::Temp 0.20;
use File::Spec;
use Probe::Perl;

use Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw/ start /; ## no critic Export

#--------------------------------------------------------------------------#
# globals
#--------------------------------------------------------------------------#

my $perl = Probe::Perl->find_perl_interpreter;
my $module_file = 'modules/01modules.index.html';

#--------------------------------------------------------------------------#
# start -- start automated smoking
#--------------------------------------------------------------------------#

use constant DEBUG => 1; ## no critic constant

sub start {
    warn "Starting CPAN::Reporter::Smoker\n" if DEBUG;

    # Always accept default prompts
    local $ENV{PERL_MM_USE_DEFAULT} = 1;

    # Load CPAN configuration
    CPAN::HandleConfig->load();
    CPAN::Shell::setup_output;
    CPAN::Index->reload;

    # Get the list of distributions to process
    my $index = _get_module_index()
        or die "Couldn't get '$module_file' from your CPAN mirror. Halting\n";
    my $dists = _parse_module_index( $index );
    
    # Start smoking
    for my $d ( @$dists ) {
        print "Testing $d\n" if DEBUG;
        system($perl, "-MCPAN", "-e", "report( '$d' )");
        die "Halted with signal\n" if $? & 127;
    }

    return;
}

#--------------------------------------------------------------------------#
# private variables and functions
#--------------------------------------------------------------------------#

my $module_index_re = qr{
    ^\s href="\.\./authors/id/./../    # skip prelude 
    ([^"]+)                     # capture to next dquote mark
    .+? </a>                    # skip to end of hyperlink
    \s+                         # skip spaces
    \S+                         # skip size
    \s+                         # skip spaces
    (\S+)                       # capture day
    \s+                         # skip spaces
    (\S+)                       # capture month 
    \s+                         # skip spaces
    (\S+)                       # capture year
}xms; 

my %months = ( 
    Jan => '01', Feb => '02', Mar => '03', Apr => '04', May => '05',
    Jun => '06', Jul => '07', Aug => '08', Sep => '09', Oct => '10',
    Nov => '11', Dec => '12'
);

#--------------------------------------------------------------------------#
# _get_module_index
#
# download the 01modules index and return the local file name
#--------------------------------------------------------------------------#

sub _get_module_index {
    my $tmp_dir = File::Temp->newdir( 'CPAN-Reporter-Smoker-XXXXXXX', 
        DIR => File::Spec->tmpdir,
    );
    my $local_file = File::Spec->catfile( $tmp_dir, 'module_index' );
    return CPAN::FTP->localize( $module_file, $local_file ); 
}

#--------------------------------------------------------------------------#
# _parse_module_index
#
# parse index and return array_ref of distributions in reverse date order
#--------------------------------------------------------------------------#-

sub _parse_module_index {
    my ($filename) = @_;
    my $fh = IO::File->new( $filename );

    INTRO:
    while ( my $line = <$fh> ) {
        chomp $line;
        if ( $line =~ /^<pre>/ ) {
            # skip 3 more lines
            <$fh> for 0 .. 2;
            last INTRO;
        }
    }

    my %dists;
    while ( my $line = <$fh> ) {
        next unless substr($line,0,1) eq q{ }; # unless starts with space
        my ($dist,$day,$month,$year) = $line =~ $module_index_re;
        next unless $dist;
        $dists{$dist} = $year . $months{$month} . $day;
    }

    return [ sort { $dists{$b} <=> $dists{$a} } keys %dists ];
}

1; #modules must return true

__END__

#--------------------------------------------------------------------------#
# pod documentation 
#--------------------------------------------------------------------------#

=begin wikidoc

= NAME

CPAN::Reporter::Smoker - Turnkey CPAN Testers smoking

= VERSION

This documentation describes version %%VERSION%%.

= SYNOPSIS

    $ perl -MCPAN::Reporter::Smoker -e start

= DESCRIPTION

Rudimentary smoke tester for CPAN Testers, building upon [CPAN::Reporter].

Under development.

= USAGE

Things to talk about:

* using a minicpan -- need for 01modules.index.html
* skipfile
* scan cache for cleanup

== FUNCTIONS

== {start()}

Starts smoke testing using defaults already in CPAN::Config and 
CPAN::Reporter's .cpanreporter directory.

= BUGS

Please report any bugs or feature using the CPAN Request Tracker.  
Bugs can be submitted through the web interface at 
[http://rt.cpan.org/Dist/Display.html?Queue=CPAN-Reporter-Smoker]

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

= SEE ALSO

* [CPAN::Reporter]
* [CPAN::Testers]

= AUTHOR

David A. Golden (DAGOLDEN)

= COPYRIGHT AND LICENSE

Copyright (c) 2008 by David A. Golden

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at 
[http://www.apache.org/licenses/LICENSE-2.0]

Files produced as output though the use of this software, shall not be
considered Derivative Works, but shall be considered the original work of the
Licensor.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end wikidoc

=cut
