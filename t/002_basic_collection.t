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
        metaclass => 'Collection::Array',
        is        => 'ro',
        isa       => 'ArrayRef',
        default   => sub { [] },
        provides  => {
            'push' => 'add_options',
            'pop'  => 'remove_last_option',            
        }
    );
}

my $stuff = Stuff->new();
isa_ok($stuff, 'Stuff');

is_deeply($stuff->options, [], '... no options yet');

$stuff->add_options(1, 2, 3);
is_deeply($stuff->options, [1, 2, 3], '... got options now');

$stuff->add_options(10, 15);
is_deeply($stuff->options, [1, 2, 3, 10, 15], '... got more options now');

is($stuff->remove_last_option, 15, '... removed the last option');

is_deeply($stuff->options, [1, 2, 3, 10], '... got diff options now');



