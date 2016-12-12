package Device::WallyHome::Role::Creator;
use Moose::Role;
use MooseX::AttributeShortcuts;

use Module::Loader;

our $VERSION = 0.01;


#== ATTRIBUTES =================================================================

has 'callbackObject' => (
    is       => 'rw',
    weak_ref => 1,
);


#== PUBLIC METHODS =============================================================

sub instantiateObject {
    my ($self, $class, $params) = @_;

    $params //= {};

    my $restApiRole = 'Device::WallyHome::Role::REST';

    # Dynamically load class module
    eval {
        (my $file = $class) =~ s/::/\//g;

        require $file . '.pm';

        $class->import();

        1;
    } or do {
        die "Failed to dynamically load class module ($class): " . $@;
    };

    # Pass along REST API information
    if (
           $self->does($restApiRole)
        && $class->does($restApiRole)
    ) {
        $params->{apiHostname}  //= $self->apiHostname();
        $params->{apiUseHttps}  //= $self->apiUseHttps();
        $params->{apiVersion}   //= $self->apiVersion();
        $params->{lastApiError} //= $self->lastApiError();
        $params->{token}        //= $self->token();
        $params->{timeout}      //= $self->timeout();
    }

    # Use ourself as the callback object
    $params->{callbackObject} = $self;

    Module::Loader->new()->load($class);

    my $obj = $class->new(%$params);

    die "Failed to instantiate object ($class): " . Dumper($params) unless defined $obj;

    return $obj;
}

1;
