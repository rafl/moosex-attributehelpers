#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

eval "use Test::Pod 1.14";
plan skip_all => "Pod tests run only authors" unless -e "inc/.author";
plan skip_all => "Test::Pod 1.14 required for testing POD" if $@;

all_pod_files_ok();
