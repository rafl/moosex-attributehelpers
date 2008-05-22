#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'MooseX::AttributeHelpers',
    'VERSION_FROM' => 'lib/MooseX/AttributeHelpers.pm',
    'PREREQ_PM'    => {
        'Class::MOP'      => '0.47',
        'Moose'           => '0.30',
        'Test::Exception' => '0.21',
        'Test::More'      => '0.62'
    },
    'INSTALLDIRS' => 'site',
    'EXE_FILES'   => [],
    'PL_FILES'    => {}
);
