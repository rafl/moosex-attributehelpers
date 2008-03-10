package MooseX::AttributeHelpers::MethodProvider::List;
use Moose::Role;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';
 
sub count : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        scalar @{$reader->($_[0])} 
    };        
}

sub empty : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        scalar @{$reader->($_[0])} ? 1 : 0 
    };        
}

sub find : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $predicate) = @_;
        foreach my $val (@{$reader->($instance)}) {
            return $val if $predicate->($val);
        }
        return;
    };
}

sub map : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $f) = @_;
        CORE::map { $f->($_) } @{$reader->($instance)}
    };
}

sub grep : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $predicate) = @_;
        CORE::grep { $predicate->($_) } @{$reader->($instance)}
    };
}

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::MethodProvider::List
  
=head1 DESCRIPTION

This is a role which provides the method generators for 
L<MooseX::AttributeHelpers::Collection::List>.

=head1 METHODS

=over 4

=item B<meta>

=back

=head1 PROVIDED METHODS

=over 4

=item B<count>

=item B<empty>

=item B<find>

=item B<grep>

=item B<map>

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
