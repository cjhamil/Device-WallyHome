package Device::WallyHome::Sensor;
use Moose;
use MooseX::AttributeShortcuts;
use namespace::autoclean;

our $VERSION = 0.01;

with 'Device::WallyHome::Role::Creator';
with 'Device::WallyHome::Role::REST';


#== ATTRIBUTES =================================================================

has 'snid' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    writer   => '_snid',
);

has 'offline' => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
    writer   => '_offline',
);

has 'paired' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    writer   => '_paired',
);

has 'updated' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    writer   => '_updated',
);

has 'alarmed' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    writer   => '_alarmed',
);

has 'signalStrength' => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
    writer   => '_signalStrength',
);

has 'recentSignalStrength' => (
    is       => 'rw',
    isa      => 'Num',
    required => 1,
    writer   => '_recentSignalStrength',
);

has 'hardwareType' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    writer   => '_hardwareType',
);

has 'location' => (
    is       => 'rw',
    isa      => 'HashRef',
    required => 1,
    writer   => '_location',
);

has 'thresholds' => (
    is       => 'rw',
    isa      => 'HashRef',
    required => 1,
    writer   => '_thresholds',
);

has 'state' => (
    is       => 'rw',
    isa      => 'HashRef',
    required => 1,
    writer   => '_state',
);

has 'activities' => (
    is       => 'rw',
    isa      => 'ArrayRef',
    required => 1,
    writer   => '_activities',
);


#== ATTRIBUTE BUILDERS =========================================================



#== PRIVATE METHODS ============================================================



#== PUBLIC METHODS =============================================================



__PACKAGE__->meta->make_immutable;

1;
