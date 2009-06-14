package MooseX::AttributeHelpers::Bool;
use Moose;

our $VERSION   = '0.19';
$VERSION = eval $VERSION;
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';
with 'MooseX::AttributeHelpers::Trait::Bool';

no Moose;

# register the alias ...
package # hide me from search.cpan.org
    Moose::Meta::Attribute::Custom::Bool;
sub register_implementation { 'MooseX::AttributeHelpers::Bool' }

1;
