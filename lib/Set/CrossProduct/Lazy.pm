use strict;
use warnings;
package Set::CartesianProduct::Lazy;

# ABSTRACT: lazily calculate the tuples of a cartesian-product

use List::Util qw( reduce );


=method new

Construct a new object. Takes the following arguments:

=for :list
* options
A hashref of options that modify the way the object works.
If you don't want to specify any options, simply omit this
argument.
* sets
A list of arrayrefs from which to compute the cartesian product.
You can list as many as you want.

For the options hash, the following keys are recognized:

=begin :list

= less_lazy
Makes the get method slightly faster, at the expense
of not being able to account for any modifications made
to the original input arrays. If you modify one of the
arrays used to consruct the object, the results of all
the other methods are B<undefined>. You might get the
wrong answer. You might trigger an exception, you might
get mutations that give you super-powers at the expense
of never being able to touch another human being without
killing them.

Some examples:

  my $cpl = Set::CartesianProduct::Lazy->new(\@a, [qw(foo bar baz)], \@b);
  my $cpl = Set::CartesianProduct::Lazy->new( { less_lazy => 1 }, \@a, \@b, \@c);

=end :list

=cut
sub new { ... }


=method get

Return the tuple at the given "position" in the cartesian product.
The positions, like array indices, are based at 0.

If called in scalar context, an arrayref is returned. If called in list
context, a list is returned.

If you ask for a position that exceeds the bounds of the array defining the
cartesian product the result will be an empty list or undef, depending on
whether this was called in scalar or list context.

=cut
sub get { ... }


=method count

Return the count of tuples that would be in the cartesian
product if it had been generated.

=cut
sub count { ... }


=method last_idx

Return the index of the last tuple that would be in the cartesian
product if it had been generated. This is just for conveniece
so you don't have to write code like this:

  for my $i ( 0 .. $cpl->count - 1 ) { ... }

And you can do this instead:

  for my $i ( 0 .. $cpl->last_idx ) { ... }

Which I feel is more readable.

=cut
sub last_idx { ... }


1 && q{a set in time saves nine};
__END__

=head1 SYNOPSIS

  my @a   = qw( foo bar baz bah );
  my @b   = qw( wibble wobble weeble );
  my @c   = qw( nip nop );

  my $cpl = Set::CartesianProduct::Lazy->new( \@a, \@b, \@c );

  my $tuple;

  $tuple = $cpl->get(0);   # [ qw( foo wibble nip ) ]

  $tuple = $cpl->get(21);  # [ qw( bah wobble nop ) ]

  $tuple = $cpl->get(7);   # [ qw( bar wobble nip ) ]

  $cpl->count;             # 24
  $cpl->last_idx;          # 23


=head1 DESCRIPTION

If you have some number of arrays, say like this:

  @a = qw( foo bar baz bah );
  @b = qw( wibble wobble weeble );
  @c = qw( nip nop );

And you want all the combinations of one element from each array, like this:

  @cp = (
    [qw( foo wibble nip )],
    [qw( foo wibble nop )],
    [qw( foo wobble nip )],
    [qw( foo wobble nop )],
    [qw( foo weeble nip )],
    # ...
    [qw( bah wobble nop )],
    [qw( bah weeble nip )],
    [qw( bah weeble nop )],
  )

What you want is a Cartesian Product (also called a Cross Product, but my
mathy friend insists that Cartesian is correct)

Yes, there are already a lot of other modules on the CPAN that do this.
I won't claim that this module does this calculation any better or faster,
but it does do it I<differently>, as far as I can tell.

Nothing else seemed to offer a specific feature - I needed to pick random
individual tuples from the Cartesian Product, I<without> iterating over
the whole set and I<without> calculating any tuples until they were
asked for. Bonus points for not making a copy of the original input sets.

I needed the calculation to be lazy, and I needed random-access with O(1)
retrieval time, even if that meant a slower implementation overall. And
I didn't want to use RAM unnecessarily, since the data I was working with
was of a significant size.

