# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Exporter-Advanced.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use lib 't';

use Test::More 'no_plan';#tests => 1;
#BEGIN { use_ok('Exporter::Advanced') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $val_ref;
sub callback {
	print "@_\n";
}

my @imports = (
);
use Mock::Module
	':all',
	number => 4,
	'flag_1',
	flag_2 => 'true',
	string => 'yo',
	ref => \$val_ref,
	'mixed_1',
	mixed_2 => 8,
	mixed_3 => 'was geht',
#	fail => 1,
#	mixed_4 => \&callback;
	mixed_4 => sub { print "@_\n" };

show_config();

