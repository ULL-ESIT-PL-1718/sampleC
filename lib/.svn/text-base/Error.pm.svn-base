

package Error;
  use strict;
  use warnings;
  use Carp;

  require Exporter;

  our @ISA = qw(Exporter);
  our @EXPORT = qw( error fatal);
  our $VERSION = '0.01';

  sub error {
    my $msg = join " ", @_;
    if (!$PL::Tutu::errorflag) {
      print "Error: $msg\n";
      #$PL::Tutu::errorflag = 1;
    }
  }

  sub fatal {
    my $msg = join " ", @_;
    croak("Error: $msg\n");
  }

