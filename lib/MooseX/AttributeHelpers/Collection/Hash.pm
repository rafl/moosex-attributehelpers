
package MooseX::AttributeHelpers::Collection::Hash;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'MooseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            'get' => sub {
                my $attr = shift;
                return sub { $attr->get_value($_[0])->{$_[1]} };
            },    
            'set' => sub {
                my $attr = shift;
                return sub { $attr->get_value($_[0])->{$_[1]} = $_[2] };
            },    
            'count' => sub {
                my $attr = shift;
                return sub { scalar keys %{$attr->get_value($_[0])} };        
            },
            'empty' => sub {
                my $attr = shift;
                return sub { scalar keys %{$attr->get_value($_[0])} ? 1 : 0 };        
            }
        }
    }
);

sub _process_options_for_provides {
    my ($self, $options) = @_;    
    (exists $options->{isa})
        || confess "You must define a type with the Hash metaclass";  
         
    (find_type_constraint($options->{isa})->is_a_type_of('HashRef'))
        || confess "The type constraint for a Hash ($options->{isa}) must be a subtype of HashRef";
}

no Moose;
no Moose::Util::TypeConstraints;

# register the alias ...
package Moose::Meta::Attribute::Custom::Collection::Hash;
sub register_implementation { 'MooseX::AttributeHelpers::Collection::Hash' }


1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

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