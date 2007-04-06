
package MooseX::AttributeHelpers::Collection::Array;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';

my %METHOD_CONSTRUCTORS = (
    'push' => sub {
        my $attr = shift;
        return sub { 
            my $instance = shift;
            push @{$attr->get_value($instance)} => @_; 
        };
    },
    'pop' => sub {
        my $attr = shift;
        return sub { pop @{$attr->get_value($_[0])} };
    },    
    'unshift' => sub {
        my $attr = shift;
        return sub { 
            my $instance = shift;
            unshift @{$attr->get_value($instance)} => @_; 
        };
    },    
    'shift' => sub {
        my $attr = shift;
        return sub { shift @{$attr->get_value($_[0])} };
    },    
    'get' => sub {
        my $attr = shift;
        return sub { $attr->get_value($_[0])->[$_[1]] };
    },    
    'set' => sub {
        my $attr = shift;
        return sub { $attr->get_value($_[0])->[$_[1]] = $_[2] };
    },    
);

has 'provides' => (
    is       => 'ro',
    isa      => subtype('HashRef' => where { 
        (exists $METHOD_CONSTRUCTORS{$_} || return) for keys %{$_}; 1;
    }),
    required => 1,
);

has '+$!default'       => (required => 1);
has '+type_constraint' => (required => 1);

before '_process_options' => sub {
    my ($self, %options) = @_;
    
    if (exists $options{provides}) {
        (exists $options{isa})
            || confess "You must define a type with the Array metaclass";  
             
        (find_type_constraint($options{isa})->is_subtype_of('ArrayRef'))
            || confess "The type constraint for a Array must be a subtype of ArrayRef";
    }
};

after 'install_accessors' => sub {
    my $attr  = shift;
    my $class = $attr->associated_class;
    
    foreach my $key (keys %{$attr->provides}) {
        (exists $METHOD_CONSTRUCTORS{$key})
            || confess "Unsupported method type ($key)";
        $class->add_method(
            $attr->provides->{$key}, 
            $METHOD_CONSTRUCTORS{$key}->($attr)
        );
    }
};

no Moose;
no Moose::Util::TypeConstraints;

# register the alias ...
package Moose::Meta::Attribute::Custom::Collection;
sub register_implementation { 'MooseX::AttributeHelpers::Collection::Array' }


1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

  package Stuff;
  use Moose;
  
  has 'options' => (
      metaclass => 'Collection',
      is        => 'ro',
      isa       => 'ArrayRef',
      default   => sub { [] },
      provides  => {
          'push' => 'add_options',
          'pop'  => 'remove_last_option',
      }
  );

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