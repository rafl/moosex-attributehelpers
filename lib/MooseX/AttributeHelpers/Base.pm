
package MooseX::AttributeHelpers::Base;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';

has 'method_constructors' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} }
);

has 'provides' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
);

# extend the parents stuff to make sure 
# certain bits are now required ...
has '+$!default'       => (required => 1);
has '+type_constraint' => (required => 1);

## Methods called prior to instantiation

sub helper_type { () }

sub process_options_for_provides {
    my ($self, $options) = @_;
    
    if (my $type = $self->helper_type) {
        (exists $options->{isa})
            || confess "You must define a type with the $type metaclass";  

        my $isa = $options->{isa};       

        unless (blessed($isa) && $isa->isa('Moose::Meta::TypeConstraint')) {
            $isa = find_type_constraint($isa);        
        }

        ($isa->is_a_type_of($type))
            || confess "The type constraint for a $type ($options->{isa}) must be a subtype of $type";
    }
}

before '_process_options' => sub {
    my ($self, $name, $options) = @_;
    if (exists $options->{provides}) {
        $self->process_options_for_provides($options);
    }
};

## methods called after instantiation

# this confirms that provides has 
# all valid possibilities in it
sub check_provides_values {
    my $self = shift;
    my $method_constructors = $self->method_constructors;
    foreach my $key (keys %{$self->provides}) {
        (exists $method_constructors->{$key})
            || confess "$key is an unsupported method type";
    }
}

after 'install_accessors' => sub {
    my $attr  = shift;
    my $class = $attr->associated_class;

    # before we install them, lets
    # make sure they are valid
    $attr->check_provides_values;    

    my $method_constructors = $attr->method_constructors;
    
    foreach my $key (keys %{$attr->provides}) {
        
        my $method_name = $attr->provides->{$key};
        my $method_body = $method_constructors->{$key}->($attr);
        
        if ($class->has_method($method_name)) {
            confess "The method ($method_name) already exists in class (" . $class->name . ")";
        }
        
        $class->add_method($method_name => 
            MooseX::AttributeHelpers::Meta::Method::Provided->wrap(
                $method_body,
            )
        );
    }
};

no Moose;
no Moose::Util::TypeConstraints;

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::Base

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
