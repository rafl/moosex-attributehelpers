
package MooseX::AttributeHelpers::Collection::Array;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'MooseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            'push' => sub {
                my $attr = shift;
                return sub { 
                    my $instance = shift;
                    push @{$attr->get_value($instance)} => @_; 
                };
            },
            'pop' => sub {
                my $attr = shift;
                return sub { pop @{$attr->get_value($_[0])} };
            },    
            'unshift' => sub {
                my $attr = shift;
                return sub { 
                    my $instance = shift;
                    unshift @{$attr->get_value($instance)} => @_; 
                };
            },    
            'shift' => sub {
                my $attr = shift;
                return sub { shift @{$attr->get_value($_[0])} };
            },    
            'get' => sub {
                my $attr = shift;
                return sub { $attr->get_value($_[0])->[$_[1]] };
            },    
            'set' => sub {
                my $attr = shift;
                return sub { $attr->get_value($_[0])->[$_[1]] = $_[2] };
            },    
            'count' => sub {
                my $attr = shift;
                return sub { scalar @{$attr->get_value($_[0])} };        
            },
            'empty' => sub {
                my $attr = shift;
                return sub { scalar @{$attr->get_value($_[0])} ? 1 : 0 };        
            }
        }
    }
);

sub _process_options_for_provides {
    my ($self, $options) = @_;
    (exists $options->{isa})
        || confess "You must define a type with the Array metaclass";  

    my $isa = $options->{isa}; 

    unless (blessed($isa) && $isa->isa('Moose::Meta::TypeConstraint')) {
        $isa = find_type_constraint($isa);        
    }

    ($isa->is_a_type_of('ArrayRef'))
        || confess "The type constraint for a Array ($options->{isa}) must be a subtype of ArrayRef";
}

no Moose;
no Moose::Util::TypeConstraints;;

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
      isa       => 'ArrayRef',
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
