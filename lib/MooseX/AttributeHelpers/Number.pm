package MooseX::AttributeHelpers::Number;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'MooseX::AttributeHelpers::Base';

sub helper_type { 'Num' }

has '+method_constructors' => (
    default => sub {
        return +{
            set => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], $_[1]) };
            },
            add => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], $attr->get_value($_[0]) + $_[1]) };
            },
            sub => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], $attr->get_value($_[0]) - $_[1]) };
            },
            mul => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], $attr->get_value($_[0]) * $_[1]) };
            },
            div => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], $attr->get_value($_[0]) / $_[1]) };
            },
            mod => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], abs($attr->get_value($_[0]) % $_[1])) };
            },
            abs => sub {
                my $attr = shift;
                return sub { $attr->set_value($_[0], abs($attr->get_value($_[0])) ) };
            },
        }
    }
);
    
no Moose;

# register the alias ...
package Moose::Meta::Attribute::Custom::Number;
sub register_implementation { 'MooseX::AttributeHelpers::Number' }

1;

=pod

=head1 NAME

MooseX::AttributeHelpers::Number

=head1 SYNOPSIS
  
  package Real;
   use Moose;

   has 'integer' => (
       metaclass => 'Number',
       is        => 'ro',
       isa       => 'Int',
       default   => sub { 5 },
       provides  => {
           set => 'set',
           add => 'add',
           sub => 'sub',
           mul => 'mul',
           div => 'div',
           mod => 'mod',
           abs => 'abs',
       }
   );

  my $real = Real->new();
  $real->add(5); # same as $real->integer($real->integer + 5);
  $real->sub(2); # same as $real->integer($real->integer - 2);  
  
=head1 DESCRIPTION

=head1 METHODS

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Robert Boone

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut