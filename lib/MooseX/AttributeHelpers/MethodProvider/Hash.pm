package MooseX::AttributeHelpers::MethodProvider::Hash;
use Moose::Role;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub exists : method {
    my ($attr, $reader, $writer) = @_;    
    return sub { exists $reader->($_[0])->{$_[1]} ? 1 : 0 };
}   

sub get : method {
    my ($attr, $reader, $writer) = @_;    
    return sub { $reader->($_[0])->{$_[1]} };
}  

sub set : method {
    my ($attr, $reader, $writer) = @_;
    if ($attr->has_container_type) {
        my $container_type_constraint = $attr->container_type_constraint;
        return sub { 
            ($container_type_constraint->check($_[2])) 
                || confess "Value " . ($_[2]||'undef') . " did not pass container type constraint";                        
            $reader->($_[0])->{$_[1]} = $_[2] 
        };
    }
    else {
        return sub { $reader->($_[0])->{$_[1]} = $_[2] };
    }
}

sub keys : method {
    my ($attr, $reader, $writer) = @_;
    return sub { keys %{$reader->($_[0])} };        
}
     
sub values : method {
    my ($attr, $reader, $writer) = @_;
    return sub { values %{$reader->($_[0])} };        
}   
   
sub count : method {
    my ($attr, $reader, $writer) = @_;
    return sub { scalar keys %{$reader->($_[0])} };        
}

sub empty : method {
    my ($attr, $reader, $writer) = @_;
    return sub { scalar keys %{$reader->($_[0])} ? 1 : 0 };        
}

sub delete : method {
    my ($attr, $reader, $writer) = @_;
    return sub { delete $reader->($_[0])->{$_[1]} };
}

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::MethodProvider::Hash
  
=head1 DESCRIPTION

This is a role which provides the method generators for 
L<MooseX::AttributeHelpers::Collection::Hash>.

=head1 METHODS

=over 4

=item B<meta>

=back

=head1 PROVIDED METHODS

=over 4

=item B<count>

=item B<delete>

=item B<empty>

=item B<exists>

=item B<get>

=item B<keys>

=item B<set>

=item B<values>

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

