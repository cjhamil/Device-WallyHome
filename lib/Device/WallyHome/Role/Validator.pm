package Device::WallyHome::Role::Validator;
use Moose::Role;
use MooseX::AttributeShortcuts;

our $VERSION = 0.01;


#== PRIVATE METHODS ============================================================

sub _checkRequiredScalarParam {
    my ($self, $value, $paramName) = @_;

    $paramName //= 'parameter';

    die $paramName . ' required' unless defined $value;

    die 'valid ' . $paramName . ' required' if ref($value);
}

1;
