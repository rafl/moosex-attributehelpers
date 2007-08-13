#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('MooseX::AttributeHelpers');   
}

{
    package Stuff;
    use Moose;
    use MooseX::AttributeHelpers;

    has 'options' => (
        metaclass => 'Collection::Hash',
        is        => 'ro',
        isa       => 'HashRef[Str]',
        default   => sub { {} },
        provides  => {
            'set'    => 'set_option',
            'get'    => 'get_option',            
            'empty'  => 'has_options',
            'count'  => 'num_options',
            'delete' => 'delete_option',
        }
    );
}

my $stuff = Stuff->new();
isa_ok($stuff, 'Stuff');

can_ok($stuff, $_) for qw[
    set_option
    get_option
    has_options
    num_options
    delete_option
];

ok(!$stuff->has_options, '... we have no options');
is($stuff->num_options, 0, '... we have no options');

is_deeply($stuff->options, {}, '... no options yet');

lives_ok {
    $stuff->set_option(foo => 'bar');
} '... set the option okay';

ok($stuff->has_options, '... we have options');
is($stuff->num_options, 1, '... we have 1 option(s)');
is_deeply($stuff->options, { foo => 'bar' }, '... got options now');

lives_ok {
    $stuff->set_option(bar => 'baz');
} '... set the option okay';

is($stuff->num_options, 2, '... we have 2 option(s)');
is_deeply($stuff->options, { foo => 'bar', bar => 'baz' }, '... got more options now');

is($stuff->get_option('foo'), 'bar', '... got the right option');

lives_ok {
    $stuff->delete_option('bar');
} '... deleted the option okay';

is($stuff->num_options, 1, '... we have 1 option(s)');
is_deeply($stuff->options, { foo => 'bar' }, '... got more options now');

lives_ok {
    Stuff->new(options => { foo => 'BAR' });
} '... good constructor params';

## check some errors

dies_ok {
    $stuff->set_option(bar => {});
} '... could not add a hash ref where an string is expected';

dies_ok {
    Stuff->new(options => { foo => [] });
} '... bad constructor params';


