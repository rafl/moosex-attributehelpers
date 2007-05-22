#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;

BEGIN {
    use_ok('MooseX::AttributeHelpers');   
}

{
    package MyHomePage;
    use Moose;

    has 'counter' => (
        metaclass => 'Counter',
        is        => 'ro',
        isa       => 'Int',
        default   => sub { 0 },
        provides  => {
            inc => 'inc_counter',
            dec => 'dec_counter',
        }
    );
}

my $page = MyHomePage->new();
isa_ok($page, 'MyHomePage');

can_ok($page, 'inc_counter');
can_ok($page, 'dec_counter');

is($page->counter, 0, '... got the default value');

$page->inc_counter; 
is($page->counter, 1, '... got the incremented value');

$page->inc_counter; 
is($page->counter, 2, '... got the incremented value (again)');

$page->dec_counter; 
is($page->counter, 1, '... got the decremented value');

# check the meta ..

my $counter = $page->meta->get_attribute('counter');
isa_ok($counter, 'MooseX::AttributeHelpers::Counter');

is($counter->helper_type, 'Num', '... got the expected helper type');

is($counter->type_constraint->name, 'Int', '... got the expected type constraint');

is_deeply($counter->provides, { 
    inc => 'inc_counter',
    dec => 'dec_counter',    
}, '... got the right provides methods');

