
package MooseX::AttributeHelpers::Counter;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'MooseX::AttributeHelpers::Base';

sub helper_type { 'Num' }

has '+method_constructors' => (
    default => sub {
        return +{
            inc => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], $attr->get_value($_[0]) + 1) };
            },
            dec => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], $attr->get_value($_[0]) - 1) };        
            },
        }
    }
);
    
no Moose;
no Moose::Util::TypeConstraints;

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
  
  has 'counter' => (
      metaclass => 'Counter',
      is        => 'rw',
      isa       => 'Int',
      default   => sub { 0 },
      provides  => {
          inc => 'inc_counter',
      }
  );

  my $page = MyHomePage->new();
  $page->inc_counter; # same as $page->counter($page->counter + 1);
  
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