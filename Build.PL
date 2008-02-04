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
        perl => 5.006,
        'CPAN' => 1.92, 
        'CPAN::HandleConfig' => 0, 
        'CPAN::Reporter::History' => 1.08,
        'CPAN::Tarzip' => 0, 
        'File::Basename' => 0,
        'File::Spec' => 3.27, 
        'File::Temp' => 0.20, 
        'Probe::Perl' => 0.01,
        'Module::Build' => 0.2808,
    },
    build_requires => {
        'Cwd' => 0,
        'File::Path' => 0,
        'IO::CaptureOutput' => 1.03,
        'IO::File' => 0,
        'Test::More' => 0.72,
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
