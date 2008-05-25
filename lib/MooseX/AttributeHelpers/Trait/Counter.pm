
package MooseX::AttributeHelpers::Trait::Counter;
use Moose::Role;

with 'MooseX::AttributeHelpers::Trait::Base'
  => { excludes => ['method_provider'] };

our $VERSION   = '0.03';
our $AUTHORITY = 'cpan:STEVAN';

use MooseX::AttributeHelpers::MethodProvider::Counter;

has 'method_provider' => (
    is        => 'ro',
    isa       => 'ClassName',
    predicate => 'has_method_provider',
    default   => 'MooseX::AttributeHelpers::MethodProvider::Counter',
);

sub helper_type { 'Num' }

before 'process_options_for_provides' => sub {
    my ($self, $options, $name) = @_;

    # Set some default attribute options here unless already defined
    if ((my $type = $self->helper_type) && !exists $options->{isa}){
        $options->{isa} = $type;
    }

    $options->{is}      = 'ro' unless exists $options->{is};
    $options->{default} = 0    unless exists $options->{default};
};

after 'check_provides_values' => sub {
    my $self     = shift;
    my $provides = $self->provides;

    unless (scalar keys %$provides) {
        my $method_constructors = $self->method_constructors;
        my $attr_name           = $self->name;

        foreach my $method (keys %$method_constructors) {
            $provides->{$method} = ($method . '_' . $attr_name);
        }
    }
};

no Moose::Role;

# register the alias ...
package # hide me from search.cpan.org
    Moose::Meta::Attribute::Custom::Trait::Counter;
sub register_implementation { 'MooseX::AttributeHelpers::Trait::Counter' }

1;

