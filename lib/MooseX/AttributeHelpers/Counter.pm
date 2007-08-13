
package MooseX::AttributeHelpers::Counter;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use MooseX::AttributeHelpers::MethodProvider::Counter;

extends 'MooseX::AttributeHelpers::Base';

has '+method_provider' => (
    default => 'MooseX::AttributeHelpers::MethodProvider::Counter'
);

sub helper_type { 'Num' }
    
no Moose;

# register the alias ...
package Moose::Meta::Attribute::Custom::Counter;
sub register_implementation { 'MooseX::AttributeHelpers::Counter' }

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::Counter

=head1 SYNOPSIS

  package MyHomePage;
  use Moose;
  use MooseX::AttributeHelpers;
  
  has 'counter' => (
      metaclass => 'Counter',
      is        => 'rw',
      isa       => 'Int',
      default   => sub { 0 },
      provides  => {
          inc => 'inc_counter',
          dec => 'dec_counter',          
      }
  );

  my $page = MyHomePage->new();
  $page->inc_counter; # same as $page->counter($page->counter + 1);
  $page->dec_counter; # same as $page->counter($page->counter - 1);  
  
=head1 DESCRIPTION

This module provides a simple counter attribute, which can be 
incremented and decremeneted. 

=head1 METHODS

=over 4

=item B<method_provider>

=item B<has_method_provider>

=item B<helper_type>

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