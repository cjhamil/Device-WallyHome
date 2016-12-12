package Device::WallyHome::Place;
use Moose;
use MooseX::AttributeShortcuts;
use namespace::autoclean;

our $VERSION = 0.01;

with 'Device::WallyHome::Role::Creator';
with 'Device::WallyHome::Role::REST';
with 'Device::WallyHome::Role::Validator';


#== ATTRIBUTES =================================================================

has 'id' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    writer   => '_id',
);

has 'accountId' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    writer   => '_accountId',
);

has 'label' => (
    is       => 'rw',
    isa      => 'Maybe[Str]',
    required => 1,
    writer   => '_label',
);

has 'fullAddress' => (
    is       => 'rw',
    isa      => 'Maybe[HashRef]',
    required => 1,
    writer   => '_fullAddress',
);

has 'address' => (
    is       => 'rw',
    isa      => 'Maybe[Str]',
    required => 1,
    writer   => '_address',
);

has 'suspended' => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
    writer   => '_suspended',
);

has 'buzzerEnabled' => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
    writer   => '_buzzerEnabled',
);

has 'sensorIds' => (
    is       => 'rw',
    isa      => 'ArrayRef',
    required => 1,
    writer   => '_sensorIds',
);

has 'nestAdjustments' => (
    is       => 'rw',
    isa      => 'HashRef',
    required => 1,
    writer   => '_nestAdjustments',
);

has 'nestEnabled' => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
    writer   => '_nestEnabled',
);

has 'rapidResponseSupport' => (
    is       => 'rw',
    isa      => 'ArrayRef',
    required => 1,
    writer   => '_rapidResponseSupport',
);

has 'sensors' => (
    is => 'lazy',
);


#== ATTRIBUTE BUILDERS =========================================================

sub _build_sensors {
    my ($self) = @_;

    my $newSensorIds     = [];
    my $sensorObjectList = [];

    my $sensorList = $self->request({
        uri => 'places/' . $self->id() . '/sensors'
    });

    foreach my $sensorData (@$sensorList) {
        my $sensor = $self->_loadSensorFromApiResponseData($sensorData);

        push @$sensorObjectList, $sensor;

        push @$newSensorIds, $sensor->snid();
    }

    $self->_sensorIds($newSensorIds);

    return $sensorObjectList;
}


#== PRIVATE METHODS ============================================================

sub _loadSensorFromApiResponseData {
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
        location
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

    my $sensor = $self->instantiateObject('Device::WallyHome::Sensor', $initData);
}


#== PUBLIC METHODS =============================================================

sub getSensorBySnid {
    my ($self, $snid) = @_;

    $self->_checkRequiredScalarParam($snid, 'snid');

    return first { $_->snid() eq $snid } @{ $self->sensors() };
}

sub getSensorByRoom {
    my ($self, $room) = @_;

    $self->_checkRequiredScalarParam($room, 'room');

    return first { $_->location()->{room} eq $room } @{ $self->sensors() };
}

__PACKAGE__->meta->make_immutable;

1;
