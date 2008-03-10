package MooseX::AttributeHelpers::MethodProvider::Array;
use Moose::Role;

our $VERSION   = '0.05';
our $AUTHORITY = 'cpan:STEVAN';

with 'MooseX::AttributeHelpers::MethodProvider::List';

sub push : method {
    my ($attr, $reader, $writer) = @_;
    
    if ($attr->has_type_constraint && $attr->type_constraint->isa('Moose::Meta::TypeConstraint::Parameterized')) {
        my $container_type_constraint = $attr->type_constraint->type_parameter;
        return sub { 
            my $instance = CORE::shift;
            $container_type_constraint->check($_) 
                || confess "Value " . ($_||'undef') . " did not pass container type constraint"
                    foreach @_;
            CORE::push @{$reader->($instance)} => @_; 
        };                    
    }
    else {
        return sub { 
            my $instance = CORE::shift;
            CORE::push @{$reader->($instance)} => @_; 
        };
    }
}

sub pop : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        CORE::pop @{$reader->($_[0])} 
    };
}

sub unshift : method {
    my ($attr, $reader, $writer) = @_;
    if ($attr->has_type_constraint && $attr->type_constraint->isa('Moose::Meta::TypeConstraint::Parameterized')) {
        my $container_type_constraint = $attr->type_constraint->type_parameter;
        return sub { 
            my $instance = CORE::shift;
            $container_type_constraint->check($_) 
                || confess "Value " . ($_||'undef') . " did not pass container type constraint"
                    foreach @_;
            CORE::unshift @{$reader->($instance)} => @_; 
        };                    
    }
    else {                
        return sub { 
            my $instance = CORE::shift;
            CORE::unshift @{$reader->($instance)} => @_; 
        };
    }
}

sub shift : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        CORE::shift @{$reader->($_[0])} 
    };
}
   
sub get : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        $reader->($_[0])->[$_[1]] 
    };
}

sub set : method {
    my ($attr, $reader, $writer) = @_;
    if ($attr->has_type_constraint && $attr->type_constraint->isa('Moose::Meta::TypeConstraint::Parameterized')) {
        my $container_type_constraint = $attr->type_constraint->type_parameter;
        return sub { 
            ($container_type_constraint->check($_[2])) 
                || confess "Value " . ($_[2]||'undef') . " did not pass container type constraint";
            $reader->($_[0])->[$_[1]] = $_[2]
        };                    
    }
    else {                
        return sub { 
            $reader->($_[0])->[$_[1]] = $_[2] 
        };
    }
}

sub clear : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        @{$reader->($_[0])} = ()
    };
}

sub delete : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        CORE::splice @{$reader->($_[0])}, $_[1], 1;
    }
}

sub insert : method {
    my ($attr, $reader, $writer) = @_;
    if ($attr->has_type_constraint && $attr->type_constraint->isa('Moose::Meta::TypeConstraint::Parameterized')) {
        my $container_type_constraint = $attr->type_constraint->type_parameter;
        return sub { 
            ($container_type_constraint->check($_[2])) 
                || confess "Value " . ($_[2]||'undef') . " did not pass container type constraint";
            CORE::splice @{$reader->($_[0])}, $_[1], 0, $_[2];
        };                    
    }
    else {                
        return sub { 
            CORE::splice @{$reader->($_[0])}, $_[1], 0, $_[2];
        };
    }    
}
 
1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::MethodProvider::Array
  
=head1 DESCRIPTION

This is a role which provides the method generators for 
L<MooseX::AttributeHelpers::Collection::Array>.

=head1 METHODS

=over 4

=item B<meta>

=back

=head1 PROVIDED METHODS

This module also consumes the B<List> method providers, to 
see those provied methods, refer to that documentation.

=over 4

=item B<get>

=item B<pop>

=item B<push>

=item B<set>

=item B<shift>

=item B<unshift>

=item B<clear>

=item B<delete>

=item B<insert>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
