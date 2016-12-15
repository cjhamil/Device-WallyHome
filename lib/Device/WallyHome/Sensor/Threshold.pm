package Device::WallyHome::Sensor::Threshold;
use Moo;
use MooX::Types::MooseLike::Base qw(:all);
use namespace::autoclean;

our $VERSION = '0.21.4';


#== ATTRIBUTES =================================================================

has 'name' => (
    is       => 'ro',
    isa      => Str,
    required => 1,
    writer   => '_name',
);

has 'min' => (
    is       => 'ro',
    isa      => Maybe[Num],
    required => 1,
    writer   => '_min',
);

has 'max' => (
    is       => 'ro',
    isa      => Maybe[Num],
    required => 1,
    writer   => '_max',
);


#== PUBLIC METHODS =============================================================

sub asArrayRef {
    my ($self) = @_;

    return [
        $self->min(),
        $self->max(),
    ];
}

sub asHref {
    my ($self) = @_;

    return {
        min => $self->min(),
        max => $self->max(),
    };
}


__PACKAGE__->meta->make_immutable;

1;
