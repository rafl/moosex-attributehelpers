package MooseX::AttributeHelpers::MethodProvider::Array;
use Moose::Role;

sub push : method {
    my ($attr) = @_;
    if ($attr->has_container_type) {
        my $container_type_constraint = $attr->container_type_constraint;
        return sub { 
            my $instance = CORE::shift;
            $container_type_constraint->check($_) 
                || confess "Value " . ($_||'undef') . " did not pass container type constraint"
                    foreach @_;
            CORE::push @{$attr->get_value($instance)} => @_; 
        };                    
    }
    else {
        return sub { 
            my $instance = CORE::shift;
            CORE::push @{$attr->get_value($instance)} => @_; 
        };
    }
}

sub pop : method {
    my ($attr) = @_;
    return sub { 
        CORE::pop @{$attr->get_value($_[0])} 
    };
}

sub unshift : method {
    my ($attr) = @_;
    if ($attr->has_container_type) {
        my $container_type_constraint = $attr->container_type_constraint;
        return sub { 
            my $instance = CORE::shift;
            $container_type_constraint->check($_) 
                || confess "Value " . ($_||'undef') . " did not pass container type constraint"
                    foreach @_;
            CORE::unshift @{$attr->get_value($instance)} => @_; 
        };                    
    }
    else {                
        return sub { 
            my $instance = CORE::shift;
            CORE::unshift @{$attr->get_value($instance)} => @_; 
        };
    }
}

sub shift : method {
    my ($attr) = @_;
    return sub { 
        CORE::shift @{$attr->get_value($_[0])} 
    };
}
   
sub get : method {
    my ($attr) = @_;
    return sub { 
        $attr->get_value($_[0])->[$_[1]] 
    };
}

sub set : method {
    my ($attr) = @_;
    if ($attr->has_container_type) {
        my $container_type_constraint = $attr->container_type_constraint;
        return sub { 
            ($container_type_constraint->check($_[2])) 
                || confess "Value " . ($_[2]||'undef') . " did not pass container type constraint";
            $attr->get_value($_[0])->[$_[1]] = $_[2]
        };                    
    }
    else {                
        return sub { 
            $attr->get_value($_[0])->[$_[1]] = $_[2] 
        };
    }
}
 
sub count : method {
    my ($attr) = @_;
    return sub { 
        scalar @{$attr->get_value($_[0])} 
    };        
}

sub empty : method {
    my ($attr) = @_;
    return sub { 
        scalar @{$attr->get_value($_[0])} ? 1 : 0 
    };        
}

sub find : method {
    my ($attr) = @_;
    return sub {
        my ($instance, $predicate) = @_;
        foreach my $val (@{$attr->get_value($instance)}) {
            return $val if $predicate->($val);
        }
        return;
    };
}

1;

__END__

=pod

=cut
