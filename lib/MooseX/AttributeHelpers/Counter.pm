
package MooseX::AttributeHelpers::Counter;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';

my %METHOD_CONSTRUCTORS = (
    inc => sub {
        my $attr = shift;
        return sub { $attr->set_value($_[0], $attr->get_value($_[0]) + 1) };
    },
    dec => sub {
        my $attr = shift;
        return sub { $attr->set_value($_[0], $attr->get_value($_[0]) - 1) };        
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
            || confess "You must define a type with the Counter metaclass";  
             
        (find_type_constraint($options{isa})->is_subtype_of('Num'))
            || confess "The type constraint for a Counter must be a subtype of Num";
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
package Moose::Meta::Attribute::Custom::Counter;
sub register_implementation { 'MooseX::AttributeHelpers::Counter' }

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::Counter

=head1 SYNOPSIS

  package MyHomePage;
  use Moose;
  
  has 'counter' => (
      metaclass => 'Counter',
      is        => 'rw',
      isa       => 'Int',
      default   => sub { 0 },
      provides  => {
          inc => 'inc_counter',
      }
  );

  my $page = MyHomePage->new();
  $page->inc_counter; # same as $page->counter($page->counter + 1);
  
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