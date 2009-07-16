use inc::Module::Install;

name 'MooseX-AttributeHelpers';
license 'perl';

all_from 'lib/MooseX/AttributeHelpers.pm';

requires 'Moose' => '0.56';

build_requires 'Test::More'       => '0.62';
build_requires 'Test::Exception'  => '0.21';
build_requires 'Test::Moose';

auto_provides;
WriteAll();
