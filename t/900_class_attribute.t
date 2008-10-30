#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

do {
    package TestClass;
    BEGIN {
        ::plan skip_all => "MooseX::ClassAttribute required for this test"
            unless eval {
                require MooseX::ClassAttribute;
                MooseX::ClassAttribute->VERSION('0.05');
            };
        MooseX::ClassAttribute->import;
    }

    class_has counter => (
        metaclass => 'Counter',
        provides  => {
            inc => 'inc_counter',
        },
    );
};

is(TestClass->counter, 0);
TestClass->inc_counter;
is(TestClass->counter, 1);

