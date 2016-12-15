use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker;

WriteMakefile
(
    NAME      => 'Device::WallyHome',
    PREREQ_PM => {
        'Data::Dumper'                 => '2.161',
        'HTTP::Headers'                => '6.11',
        'HTTP::Request'                => '6.11',
        'JSON::MaybeXS'                => '1.003008',
        'List::Util'                   => '1.46',
        'LWP::Protocol::https'         => '6.06',
        'LWP::UserAgent'               => '6.15',
        'Module::Loader'               => '0.03',
        'Moo'                          => '2.003000',
        'Moo::Role'                    => '2.000002',
        'MooX::Types::MooseLike::Base' => '0.029',
        'namespace::autoclean'         => '0.16',
        'Test::Exception'              => '0.43',
        'Test::More'                   => '1.302067',
    },
    VERSION_FROM => 'lib/Device/WallyHome.pm',
);
