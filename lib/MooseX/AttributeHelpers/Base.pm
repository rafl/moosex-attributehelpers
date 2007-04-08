
package MooseX::AttributeHelpers::Base;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';

has 'method_constructors' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} }
);

has 'provides' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
);

has '+$!default'       => (required => 1);
has '+type_constraint' => (required => 1);

sub _check_provides {
    my ($self, $provides) = @_;
    my $method_constructors = $self->method_constructors;
    foreach my $key (keys %$provides) {
        (exists $method_constructors->{$key})
            || confess "$key is an unsupported method type";
    }
}

sub _process_options_for_provides {
    my ($self, $options) = @_;
    # ...
}

before '_process_options' => sub {
    my ($self, %options) = @_;
    
    if (exists $options{provides}) {
        $self->_check_provides($options{provides});
        $self->_process_options_for_provides(\%options);
    }
};

after 'install_accessors' => sub {
    my $attr  = shift;
    my $class = $attr->associated_class;

    my $method_constructors = $attr->method_constructors;
    
    foreach my $key (keys %{$attr->provides}) {
        $class->add_method(
            $attr->provides->{$key}, 
            $method_constructors->{$key}->($attr)
        );
    }
};

no Moose;
no Moose::Util::TypeConstraints;


1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::Base

=head1 SYNOPSIS
  
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