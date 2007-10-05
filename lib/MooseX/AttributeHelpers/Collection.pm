
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
    is  => 'rw',
    isa => 'Moose::Meta::TypeConstraint',
);

before 'process_options_for_provides' => sub {
    my ($self, $options) = @_; 
    
    if (exists $options->{isa}) {
        my $type = $options->{isa};
        
        # ... we should check if the type exists already
        # and then we should use it,.. however, this means
        # we need to extract the container type constraint
        # as well, which is a little trickier
        
        if ($type =~ /^(.*)\[(.*)\]$/) {
            my $core_type      = $1;
            my $container_type = $2;
            
            $options->{container_type} = $container_type;
            
            my $container_type_constraint = find_type_constraint($container_type);
 
            # NOTE:
            # I am not sure DWIM-ery is a good thing
            # here, so i am going to err on the side 
            # of caution, and blow up if you have
            # not made a type constraint for this yet.
            # - SL
            (defined $container_type_constraint)
                || confess "You must predefine the '$container_type' constraint before you can use it as a container type";            

            $options->{container_type_constraint} = $container_type_constraint;
                        
            if ($core_type eq 'ArrayRef') {
                $options->{isa} = subtype('ArrayRef' => where {
                    foreach my $x (@$_) { ($container_type_constraint->check($x)) || return } 1;
                });
            }
            elsif ($core_type eq 'HashRef') {
                $options->{isa} = subtype('HashRef' => where {
                    foreach my $x (values %$_) { ($container_type_constraint->check($x)) || return } 1;
                });           
            }
            else {
                confess "Your isa must be either ArrayRef or HashRef (sorry no subtype support yet)";
            }
        }
    }
};

no Moose;
no Moose::Util::TypeConstraints;

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::Collection - Base class for all collection type helpers

=head1 DESCRIPTION

Documentation to come.

=head1 METHODS

=over 4

=item B<meta>

=item B<container_type>

=item B<container_type_constraint>

=item B<has_container_type>

=item B<process_options_for_provides>

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
