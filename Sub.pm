package Usage::Sub;

# Copyright (C) 2002 Trabas. All rights reserved.
#
# This program is free software. You may freely use it, modify
# and/or distribute it under the same term as Perl itself.
#
# $Revision: 1.2 $
# $Date: 2002/02/23 12:19:42 $

=head1 NAME

Usage::Sub - Issueing subroutine/method usage

=head1 SYNOPSIS

  use Usage::Sub;

  sub turn_on {
      @_ >= 2 or usage 'NAME, COLOR [, INTENTSITY]';
      # process goes on
  }

=cut

use 5.006;
use strict;
use warnings;
use Carp qw(confess cluck);
require Exporter;

=head1 EXPORT

Only usage() function is exported by default. You may optionally
import warn_hard() and warn_soft() functions. Or you can get all the
three using the tag I<:all>. Additionally, you can also access
parse_fqpn() by importing it explicitly (it's not included in I<:all>
tag).

=cut

our @ISA         = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw(usage warn_hard warn_soft)]);
our @EXPORT_OK   = (@{$EXPORT_TAGS{'all'}}, 'parse_fqpn');
our @EXPORT      = qw(usage);
our $VERSION     = '0.01';

sub _usage {
	my($caller, $arg, $prefix) = @_;
	my $sub = parse_fqpn($caller);
	unless ($sub) {
		$sub = parse_fqpn((caller 1)[3]);
		confess __PACKAGE__,
		        "::$sub() must be called from a method or subroutine";
	}

	$arg = '' unless defined $arg;
	my $usage = "$sub($arg)";
	$usage = "$prefix\->$usage" if defined $prefix;
	return "usage: $usage";
}

=head1 ABSTRACT

B<Usage::Sub> provides functions to issue the usage of subroutines
or methods from inside the stub. The issued usage is part of the
error message or warning when the subroutine in question is called
with inappropriate parameters.

=head1 DESCRIPTION

B<Usage::Sub> provides functions to issue the usage of subroutines
or methods from inside the stub. Some people like to check the
parameters of the routine. For example,

  # turn_on(NAME, COLOR [, INTENSITY])
  sub turn_on {
      @_ >= 2 or die "usage: turn_on(NAME, COLOR [, INTENSITY])\n";
      # the process goes on
  }

With usage() function (exported by default), you can achieve the same
result (and more) without having to remember the subroutine name.

  use Usage::Sub;

  sub turn_on {
      @_ >= 2 or usage 'NAME, COLOR [, INTENTSITY]';
      # process goes on
  }

The usage() function makes use of the caller() built-in function to
determine the subroutine name. When turn_on() is called with
inappropriate parameters, usage() will terminate the program with
backtrace information and prints error message like,

      usage: turn_on(NAME, COLOR [, INTENTSITY])

If turn_on() is a method, a prefix can be added to indicate it as
object method or class method call.

  sub turn_on {
      @_ >= 3 or usage 'NAME, COLOR [, INTENTSITY]', '$light';
      # process goes on
  }

The error message will be then,

      usage: $light->turn_on(NAME, COLOR [, INTENTSITY])

or

      usage: Light::My::Fire->turn_on(NAME, COLOR [, INTENTSITY])

should it be a class method call.


=cut

sub usage { confess _usage((caller 1)[3], @_) }

=pod

The warn_hard() and warn_soft() functions are similiar to usage(), but
they don't die. Instead, as the their names suggest, they only warn
the message out and returning undef. This can be handy for the
subroutine to print the error message and return immediately in one
step.

  sub turn_off {
      @_ >= 2 or return warn_hard('NAME', '$light');
      # process goes on
  }

The difference between the two is that warn_soft() only works when
B<$^W> holds true, while warn_hard() always works regardless of the
value of B<$^W>.

=cut

sub warn_hard   {
	cluck _usage((caller 1)[3], @_);
	return;
}

sub warn_soft   {
	cluck _usage((caller 1)[3], @_) if $^W;
	return;
}

=pod

The parse_fqpn() function is called internally. It takes a string
contains a fully qualified package name and returns pieces. Optionally
it accept numeric parameters that determine what it returns. By
default, it will just return the last part of the pieces, which is the
subroutine name in this case. Of course it doesn't know whether it's
really a subroutine name or other name from the symbol table or even
just a garbage.

  # get subroutine name: usage()
  my $sub = parse_fqpn('Usage::Sub::usage');

  # get the package name: Usage::Sub
  my $sub = parse_fqpn('Usage::Sub::usage', 1);

  # get both the package and sub name
  my($pack, $sub) = parse_fqpn('Usage::Sub::usage', 2);

  # get all pieces
  my(@parts) = parse_fqpn('Usage::Sub::usage', 3);

=cut

sub parse_fqpn {
	my($sub, $how) = @_;
	confess 'usage: parse_fqpn( FQPN [, HOW] )' unless $sub;
	$sub =~ /(.*)::(.*)/;
	return $2      unless $how;
	return $1      if     $how == 1;
	return($1, $2) if     $how == 2;
	my @packs = split /::/, $1;
	return(@packs, $2);
}

=head1 AUTHOR

Hasanuddin Tamir E<lt>hasant@trabas.comE<gt>

=head1 COPYRIGHT

Copyright (C) 2002 Trabas.  All rights reserved.

This program is free software. You may freely use it, modify
and/or distribute it under the same term as Perl itself.

=head1 SEE ALSO

L<perl>.

=cut


1;
__END__
