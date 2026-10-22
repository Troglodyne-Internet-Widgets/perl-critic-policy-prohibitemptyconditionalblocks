package Perl::Critic::Policy::ControlStructures::ProhibitEmptyConditionalBlocks;

# ABSTRACT: Write no if, elsif, else or unless with nothing in its block.

use strict;
use warnings FATAL => 'all';

use 5.014;

use re '/aa';

use Readonly;

use Perl::Critic::Utils qw{ :severities };
use parent              qw{Perl::Critic::Policy};

=head1 Perl::Critic::Policy::ControlStructures::ProhibitEmptyConditionalBlocks

A branch with nothing in it is a branch that does nothing, written out so the
reader has to work that out.  Say what does happen instead: invert the
condition, or return early.

    if ( $query->{raw} ) {          # reported
        # raw skips the filters.
    }
    elsif ( @acls ) {
        ...
    }

    # raw skips the filters.
    return if $query->{raw};
    ...

A comment does not make a block less empty.  Put it beside the code that the
condition guards, where it explains something.

=head2 PROHIBITED

    if ($x) {}                      # each of these blocks
    if ($x) { # nothing to do       # holds no statement
    }
    unless ($x) {}
    if ($x) { f() } elsif ($y) {}
    if ($x) { f() } else {}
    if ($x) { ; }                   # a null statement is none

=head2 ALLOWED

    if ($x) { f() }
    f() if $x;                      # no block
    while ( waitpid( -1, WNOHANG ) > 0 ) {}    # a loop, not a conditional
    sub noop {}                     # a sub, not a conditional

=head2 CAVEATS

Only C<if>, C<elsif>, C<else> and C<unless> are read.  An empty loop body can
be the point of the loop, when its condition does the work, so loops are left
alone.

Each empty block is a violation of its own, reported at the keyword that opens
it.

=cut

Readonly::Scalar my $EXPL => q{Invert the condition, or return early};

=head2 METHODS

=head3 supported_parameters

=head3 default_severity

=head3 default_themes

=head3 applies_to

=cut

sub supported_parameters { return () }
sub default_severity     { return $SEVERITY_MEDIUM }
sub default_themes       { return qw{ maintenance } }
sub applies_to           { return 'PPI::Statement::Compound' }

=head3 violates

=cut

sub violates {
    my ( $self, $elem, undef ) = @_;

    # PPI types an unless chain as 'if' too.
    return unless $elem->type eq 'if';

    my ( @violations, $keyword );
    foreach my $child ( $elem->schildren ) {
        if ( $child->isa('PPI::Token::Word') ) {
            $keyword = $child;
            next;
        }
        next unless $child->isa('PPI::Structure::Block');
        next if $child->schildren;
        push( @violations, $self->violation( 'Empty ' . $keyword->content . ' block', $EXPL, $keyword ) );
    }
    return @violations;
}

1;
