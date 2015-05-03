use strict;
use warnings;

use Test::More;

use CPAN::Reporter::Smoker;

plan tests =>  6 ;

my $list = CPAN::Reporter::Smoker::_parse_module_index('t/parse_module_index/02packages.details.txt', 't/parse_module_index/find-ls', 0);
is(scalar(@$list), 8);
ok(grep {$_ eq 'PETDANCE/Test-Harness-2.62_02.tar.gz'} @$list, 'Test-Harness-2.62_02 present');
ok(!grep {$_ eq 'PETDANCE/Test-Harness-2.62_01.tar.gz'} @$list, 'Test-Harness-2.62_01 not present');

ok(!grep {$_ eq 'DAGOLDEN/Bundle-Fake-1.00.tar.gz'} @$list, 'bundle module not present');

ok(grep {$_ eq 'TEST/Test-Test-1.01.tar.gz'} @$list, 'Test-Test-1.01 present');
ok(!grep {$_ eq 'TEST/Test-Test-1.00_01.tar.gz'} @$list, 'Test-Test-1.00_01 not present');
