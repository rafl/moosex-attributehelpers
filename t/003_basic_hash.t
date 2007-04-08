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
        isa       => 'HashRef',
        default   => sub { {} },
        provides  => {
            'set' => 'set_option',
            'get' => 'get_option',            
        }
    );
}

my $stuff = Stuff->new();
isa_ok($stuff, 'Stuff');

is_deeply($stuff->options, {}, '... no options yet');

$stuff->set_option(foo => 'bar');
is_deeply($stuff->options, { foo => 'bar' }, '... got options now');

$stuff->set_option(bar => 'baz');
is_deeply($stuff->options, { foo => 'bar', bar => 'baz' }, '... got more options now');

is($stuff->get_option('foo'), 'bar', '... got the right option');



