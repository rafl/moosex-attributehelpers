
package MooseX::AttributeHelpers::Base;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.04';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';

# this is the method map you define ...
has 'provides' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {{}}
);

has 'curries' => (
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
            $isa = Moose::Util::TypeConstraints::find_or_create_type_constraint($isa);
        }

        ($isa->is_a_type_of($type))
            || confess "The type constraint for a $type ($options->{isa}) must be a subtype of $type";
    }
}

before '_process_options' => sub {
    my ($self, $name, $options) = @_;
    $self->process_options_for_provides($options, $name);
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

sub _curry {
    my $self = shift;
    my $code = shift;

    #warn "_curry: "; use DDS; warn Dump($self);
    my @args = @_;
    return sub { my $self = shift; $code->($self, @args, @_) };
}

after 'install_accessors' => sub {
    my $attr  = shift;
    my $class = $attr->associated_class;

    # grab the reader and writer methods
    # as well, this will be useful for
    # our method provider constructors
    my $attr_reader = $attr->get_read_method_ref;
    my $attr_writer = $attr->get_write_method_ref;


    # before we install them, lets
    # make sure they are valid
    $attr->check_provides_values;
#    $attr->check_curries_values;

    my $method_constructors = $attr->method_constructors;

    my $class_name = $class->name;

    foreach my $key (keys %{$attr->curries}) {

        my ($curried_name, @curried_args) = @{ $attr->curries->{$key} };

        if ($class->has_method($curried_name)) {
            confess "The method ($curried_name) already exists in class (" . $class->name . ")";
        }

        my $method = MooseX::AttributeHelpers::Meta::Method::Curried->wrap(
            $attr->_curry($method_constructors->{$key}->(
                $attr,
                $attr_reader,
                $attr_writer,
            ), @curried_args),
            package_name => $class_name,
            name => $curried_name,
        );
        
#use DDS; warn Dump($method);

        $attr->associate_method($method);
        $class->add_method($curried_name => $method);
    }

    foreach my $key (keys %{$attr->provides}) {

        my $method_name = $attr->provides->{$key};

        if ($class->has_method($method_name)) {
            confess "The method ($method_name) already exists in class (" . $class->name . ")";
        }

        my $method = MooseX::AttributeHelpers::Meta::Method::Provided->wrap(
            $method_constructors->{$key}->(
                $attr,
                $attr_reader,
                $attr_writer,
            ),
            package_name => $class_name,
            name => $method_name,
        );
        
        $attr->associate_method($method);
        $class->add_method($method_name => $method);
    }
};

after 'remove_accessors' => sub {
    my $attr  = shift;
    my $class = $attr->associated_class;
    foreach my $key (keys %{$attr->provides}) {
        my $method_name = $attr->provides->{$key};
        my $method = $class->get_method($method_name);
        $class->remove_method($method_name)
            if blessed($method) &&
               $method->isa('MooseX::AttributeHelpers::Meta::Method::Provided');
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

=item B<meta>

=item B<helper_type>

=item B<check_provides_values>

=item B<has_default>

=item B<has_method_provider>

=item B<has_type_constraint>

=item B<install_accessors>

=item B<remove_accessors>

=item B<process_options_for_provides>

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
