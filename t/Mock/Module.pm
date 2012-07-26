package Mock::Module;

use 5.014002;
use strict;
use warnings;

require Exporter::Advanced;

our @ISA = qw(Exporter::Advanced);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Exporter::Advanced ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	show_config
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	show_config
);

our $VERSION = '0.01';

my ($flag_1, $flag_2, $string, $number, $ref, $mixed_1, $mixed_2, $mixed_3, $mixed_4);

our %CONFIGURATION = (
	'flag_1' => \$flag_1,
	'flag_2=b' => \$flag_2,
	'string=s' => \$string,
	'number=n' => \$number,
	'ref=r' => \$ref,
	'mixed_1=bsnr' => \$mixed_1,
	'mixed_2=bsnr' => \$mixed_2,
	'mixed_3=bsnr' => \$mixed_3,
	'mixed_4=bsnr' => \$mixed_4
);

# verify(flag_1 => $flag);
sub verify($$) {
	
}

sub show_config() {
	while (my ($key, $value) = each %CONFIGURATION) {
		$key =~ s/=.+$//;
		say "$key=".(${ $value } || '');
	}
	$mixed_4->("called callback");
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Exporter::Advanced - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Exporter::Advanced;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Exporter::Advanced, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

8ware, E<lt>andydefrank@(none)E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by 8ware

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
