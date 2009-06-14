
package MooseX::AttributeHelpers::Counter;
use Moose;

our $VERSION   = '0.19';
$VERSION = eval $VERSION;
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';
with 'MooseX::AttributeHelpers::Trait::Counter';

no Moose;

# register the alias ...
package # hide me from search.cpan.org
    Moose::Meta::Attribute::Custom::Counter;
sub register_implementation { 'MooseX::AttributeHelpers::Counter' }

1;
