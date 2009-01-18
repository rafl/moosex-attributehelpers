package MooseX::AttributeHelpers::MethodProvider::List;
use Moose::Role;

our $VERSION   = '0.14';
$VERSION = eval $VERSION;
our $AUTHORITY = 'cpan:STEVAN';
 
sub count : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        scalar @{$reader->($_[0])} 
    };        
}

sub empty : method {
    my ($attr, $reader, $writer) = @_;
    return sub { 
        scalar @{$reader->($_[0])} ? 1 : 0
    };        
}

sub find : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $predicate) = @_;
        foreach my $val (@{$reader->($instance)}) {
            return $val if $predicate->($val);
        }
        return;
    };
}

sub map : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $f) = @_;
        CORE::map { $f->($_) } @{$reader->($instance)}
    };
}

sub sort : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $predicate) = @_;
        die "Argument must be a code reference" 
            unless ref $predicate eq "CODE";
        CORE::sort { $predicate->($a, $b) } @{$reader->($instance)};
    };
}

sub grep : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $predicate) = @_;
        CORE::grep { $predicate->($_) } @{$reader->($instance)}
    };
}

sub elements : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance) = @_;
        @{$reader->($instance)}
    };
}

sub join : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        my ($instance, $separator) = @_;
        join $separator, @{$reader->($instance)}
    };
}

sub get : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        $reader->($_[0])->[$_[1]]
    };
}

sub first : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        $reader->($_[0])->[0]
    };
}

sub last : method {
    my ($attr, $reader, $writer) = @_;
    return sub {
        $reader->($_[0])->[-1]
    };
}

1;

__END__

=pod

=head1 NAME

MooseX::AttributeHelpers::MethodProvider::List

=head1 SYNOPSIS
    
   package Stuff;
   use Moose;
   use MooseX::AttributeHelpers;

   has 'options' => (
      metaclass  => 'Collection::List',
      is         => 'rw',
      isa        => 'ArrayRef[Str]',
      default    => sub { [] },
      auto_deref => 1,
      provides   => {
         map   => 'map_options',
         grep  => 'filter_options',
         find  => 'find_option',
         first => 'first_option',
         last  => 'last_option',
         get   => 'get_option',
         join  => 'join_options',
         count => 'count_options',
         empty => 'do_i_have_options',
         sort  => 'sort_options',

      }
   );

   no Moose;
   1;

=head1 DESCRIPTION

This is a role which provides the method generators for 
L<MooseX::AttributeHelpers::Collection::List>.

=head1 METHODS

=over 4

=item B<meta>

=back

=head1 PROVIDED METHODS

=over 4

=item B<count>
Returns the number of elements of the list.
   
   $stuff = Stuff->new;
   $stuff->options(["foo", "bar", "baz", "boo"]);
   
   my $count = $stuff->count_options;
   print "$count\n"; # prints 4

=item B<empty> 
If the list is populated, returns true. Otherwise, returns false.

   $stuff->do_i_have_options ? print "Good boy.\n" : die "No options!\n" ;

=item B<find>
Returns the first element that returns true in the anonymous subroutine
passed as argument.

   my $found = $stuff->find_option( sub { $_[0] =~ /^b/ } );
   print "$found\n"; # prints "bar"

=item B<grep>
Returns every element of the list that returns true in the anonymous
subroutine passed as argument.

   my @found = $stuff->filter_options( sub { $_[0] =~ /^b/ } );
   print "@found\n"; # prints "bar baz boo"

=item B<map>
Executes the anonymous subroutine given as argument sequentially
for each element of the list.

   my @mod_options = $stuff->map_options( sub { $_[0] . "-tag" } );
   print "@mod_options\n"; # prints "foo-tag bar-tag baz-tag boo-tag"

=item B<sort>
Returns a sorted list of the elements, using the anonymous subroutine
given as argument. 

This subroutine should perform a comparison between the two arguments passed
to it, and return a numeric list with the results of such comparison:

   # Descending alphabetical order
   my @sorted_options = $stuff->sort_options( sub { $_[1] cmp $_[0] } );
   print "@sorted_options\n"; # prints "foo boo baz bar"

=item B<elements>
Returns an element of the list by its index.

   my $option = $stuff->get_option(1);
   print "$option\n"; # prints "bar"

=item B<join>
Joins every element of the list using the separator given as argument.

   my $joined = $stuff->join_options( ':' );
   print "$joined\n"; # prints "foo:bar:baz:boo"

=item B<get>
Returns an element of the list by its index.

   my $option = $stuff->get_option(1);
   print "$option\n"; # prints "bar"

=item B<first>
Returns the first element.

   my $first = $stuff->first_option;
   print "$first\n"; # prints "foo"

=item B<last>
Returns the last item.

   my $last = $stuff->last_option;
   print "$last\n"; # prints "boo"

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
