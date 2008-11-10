#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use MooseX::AttributeHelpers;

do {
    package TestClass;
    BEGIN {
        ::plan skip_all => "MooseX::ClassAttribute 0.05 required for this test"
            unless eval {
                require MooseX::ClassAttribute;
                MooseX::ClassAttribute->VERSION('0.05');
            };
        ::plan tests => 2;
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

