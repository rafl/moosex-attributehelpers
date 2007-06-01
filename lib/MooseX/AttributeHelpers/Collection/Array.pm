
package MooseX::AttributeHelpers::Collection::Array;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use MooseX::AttributeHelpers::MethodProvider::Array;

extends 'MooseX::AttributeHelpers::Collection';

has '+method_provider' => (
    default => 'MooseX::AttributeHelpers::MethodProvider::Array'
);

sub helper_type { 'ArrayRef' }

no Moose;

# register the alias ...
package Moose::Meta::Attribute::Custom::Collection::Array;
sub register_implementation { 'MooseX::AttributeHelpers::Collection::Array' }


1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

  package Stuff;
  use Moose;
  
  has 'options' => (
      metaclass => 'Collection',
      is        => 'ro',
      isa       => 'ArrayRef[Int]',
      default   => sub { [] },
      provides  => {
          'push' => 'add_options',
          'pop'  => 'remove_last_option',
      }
  );

=head1 DESCRIPTION

=head1 METHODS

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
