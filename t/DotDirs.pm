package t::DotDirs;

# stolen/adapted from local_utils.pm in the CPAN.pm distro

use File::Path qw(rmtree mkpath);
use File::Spec ();
use IO::File;

sub _f ($) {File::Spec->rel2abs(File::Spec->catfile(split /\//, shift));}
sub _d ($) {File::Spec->rel2abs(File::Spec->catdir(split /\//, shift));}

my $dot_cpan = _d"t/dot-cpan";
my $dot_cpan_reporter = _d"t/dot-cpanreporter";

sub cleanup {
    my $dir = shift;
    # suppress warnings
    local $SIG{__WARN__} = sub { 1 };
    # try more than once -- Win32 sometimes fails due to apparent timing issues
    for ( 0 .. 1 ) {
        rmtree $dir if -d $dir;
    }
}

sub prepare_cpan {
    cleanup $dot_cpan;
    mkpath $dot_cpan;
    return $dot_cpan;
}

sub prepare_cpan_reporter {
    cleanup $dot_cpan_reporter;
    mkpath $dot_cpan_reporter;
    my $config = IO::File->new( _f"$dot_cpan_reporter\/config.ini", ">" );
    print {$config} <DATA>;
    $config->close;
    return $dot_cpan_reporter;
}

END { 
    cleanup $dot_cpan;
    cleanup $dot_cpan_reporter;
}

1;

# standard .cpanreporter/config.ini for testing
__DATA__
email_from = johndoe@example.com
command_timeout = 30
send_duplicates = yes
transport = Null
