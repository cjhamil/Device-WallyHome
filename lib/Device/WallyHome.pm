package Device::WallyHome;
use Moose;
use MooseX::AttributeShortcuts;
use namespace::autoclean;

use List::Util qw(first);

with 'Device::WallyHome::Role::Creator';
with 'Device::WallyHome::Role::REST';
with 'Device::WallyHome::Role::Validator';

our $VERSION = 0.01;


#== ATTRIBUTES =================================================================

has 'places' => (
    is => 'lazy',
);

has 'sensorsByPlace' => (
    is => 'lazy'
);


#== ATTRIBUTE BUILDERS =========================================================

sub _build_places {
    my ($self) = @_;

    my $placeList = $self->request({
        uri => 'places',
    });

    my $placeObjectList = [];

    foreach my $placeData (@$placeList) {
        push @$placeObjectList, $self->_loadPlaceFromApiResponseData($placeData);
    }

    return $placeObjectList;
}


#== PRIVATE METHODS ============================================================

sub _loadPlaceFromApiResponseData {
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

#== PUBLIC METHODS =============================================================

sub getPlaceById {
    my ($self, $placeId) = @_;

    $self->_checkRequiredScalarParam($placeId, 'placeId');

    return first { $_->id() eq $placeId } @{ $self->places() };
}

sub getPlaceByLabel {
    my ($self, $label) = @_;

    $self->_checkRequiredScalarParam($label, 'label');

    return first { $_->label() eq $label } @{ $self->places() };
}

__PACKAGE__->meta->make_immutable;

1;
