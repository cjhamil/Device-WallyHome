use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker;

WriteMakefile
(
    NAME         => 'Device::WallyHome',
    PREREQ_PM    => {
        'Data::Dumper'               => 0,
        'ExtUtils::MakeMaker'        => 0,
        'HTTP::Headers'              => 0,
        'HTTP::Request'              => 0,
        'JSON::MaybeXS'              => 0,
        'List::Util'                 => 0,
        'LWP::UserAgent'             => 0,
        'Module::Loader'             => 0,
        'Moose'                      => 0,
        'Moose::Role'                => 0,
        'MooseX::AttributeShortcuts' => 0,
        'Test::Exception'            => 0,
        'Test::More'                 => 0,
    },
    VERSION_FROM => 'lib/Device/WallyHome.pm',
);
