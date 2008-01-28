use strict;
use warnings;

use Test::More;

use Config;
use File::Spec;
use IO::CaptureOutput qw/capture/;
use t::DotDirs;

plan tests =>  5 ;

#--------------------------------------------------------------------------#
# Setup test environment
#--------------------------------------------------------------------------#

# prepend our lib dir with mock Test::Reporter and CPAN::MyConfig
my $test_lib = File::Spec->rel2abs(File::Spec->catdir(qw/t lib/)); 
unshift @INC, $test_lib;
$ENV{PERL5LIB} = join( $Config{path_sep}, 
    $test_lib, ( defined $ENV{PERL5LIB} ? $ENV{PERL5LIB} : () )
);

# Force load early so the testing version will be found before CPAN.pm
# adds $ENV{HOME}/.cpan to @INC so we don't load the user's config by mistake
require CPAN::MyConfig;
$ENV{PERL5OPT} = join( q{}, 
    "-I$test_lib -MCPAN::MyConfig", ( defined $ENV{PERL5OPT} ? $ENV{PERL5OPT} : () )
);

# Setup CPAN working directory
t::DotDirs->prepare_cpan;

# Setup CPAN::Reporter configuration
$ENV{PERL_CPAN_REPORTER_DIR} = t::DotDirs->prepare_cpan_reporter;

my ($stdout, $stderr);

#--------------------------------------------------------------------------#
# tests begin here
#--------------------------------------------------------------------------#

require_ok( 'CPAN::Reporter::Smoker' );

can_ok( 'CPAN::Reporter::Smoker', 'start' );

pass ("Starting simulated smoke testing");
capture sub { CPAN::Reporter::Smoker::start() } => \($stdout, $stderr);

require_ok( 'CPAN::Reporter::History' );
my @results = CPAN::Reporter::History::have_tested();
is( scalar @results, 4, "Number of reports in history" );

