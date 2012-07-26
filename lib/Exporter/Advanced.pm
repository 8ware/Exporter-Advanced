package Exporter::Advanced;

use 5.014002;
use strict;
use warnings;

#use feature 'switch';

=head1 NAME

Exporter::Advanced - An extension of Perl's Exporter-module enabling
configuration of the module

=head1 SYNOPSIS

  require Exporter::Advanced;
  @ISA = qw(Exporter::Advanced);

  %CONFIGURATION = (
      do_something_this_way => \$flag
  );

=head1 DESCRIPTION

Additionally to the usual export-functionality, this module handles also
module-configurations. Therefore the module can specify a C<%CONFIGURATION>
which contains the names and their types of the module's configurable
options referencing a scalar which is assigned to the value.

The configuration-syntax is inspired by the options-definition of the
C<Getopt::Long>-module. Each configuration key has a scalar-reference as
value. The key is one of four types: boolean flag, string, number,
reference or any combination.

  our CONFIGURATION = (
      'flag' => \$flag,                 # same as 'flag=b'
      'string=s' => \$string,
      'number=n' => \$number,
      'reference=r' => \$reference,
      'mixed=bsnr' => \$mixed
  );

If the given option-constraint is violated it'll dies.

=head2 DO NOTs

=over 4

=item Do not use C<true>, C<false>, C<1> or C<0> as configuration-keys due to
the configuration-processing could accidentially result in undefined
behavior.

=item Do not use possible values as configuration-keys.

=item Do not use a subroutine-name which can be exported as configuration-key.

=back

=head2 EXPORT

None by default.

=cut

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Exporter::Advanced ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


use Carp;

sub import {
	my $pkg = shift;
	my @imports;
	no strict 'refs';
	my (%types, %references);
	my @flags;
	while (my ($key, $ref) = each %{"$pkg\::CONFIGURATION"}) {
		croak "Not a valid type-restriction: ".(split /=/, $key)[1]
			unless $key =~ s/(?:=([bsnr]+))?$//;
		croak "Not a scalar reference: $ref" unless ref $ref eq 'SCALAR';
		$types{$key} = $1 || 'b';
		$references{$key} = $ref;
		push @flags, $key unless defined $1 and not $1 =~ /b/;
	}
	for (my $i = 0; $i < @_; $i++) {
		my $key = $_[$i];
		my $value = $_[++$i] || 1; # if $i++ is out of range
		if ($key ~~ @flags) {
			if(defined $types{$value}) {
				$value = 1;
				$i--;
			} else {
				$value = 1 if $value eq 'true';
				$value = 0 if $value eq 'false';
			}
		}
		if (defined $types{$key}) {
#			given ($types{$key}) {
#				when (/b/) {
#					croak "Not a valid boolean: $value" unless $value =~ /^[10]$/;
#				}
#				when (/s/) {
#					croak "Not a string: $value" unless $value =~ /^\w+$/;
#				}
#				when (/n/) {
#					croak "Not a number: $value" unless $value =~ /^\d+$/;
#				}
#				when (/r/) {
#					croak "Not a reference: $value" unless ref $value;
#				}
#				default {
#					croak "This should never been printed!";
#				}
#			}
			my $type;
			given ($value) {
				when (/^[10]$/) {
					$type = 'b';
				}
				when (/^\d+$/) {
					$type = 'n';
				}
				when (/^[\w ]+$/) {
					$type = 's';
				}
				default {
					if (ref $value) {
						$type = 'r';
					} else {
						croak "Cannot determine value-type: $value";
					}
				}
			}
			croak "No appropriate value: $value" unless $types{$key} =~ /$type/;
			${ $references{$key} } = $value;
		} else {
			push @imports, $key;
			$i--;
		}
	}
	$pkg->export_to_level(1, $pkg, @imports);
}


1;
__END__
=head1 TODOs

=over 4

=item enable more detailed value restriction:

  'number=(7|42)' => \$number

or

  'reference=r[CODE($$)]' => \$callback

=item provide possibility to export C<import>-subroutine

=item recognize a C<DEFAULTS>-hash which specifies default-values for
(each) property-key

=back

=head1 SEE ALSO

For more detailed information about the usage of the C<EXPORT>- and
C<EXPORT_OK>-array and the C<EXPORT_TAGS>-hash, respectively see
the perldoc of the Exporter-module.

=head1 AUTHOR

8ware, E<lt>8wared@googlemail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by 8ware

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
