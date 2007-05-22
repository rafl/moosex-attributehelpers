#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;

BEGIN {
    use_ok('MooseX::AttributeHelpers');   
}

{
    package Stuff;
    use Moose;

    has 'options' => (
        metaclass => 'Collection::Hash',
        is        => 'ro',
        isa       => 'HashRef[Str]',
        default   => sub { {} },
        provides  => {
            'set'   => 'set_option',
            'get'   => 'get_option',            
            'empty' => 'has_options',
            'count' => 'num_options',
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
];

ok(!$stuff->has_options, '... we have no options');
is($stuff->num_options, 0, '... we have no options');

is_deeply($stuff->options, {}, '... no options yet');

$stuff->set_option(foo => 'bar');

ok($stuff->has_options, '... we have options');
is($stuff->num_options, 1, '... we have 1 option(s)');
is_deeply($stuff->options, { foo => 'bar' }, '... got options now');

$stuff->set_option(bar => 'baz');

is($stuff->num_options, 2, '... we have 2 option(s)');
is_deeply($stuff->options, { foo => 'bar', bar => 'baz' }, '... got more options now');

is($stuff->get_option('foo'), 'bar', '... got the right option');



