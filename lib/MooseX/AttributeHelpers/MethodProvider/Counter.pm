
package MooseX::AttributeHelpers::MethodProvider::Counter;
use Moose::Role;

sub inc {
    my $attr = shift;
    return sub { $attr->set_value($_[0], $attr->get_value($_[0]) + 1) };
}

sub dec {
    my $attr = shift;
    return sub { $attr->set_value($_[0], $attr->get_value($_[0]) - 1) };        
}

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::MethodProvider::Counter
  
=head1 DESCRIPTION

This is a role which provides the method generators for 
L<MooseX::AttributeHelpers::Counter>.

=head1 METHODS

=over 4

=item B<meta>

=back

=head1 PROVIDED METHODS

=over 4

=item B<inc>

=item B<dec>

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
