#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;

BEGIN {
    use_ok('MooseX::AttributeHelpers');
}

=pod

## convert this to a test ... 
## code by Robert Boone

package Subject;

use Moose::Role;
use MooseX::AttributeHelpers;

has observers => (
    metaclass  => 'Collection::Array',
    is         => 'ro',
    isa        => 'ArrayRef',
    auto_deref => 1,
    default    => sub { [] },
    provides   => { 'push' => 'add_observer', }
);

sub notify {
    my ($self) = @_;
    foreach my $observer ( $self->observers() ) {
        $observer->update($self);
    }
}

###############################################################################

package Observer;

use Moose::Role;

sub update {
    die 'Forgot to implement' . "\n";
}

###############################################################################

package Counter;

use Moose;
use MooseX::AttributeHelpers;

with 'Subject';

has count => (
    metaclass => 'Counter',
    is        => 'ro',
    isa       => 'Int',
    default   => 0,
    provides  => {
        inc => 'inc_counter',
        dec => 'dec_counter',
    }
);

after 'inc_counter','dec_counter' => sub {
    my ($self) = @_;
    $self->notify();
};

###############################################################################

package Display;

use Moose;

with 'Observer';

sub update {
    my ( $self, $subject ) = @_;
    print $subject->count() . "\n";
}

###############################################################################

package main;

my $count = Counter->new();
$count->add_observer( Display->new() );

for ( 1 .. 5 ) {
    $count->inc_counter();
}

for ( 1 .. 5 ) {
    $count->dec_counter();
}