package t::DotDirs;

# stolen/adapted from local_utils.pm in the CPAN.pm distro

use File::Path qw(rmtree mkpath);
use File::Spec ();
use IO::File;

sub _f ($) {File::Spec->rel2abs(File::Spec->catfile(split /\//, shift));}
sub _d ($) {File::Spec->rel2abs(File::Spec->catdir(split /\//, shift));}

my $dot_cpan = _d"t/dot-cpan";
my $dot_cpan_reporter = _d"t/dot-cpanreporter";

sub prepare_cpan {
    rmtree $dot_cpan if -d $dot_cpan;
    mkpath $dot_cpan;
    return $dot_cpan;
}

sub prepare_cpan_reporter {
    rmtree $dot_cpan_reporter if -d $dot_cpan_reporter;
    mkpath $dot_cpan_reporter;
    my $config = IO::File->new( _f"$dot_cpan_reporter\/config.ini", ">" );
    print {$config} <DATA>;
    $config->close;
    return $dot_cpan_reporter;
}

END { 
    rmtree $dot_cpan;
    rmtree $dot_cpan_reporter;
}

1;

# standard .cpanreporter/config.ini for testing
__DATA__
email_from = johndoe@example.com
command_timeout = 30
