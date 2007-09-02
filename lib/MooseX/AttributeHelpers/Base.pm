
package MooseX::AttributeHelpers::Base;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.02';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';

# this is the method map you define ...
has 'provides' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {{}}
);


# these next two are the possible methods 
# you can use in the 'provides' map.

# provide a Class or Role which we can 
# collect the method providers from 
has 'method_provider' => (
    is        => 'ro',
    isa       => 'ClassName',
    predicate => 'has_method_provider',
);

# or you can provide a HASH ref of anon subs
# yourself. This will also collect and store
# the methods from a method_provider as well 
has 'method_constructors' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return +{} unless $self->has_method_provider;
        # or grab them from the role/class
        my $method_provider = $self->method_provider->meta;
        return +{
            map { 
                $_ => $method_provider->get_method($_)
            } $method_provider->get_method_list
        };            
    },
);

# extend the parents stuff to make sure 
# certain bits are now required ...
has '+$!default'       => (required => 1);
has '+type_constraint' => (required => 1);

## Methods called prior to instantiation

sub helper_type { () }

sub process_options_for_provides {
    my ($self, $options) = @_;
    
    if (my $type = $self->helper_type) {
        (exists $options->{isa})
            || confess "You must define a type with the $type metaclass";  

        my $isa = $options->{isa};       

        unless (blessed($isa) && $isa->isa('Moose::Meta::TypeConstraint')) {
            $isa = find_type_constraint($isa);        
        }

        ($isa->is_a_type_of($type))
            || confess "The type constraint for a $type ($options->{isa}) must be a subtype of $type";
    }
}

before '_process_options' => sub {
    my ($self, $name, $options) = @_;
    if (exists $options->{provides} || 
        exists $options->{isa}      && $options->{isa} =~ /^.*?\[.*?\]$/) {
        $self->process_options_for_provides($options);
    }
};

## methods called after instantiation

# this confirms that provides has 
# all valid possibilities in it
sub check_provides_values {
    my $self = shift;
    
    my $method_constructors = $self->method_constructors;
    
    foreach my $key (keys %{$self->provides}) {
        (exists $method_constructors->{$key})
            || confess "$key is an unsupported method type";
    }
}

after 'install_accessors' => sub {
    my $attr  = shift;
    my $class = $attr->associated_class;
    
    # grab the reader and writer methods
    # as well, this will be useful for 
    # our method provider constructors
    my ($attr_reader, $attr_writer);
    if (my $reader = $attr->get_read_method) {    
        $attr_reader = $class->get_method($reader);
    }
    else {
        $attr_reader = sub { $attr->get_value(@_) };
    }
    
    if (my $writer = $attr->get_write_method) {    
        $attr_writer = $class->get_method($writer);
    }
    else {
        $attr_writer = sub { $attr->set_value(@_) };
    }        

    # before we install them, lets
    # make sure they are valid
    $attr->check_provides_values;    

    my $method_constructors = $attr->method_constructors;
    
    foreach my $key (keys %{$attr->provides}) {
        
        my $method_name = $attr->provides->{$key};       
        my $method_body = $method_constructors->{$key}->(
            $attr,
            $attr_reader,
            $attr_writer,            
        );
        
        if ($class->has_method($method_name)) {
            confess "The method ($method_name) already exists in class (" . $class->name . ")";
        }
        
        $class->add_method($method_name => 
            MooseX::AttributeHelpers::Meta::Method::Provided->wrap(
                $method_body,
            )
        );
    }
};

no Moose;
no Moose::Util::TypeConstraints;

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::Base - Base class for attribute helpers
  
=head1 DESCRIPTION

Documentation to come.

=head1 ATTRIBUTES

=over 4

=item B<provides>

=item B<method_provider>

=item B<method_constructors>

=back

=head1 EXTENDED ATTRIBUTES

=over 4

=item B<$!default>

C<$!default> is now required.

=item B<type_constraint>

C<type_constraint> is now required.

=back

=head1 METHODS

=over 4

=item B<helper_type>

=item B<check_provides_values>

=item B<has_default>

=item B<has_method_provider>

=item B<has_type_constraint>

=item B<install_accessors>

=item B<process_options_for_provides>

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
