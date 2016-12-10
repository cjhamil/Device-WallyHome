use strict;
use warnings;

use Test::More tests => 3;
use Test::Exception;

use Device::WallyHome;

ok(defined Device::WallyHome->VERSION, 'version defined');

throws_ok(sub{ my $device = Device::WallyHome->new() }, qr/Attribute \(token\) is required at constructor/, 'required token attribute');

my $device = Device::WallyHome->new(token => 'test-token');

ok(defined $device, 'instantiate device object');
