package Device::WallyHome::Sensor;
use Moose;
use MooseX::AttributeShortcuts;
use namespace::autoclean;

our $VERSION = 0.01;

with 'Device::WallyHome::Role::Creator';
with 'Device::WallyHome::Role::REST';
with 'Device::WallyHome::Role::Validator';


#== ATTRIBUTES =================================================================

has 'snid' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    writer   => '_snid',
);

has 'offline' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
    writer   => '_offline',
);

has 'paired' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    writer   => '_paired',
);

has 'updated' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    writer   => '_updated',
);

has 'alarmed' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    writer   => '_alarmed',
);

has 'signalStrength' => (
    is       => 'ro',
    isa      => 'Num',
    required => 1,
    writer   => '_signalStrength',
);

has 'recentSignalStrength' => (
    is       => 'ro',
    isa      => 'Num',
    required => 1,
    writer   => '_recentSignalStrength',
);

has 'hardwareType' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    writer   => '_hardwareType',
);

has 'location' => (
    is       => 'ro',
    isa      => 'Device::WallyHome::Sensor::Location',
    required => 1,
    writer   => '_location',
);

has 'thresholds' => (
    is => 'lazy',
);

has 'thresholdsByName' => (
    is       => 'ro',
    isa      => 'HashRef[Device::WallyHome::Sensor::Threshold]',
    required => 1,
    writer   => '_thresholds',
);

has 'states' => (
    is => 'lazy',
);

has 'statesByName' => (
    is       => 'ro',
    isa      => 'HashRef[Device::WallyHome::Sensor::State]',
    required => 1,
    writer   => '_state',
);

has 'activities' => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
    writer   => '_activities',
);


#== ATTRIBUTE BUILDERS =========================================================

sub _build_thresholds {
    my ($self) = @_;

    return [map { $self->thresholdsByName()->{$_} } sort keys %{ $self->thresholdsByName() }];
}

sub _build_states {
    my ($self) = @_;

    return [map { $self->statesByName()->{$_} } sort keys %{ $self->statesByName() }];
}

#== PUBLIC METHODS =============================================================

sub threshold {
    my ($self, $name) = @_;

    $self->_checkRequiredScalarParam($name, 'name');

    return $self->thresholdsByName->{$name} // undef;
}

sub state {
    my ($self, $name) = @_;

    $self->_checkRequiredScalarParam($name, 'name');

    return $self->statesByName->{$name} // undef;
}


__PACKAGE__->meta->make_immutable;

1;
