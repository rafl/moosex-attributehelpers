
package MooseX::AttributeHelpers::Collection;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'MooseX::AttributeHelpers::Base';

has 'container_type' => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_container_type',
);

has 'container_type_constraint' => (
    is      => 'rw',
    isa     => 'Moose::Meta::TypeConstraint',
    lazy    => 1,
    default => sub {
        my $self = shift;
        ($self->has_container_type)
            || confess "You cannot create a container_type_constraint if you dont have a container type";

        my $container_type = $self->container_type;
        my $constraint     = find_type_constraint($container_type);
        
	    $constraint = subtype(
	        'Object', 
	        sub { 
	            $_->isa($container_type) || ($_->can('does') && $_->does($container_type))
	        }
	    ) unless $constraint;            
        
        return $constraint;
    }
);

before 'process_options_for_provides' => sub {
    my ($self, $options) = @_;
    
    if (exists $options->{isa}) {
        my $type = $options->{isa};
        if ($type =~ /^(.*)\[(.*)\]$/) {
            my $core_type      = $1;
            my $container_type = $2;
            $options->{isa}            = $core_type;
            $options->{container_type} = $container_type;
        }
    }
};

no Moose;
no Moose::Util::TypeConstraints;

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
