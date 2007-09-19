
package MooseX::AttributeHelpers::Counter;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use MooseX::AttributeHelpers::MethodProvider::Counter;

extends 'MooseX::AttributeHelpers::Base';

has '+method_provider' => (
    default => 'MooseX::AttributeHelpers::MethodProvider::Counter'
);

sub helper_type { 'Num' }

before 'process_options_for_provides' => sub {
    my ($self, $options, $name) = @_;

    # Set some default attribute options here unless already defined
    if (my $type = $self->helper_type and not exists $options->{isa}){
        $options->{isa} = $self->helper_type;
    }
    $options->{is} = 'ro' unless exists $options->{is};
    $options->{default} = 0 unless exists $options->{default};
    
    # If no provides are specified we'll default to all of them
    unless ( exists $options->{provides} and
             grep { exists $options->{provides}{$_} } qw( inc dec reset )
    ){
        @{$options->{provides}}{qw(inc dec reset)} = ("inc_$name", "dec_$name", "reset_$name");
    }
};

no Moose;

# register the alias ...
package Moose::Meta::Attribute::Custom::Counter;
sub register_implementation { 'MooseX::AttributeHelpers::Counter' }

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::Counter

=head1 SYNOPSIS

  package MyHomePage;
  use Moose;
  use MooseX::AttributeHelpers;
  
  has 'counter' => (
      metaclass => 'Counter',
      is        => 'ro',
      isa       => 'Num',
      default   => sub { 0 },
      provides  => {
          inc => 'inc_counter',
          dec => 'dec_counter',          
          reset => 'reset_counter',
      }
  );

  my $page = MyHomePage->new();
  $page->inc_counter; # same as $page->counter($page->counter + 1);
  $page->dec_counter; # same as $page->counter($page->counter - 1);  
  
=head1 DESCRIPTION

This module provides a simple counter attribute, which can be 
incremented and decremeneted. 

If your attribute definition does not include any of I<is>, I<isa>,
I<default> or I<provides> but does use the C<Counter> metaclass,
then this module applies defaults as in the L</SYNOPSIS>
above. This allows for a very basic counter definition:

  has 'foo' => (metaclass => 'Counter');
  $obj->inc_foo;

=head1 METHODS

=over 4

=item B<method_provider>

=item B<has_method_provider>

=item B<helper_type>

=item B<process_options_for_provides>

Run before its superclass method.

=back

=head1 PROVIDED METHODS

It is important to note that all those methods do in place
modification of the value stored in the attribute.

=over 4

=item I<inc>

Increments the value stored in this slot by 1.

=item I<dec>

Decrements the value stored in this slot by 1.

=item I<reset>

Resets the value stored in this slot to it's default value.

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
