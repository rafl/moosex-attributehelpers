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
        isa       => 'ArrayRef[Int]',
        default   => sub { [] },
        provides  => {
            'push'    => 'add_options',
            'pop'     => 'remove_last_option',    
            'shift'   => 'remove_first_option',
            'unshift' => 'insert_options',
            'get'     => 'get_option_at',
            'set'     => 'set_option_at',
            'count'   => 'num_options',
            'empty'   => 'has_options',        
        }
    );
}

my $stuff = Stuff->new();
isa_ok($stuff, 'Stuff');

can_ok($stuff, $_) for qw[
    add_options
    remove_last_option
    remove_first_option
    insert_options
    get_option_at
    set_option_at
    num_options
    has_options
];

is_deeply($stuff->options, [], '... no options yet');

ok(!$stuff->has_options, '... no options');
is($stuff->num_options, 0, '... got no options');

$stuff->add_options(1, 2, 3);
is_deeply($stuff->options, [1, 2, 3], '... got options now');

ok($stuff->has_options, '... no options');
is($stuff->num_options, 3, '... got 3 options');

is($stuff->get_option_at(0), 1, '... get option at index 0');
is($stuff->get_option_at(1), 2, '... get option at index 1');
is($stuff->get_option_at(2), 3, '... get option at index 2');

$stuff->set_option_at(1, 100);

is($stuff->get_option_at(1), 100, '... get option at index 1');

$stuff->add_options(10, 15);
is_deeply($stuff->options, [1, 100, 3, 10, 15], '... got more options now');

is($stuff->num_options, 5, '... got 5 options');

is($stuff->remove_last_option, 15, '... removed the last option');

is($stuff->num_options, 4, '... got 4 options');
is_deeply($stuff->options, [1, 100, 3, 10], '... got diff options now');

$stuff->insert_options(10, 20);

is($stuff->num_options, 6, '... got 6 options');
is_deeply($stuff->options, [10, 20, 1, 100, 3, 10], '... got diff options now');

is($stuff->get_option_at(0), 10, '... get option at index 0');
is($stuff->get_option_at(1), 20, '... get option at index 1');
is($stuff->get_option_at(3), 100, '... get option at index 3');

is($stuff->remove_first_option, 10, '... getting the first option');

is($stuff->num_options, 5, '... got 5 options');
is($stuff->get_option_at(0), 20, '... get option at index 0');

## test the meta

my $options = $stuff->meta->get_attribute('options');
isa_ok($options, 'MooseX::AttributeHelpers::Collection::Array');

is_deeply($options->provides, {
    'push'    => 'add_options',
    'pop'     => 'remove_last_option',    
    'shift'   => 'remove_first_option',
    'unshift' => 'insert_options',
    'get'     => 'get_option_at',
    'set'     => 'set_option_at',
    'count'   => 'num_options',
    'empty'   => 'has_options',    
}, '... got the right provies mapping');

is($options->container_type, 'Int', '... got the right container type');
