package Device::WallyHome::Role::Creator;
use Moose::Role;
use MooseX::AttributeShortcuts;

use Data::Dumper;
use Module::Loader;

our $VERSION = 0.01;


#== ATTRIBUTES =================================================================

has 'callbackObject' => (
    is       => 'ro',
    weak_ref => 1,
    writer   => '_callbackObject',
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

sub loadPlaceFromApiResponseData {
    my ($self, $placeData) = @_;

    my $initData = {};

    # Non-Boolean Attributes
    foreach my $attribute (qw{
        id
        accountId
        label
        fullAddress
        address
        sensorIds
        nestAdjustments
        rapidResponseSupport
    }) {
        $initData->{$attribute} = $placeData->{$attribute};
    }

    # Boolean Attributes
    foreach my $attribute (qw{
        suspended
        buzzerEnabled
        nestEnabled
    }) {
        $initData->{$attribute} = $placeData->{$attribute} ? 1 : 0;
    }

    return $self->instantiateObject('Device::WallyHome::Place', $initData);
}

sub loadSensorFromApiResponseData {
    my ($self, $sensorData) = @_;

    my $initData = {};

    # Non-Boolean Attributes
    foreach my $attribute (qw{
        snid
        paired
        updated
        signalStrength
        recentSignalStrength
        hardwareType
        thresholds
        state
        activities
    }) {
        $initData->{$attribute} = $sensorData->{$attribute};
    }

    # Boolean Attributes
    foreach my $attribute (qw{
        offline
        suspended
        alarmed
    }) {
        $initData->{$attribute} = $sensorData->{$attribute} ? 1 : 0;
    }

    $initData->{location} = $self->instantiateObject('Device::WallyHome::Sensor::Location', $sensorData->{location});

    my $sensor = $self->instantiateObject('Device::WallyHome::Sensor', $initData);
}

1;
