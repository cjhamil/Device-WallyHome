package Device::WallyHome;
use Moose;
use MooseX::AttributeShortcuts;
use namespace::autoclean;

use HTTP::Headers;
use HTTP::Request;
use JSON::MaybeXS qw(decode_json);
use LWP::UserAgent;

our $VERSION = 0.01;


#== ATTRIBUTES =================================================================

has 'apiHostname' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'api.snsr.net',
);

has 'apiUseHttps' => (
    is      => 'rw',
    isa     => 'Int',
    default => 1,
);

has 'apiVersion' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'v2',
);

has 'lastError' => (
    is     => 'ro',
    isa    => 'Maybe[Str]',
    writer => '_lastError',
);

has 'token' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'userAgentName' => (
    is => 'lazy',
);

has 'timeout' => (
    is      => 'rw',
    isa     => 'Int',
    default => '180',
);

has '_userAgent' => (
    is => 'lazy',
);


#== ATTRIBUTE BUILDERS =========================================================

sub _build__userAgent {
    my ($self) = @_;

    return LWP::UserAgent->new(
        agent   => $self->userAgentName(),
        timeout => $self->timeout(),
    );
}

sub _build_userAgentName {
    return "Device::WallyHome v$VERSION";
}


#== PRIVATE METHODS ============================================================

sub _headers {
    my ($self) = @_;

    my $headers = HTTP::Headers->new();

    $headers->header('Authorization' => 'Bearer ' . $self->token());

    return $headers;
}

sub _baseUrl {
    my ($self) = @_;

    my $s = $self->apiUseHttps() ? 's' : '';

    return "http$s://" . $self->apiHostname() . '/' . $self->apiVersion() . '/';
}

sub _wallyUrl {
    my ($self, $path) = @_;

    return $self->_baseUrl() . $path;
}


#== PUBLIC METHODS =============================================================

sub getPlaces {
    my ($self) = @_;

    my $request = HTTP::Request->new('GET', $self->_wallyUrl('places'), $self->_headers());

    my $response = $self->_userAgent()->request($request);

    my $placeList = {};

    eval {
        $placeList = decode_json($response->content());
    };

    if ($@) {
        $self->_lastError($@);

        return undef;
    }

    return $placeList;
}

sub getSensors {
    my ($self, $placeId) = @_;

    die 'valid placeId required' unless defined $placeId && !ref($placeId);

    my $request = HTTP::Request->new('GET', $self->_wallyUrl("places/$placeId/sensors"), $self->_headers());

    my $response = $self->_userAgent()->request($request);

    my $sensorList = {};

    eval {
        $sensorList = decode_json($response->content());
    };

    if ($@) {
        $self->_lastError($@);

        return undef;
    }

    return $sensorList;
}


__PACKAGE__->meta->make_immutable;

1;
