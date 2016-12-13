package Device::WallyHome::Sensor;
use Moose;
use MooseX::AttributeShortcuts;
use namespace::autoclean;

our $VERSION = 0.01;

with 'Device::WallyHome::Role::Creator';
with 'Device::WallyHome::Role::REST';


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
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
    writer   => '_thresholds',
);

has 'state' => (
    is       => 'ro',
    isa      => 'HashRef',
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



#== PRIVATE METHODS ============================================================



#== PUBLIC METHODS =============================================================



__PACKAGE__->meta->make_immutable;

1;
