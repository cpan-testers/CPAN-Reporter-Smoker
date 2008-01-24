# Mock Test::Reporter -- don't actually send anything
# Adapated from helper test code in CPAN::Reporter
package Test::Reporter;
use Config;

use vars qw/$AUTOLOAD/;

sub new { return bless {}, shift }

# always pretend to be successful sending
sub send { 
    return 1 
} 

sub subject {
    my $self = shift;
    return uc($self->grade) . ' ' . $self->distribution .
        " $Config{archname} $Config{osvers}";
}

# handle all other properties
sub AUTOLOAD {
    my $self = shift;
    if ( @_ ) {
        $self->{ $AUTOLOAD } = shift;
    }
    return $self->{ $AUTOLOAD };
}

1;

