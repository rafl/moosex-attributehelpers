
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

=cut