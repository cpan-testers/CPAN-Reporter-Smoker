use 5.006;
use strict;
use lib 'inc';
eval "require Pod::WikiDoc";
my $class = $@ ? "Module::Build" : "Module::Build::WikiDoc";
eval "require $class";
$class->new( 
    module_name         => 'CPAN::Reporter::Smoker',
    dist_author         => 'David A. Golden <dagolden@cpan.org>',
    license             => 'apache',
    create_readme       => 1,
    create_makefile_pl  => 'traditional',
    requires => {
        'perl' => 5.006,
        # require sane tools
        'ExtUtils::MakeMaker' => 6.36,
        'Module::Build' => 0.28,
        # actual requires
        'Carp' => 0,
        'Compress::Zlib' => 1.2, 
        'CPAN' => 1.92, 
        'CPAN::HandleConfig' => 0,
        'CPAN::Reporter::History' => 1.17,
        'CPAN::Tarzip' => 0,
        'Exporter' => 0,
        'Fcntl' => 0,
        'File::Basename' => 0,
        'File::Spec' => 3.27, 
        'File::Temp' => 0.20, 
        'Probe::Perl' => 0.01,
        'Term::Title' => 0.01,
        'Test::Reporter' => 1.52,
    },
    build_requires => {
        'Cwd' => 3.27, 
        'File::Path' => 0,
        'IO::CaptureOutput' => 1.06,
        'IO::File' => 0,
        'Test::More' => 0.62, 
    },
    meta_merge            => { 
        no_index => { 
            directory => [ qw{
                examples
                inc
            }],
        },
        resources => {
            repository => 'http://dagolden.googlecode.com/svn/'
        },
    },
)->create_build_script;
