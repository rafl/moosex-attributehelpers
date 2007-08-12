
package MooseX::AttributeHelpers;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use MooseX::AttributeHelpers::Meta::Method::Provided;

use MooseX::AttributeHelpers::Counter;
use MooseX::AttributeHelpers::Number;
use MooseX::AttributeHelpers::Collection::Array;
use MooseX::AttributeHelpers::Collection::Hash;

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers - Extend your attribute interfaces

=head1 SYNOPSIS

  package MyClass;
  use Moose;

  has mapping => (
      metaclass => 'Collection::Hash',
      is        => 'rw',
      isa       => 'HashRef',
      default   => sub { {} },
      provides  => {
          exists    => 'exists_in_mapping',
          keys      => 'ids_in_mapping',
          get       => 'get_mapping',
          set       => 'set_mapping',
      },
  );

  # ...

  my $obj = MyClass->new;
  $obj->set_mapping(4, 'foo');
  $obj->set_mapping(5, 'bar');
  $obj->set_mapping(6, 'baz');

  # prints 'bar'
  print $obj->get_mapping(5) if $obj->exists_in_mapping(5);

  # prints '4, 5, 6'
  print join ', ', $obj->ids_in_mapping;

=head1 DESCRIPTION

While L<Moose> attributes provide you with a way to name your accessors,
readers, writers, clearers and predicates, this library provides commonly
used attribute helper methods for more specific types of data.

As seen in the L</SYNOPSIS>, you specify the extension via the 
C<metaclass> parameter. Available meta classes are:

=over

=item L<Number|MooseX::AttributeHelpers::Number>

Common numerical operations.

=item L<Counter|MooseX::AttributeHelpers::Counter>

Methods for incrementing and decrementing a counter attribute.

=item L<Collection::Hash|MooseX::AttributeHelpers::Collection::Hash>

Common methods for hash references.

=item L<Collection::Array|MooseX::AttributeHelpers::Collection::Array>

Common methods for array references.

=back

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
