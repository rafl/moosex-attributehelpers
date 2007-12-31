package MooseX::AttributeHelpers::MethodProvider::Hash;
use Moose::Role;

our $VERSION   = '0.03';
our $AUTHORITY = 'cpan:STEVAN';

with 'MooseX::AttributeHelpers::MethodProvider::ImmutableHash';

sub set : method {
    my ($attr, $reader, $writer) = @_;
    if ($attr->has_type_constraint && $attr->type_constraint->isa('Moose::Meta::TypeConstraint::Parameterized')) {
        my $container_type_constraint = $attr->type_constraint->type_parameter;
        return sub { 
            my ( $self, @kvp ) = @_;
           
            my ( @keys, @values );

            while ( @kvp ) {
                my ( $key, $value ) = ( shift(@kvp), shift(@kvp) );
                ($container_type_constraint->check($value)) 
                    || confess "Value " . ($value||'undef') . " did not pass container type constraint";
                push @keys, $key;
                push @values, $value;
            }

            if ( @values > 1 ) {
                @{ $reader->($self) }{@keys} = @values;
            } else {
                $reader->($self)->{$keys[0]} = $values[0];
            }
        };
    }
    else {
        return sub {
            if ( @_ == 3 ) {
                $reader->($_[0])->{$_[1]} = $_[2]
            } else {
                my ( $self, @kvp ) = @_;
                my ( @keys, @values );

                while ( @kvp ) {
                    push @keys, shift @kvp;
                    push @values, shift @kvp;
                }

                @{ $reader->($_[0]) }{@keys} = {@values};
            }
        };
    }
}

sub clear : method {
    my ($attr, $reader, $writer) = @_;
    return sub { %{$reader->($_[0])} = () };
}

sub delete : method {
    my ($attr, $reader, $writer) = @_;
    return sub { CORE::delete $reader->($_[0])->{$_[1]} };
}

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::MethodProvider::Hash
  
=head1 DESCRIPTION

This is a role which provides the method generators for 
L<MooseX::AttributeHelpers::Collection::Hash>.

This role is composed from the 
L<MooseX::AttributeHelpers::Collection::ImmutableHash> role.

=head1 METHODS

=over 4

=item B<meta>

=back

=head1 PROVIDED METHODS

=over 4

=item B<count>

=item B<delete>

=item B<empty>

=item B<clear>

=item B<exists>

=item B<get>

=item B<keys>

=item B<set>

=item B<values>

=item B<kv>

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

