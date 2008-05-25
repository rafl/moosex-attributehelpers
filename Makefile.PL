use inc::Module::Install;

name 'MooseX-AttributeHelpers';
license 'perl';

all_from 'lib/MooseX/AttributeHelpers.pm';

requires 'Moose' => '0.45';

build_requires 'Test::More'       => '0.62';
build_requires 'Test::Exception'  => '0.21';

auto_provides;
WriteAll();
