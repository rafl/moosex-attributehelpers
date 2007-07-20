package MooseX::AttributeHelpers::MethodProvider::Hash;
use Moose::Role;

sub exists : method {
    my ($attr) = @_;    
    return sub { exists $attr->get_value($_[0])->{$_[1]} ? 1 : 0 };
}   

sub get : method {
    my ($attr) = @_;    
    return sub { $attr->get_value($_[0])->{$_[1]} };
}  

sub set : method {
    my ($attr) = @_;
    if ($attr->has_container_type) {
        my $container_type_constraint = $attr->container_type_constraint;
        return sub { 
            ($container_type_constraint->check($_[2])) 
                || confess "Value " . ($_[2]||'undef') . " did not pass container type constraint";                        
            $attr->get_value($_[0])->{$_[1]} = $_[2] 
        };
    }
    else {
        return sub { $attr->get_value($_[0])->{$_[1]} = $_[2] };
    }
}

sub keys : method {
    my ($attr) = @_;
    return sub { keys %{$attr->get_value($_[0])} };        
}
     
sub values : method {
    my ($attr) = @_;
    return sub { values %{$attr->get_value($_[0])} };        
}   
   
sub count : method {
    my ($attr) = @_;
    return sub { scalar keys %{$attr->get_value($_[0])} };        
}

sub empty : method {
    my ($attr) = @_;
    return sub { scalar keys %{$attr->get_value($_[0])} ? 1 : 0 };        
}

sub delete : method {
    my ($attr) = @_;
    return sub { delete $attr->get_value($_[0])->{$_[1]} };
}

1;

__END__