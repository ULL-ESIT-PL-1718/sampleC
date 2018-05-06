package Code::Generation;

use strict;
use warnings;
use carp;

require Exporter;
our @ISA = qw ( Exporter );
our @EXPORT = qw ( exp_code )
our $VERSION = '0.01';

sub exp_code {
	my($left_struct,$right_struct) = @_;
	if ($left_struct->{TYPE} == "VAL")
		print "HOOOOOLLLLLLLAAAAAA";
	}
}
