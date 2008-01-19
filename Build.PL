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
    requires        => {
        'perl' => 5.006,
        'CPAN' => 1.92,
        'CPAN::Reporter' => '1.07_02',
        'IO::File' => 0,
        'File::Temp' => 0.20,
        'File::Spec' => 3.27,
        'Module::Build' => 0.2808,
        'Probe::Perl' => 0,
    },
    build_requires  => {
        'Test::More'            => 0.74, # various features/fixes
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
