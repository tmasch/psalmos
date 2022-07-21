package Hyphen;

use 5.006;
use warnings;
use strict;
use Carp;

#===================================================================
# $Author     : Djibril Ousmanou  and Laurent Rosenfeld            $
# $Copyright  : 2015                                               $
# $Update     : 26/08/2015                                         $
# $AIM        : Hyphenate words for French language                $
#===================================================================
use utf8;

use vars qw / $VERSION /;
$VERSION = '1.01';

sub new {
	my ( $self, $ref_arguments ) = @_;

	my $this = {};
	bless $this, $self;

	# Check arguments
	$this->_check_arguments($ref_arguments);

	# Default French configuration
	$this->{_min_word}         = $ref_arguments->{min_word}         || 6;
	$this->{_min_prefix}       = $ref_arguments->{min_prefix}       || 3;
	$this->{_min_suffix}       = $ref_arguments->{min_suffix}       || 3;
	$this->{_cut_proper_nouns} = $ref_arguments->{cut_proper_nouns} || 0;
	$this->{_cut_compounds}    = $ref_arguments->{cut_compounds}    || 0;

	# Check arguments
	$this->_check_arguments($ref_arguments, 1);

	# hyphen tree initialisation
	$this->{_tree} = {};

	# Load all patterns (official patterns, exceptions, proper nouns…)
	$this->_load_fr_patterns;

	return $this;
}

sub _check_arguments {
	my ( $this, $ref_arguments, $check_complet ) = @_;

	# Check arguments
	if ( defined $ref_arguments and ref($ref_arguments) ne 'HASH' ) {
		croak "You have to use a hash reference as argument\n";
	}

	# Check arguments again
	if ( defined $ref_arguments and defined $check_complet ) {

		foreach my $option ( keys %{$ref_arguments} ) {
			if (! $this->{"_$option"} ) {
				croak "$option option not exists in " . __PACKAGE__ ."\n"
				. "Read documentation : perldoc " . __PACKAGE__ ."\n";
			}
		}
	}

	return 1;
}

sub _add_pattern {
	my ( $this, $pattern ) = @_;

	# Convert the pattern in string and points list
	# Pattern a1bc3d4 => [a, b, c, d] and [ 0, 1, 0, 3, 4 ]
	my @chars = grep { /\D/ } split //, $pattern;
	my @points = map { $_ || 0 } split /\D/, $pattern, -1;

	# Insert the pattern into the tree. Each character finds a child node
	# another level down in the tree, and leaf nodes have the list of
	# points. (This kind of tree is usually called a trie (the word comes from
	# retrieval) or a prefix tree.) It has high performance for things such
	# as words lookup in a dictionary.
	my $ref_tree = $this->{_tree};    # Copy ref tree
	foreach (@chars) {

		# Create new ref tree or modify it
		if ( !$ref_tree->{$_} ) { $ref_tree->{$_} = {}; }
		$ref_tree = $ref_tree->{$_};
	}
	$ref_tree->{_} = \@points;

	return 1;
}

sub _load_fr_patterns {
	my $this = shift;

	# Add official fr pattern
	$this->_add_pattern($_) foreach @{ $this->_get_official_fr_patterns() };

	# Add non official fr pattern
	$this->_add_pattern($_) foreach @{ $this->_get_non_official_fr_patterns() };

	# Load exceptions words
	foreach my $word_exception ( @{ $this->_get_exceptions_words } ) {
		( my $word = $word_exception ) =~ tr/-//d;

		# wo-rd-le => { wordle => [0, 0, 1, 0, 1, 0, 0] }
		# ||a||a||
		#__ a _ a __
		# -1 == do not omit trailing undefs
		$this->{_exceptions}->{$word} = [ 0, map { $_ eq '-' ? 1 : 0 } split /[^-]/, $word_exception, -1 ];
	}

	# Proper nouns
	$this->{_ref_proper_nouns} = $this->_get_exceptions_proper_nouns_words();
}

sub hyphenate {
	my ( $this, $word, $delim ) = @_;
	$delim ||= '-';

	# Short words aren't hyphenated.
	return $word if ( length($word) < $this->{_min_word} );

	# If all the characters of the word are upper case Unicode letters,
	# we don't hyphenate ACRONYMS
	return $word if ( $word =~ /^\p{Uppercase}+$/ );

	# Don't hyphenate proper nouns unless this is asked for.
	if ( $this->{_cut_proper_nouns} eq 0 ) {
		return $word if ( $this->{_ref_proper_nouns}->{ lc($word) } );
	}

	# Don't hyphenate compounds unless this is asked for.
	if ( $this->{_cut_compounds} eq 0 ) {
		return $word if ( $word =~ /-/ );
	}

	my @word = split //, $word;

	# If the word is an exception, get the stored points.
	my $ref_points = $this->{_exceptions}->{ lc($word) };

	# Word with spaces
	my $regex = '[\s+,\.;!\?]+';
	if ( $word =~ m{\s} ) {
		my @spaces = $word =~ m{($regex)}g;
		my @words  = split /$regex/, $word;
		my $result = '';
		for my $i ( 0 .. $#words ) {
			$result .= $this->hyphenate( $words[$i] );
			$result .= $spaces[$i] if ( $spaces[$i] );
		}
		return $result;
	}

	# no exception
	unless ($ref_points) {

		# List of characters with extremetis (.)
		my @work = ( '.', map { lc } @word, '.' );
		$ref_points = [ (0) x ( @work + 1 ) ];
		# For each character
		for my $index_charactere ( 0 .. $#work ) {
			my $ref_tree = $this->{_tree};

			for my $charactere ( @work[ $index_charactere .. $#work ] ) {
				last if ( !$ref_tree->{$charactere} );
				$ref_tree = $ref_tree->{$charactere};

				# There is a position in tree
				if ( my $ref_position = $ref_tree->{_} ) {
					for my $index_position_tree ( 0 .. $#$ref_position ) {

				# $ref_points->[$index_charactere + $index_position_tree]
				# = max($ref_points->[$index_charactere + $index_position_tree], $ref_position->[$index_position_tree]);
						if ( $ref_points->[ $index_charactere + $index_position_tree ] <
							$ref_position->[$index_position_tree] )
						{
							$ref_points->[ $index_charactere + $index_position_tree ] =
							  $ref_position->[$index_position_tree];
						}
					}
				}
			}
		}

		# No hyphens within the minimal length suffixes and prefixes
		$ref_points->[$_] = 0 for 0 .. $this->{_min_prefix};
		$ref_points->[$_] = 0 for -$this->{_min_suffix} - 1 .. -2;
	}

	# Examine the points to build the pieces list.
	my @pieces = ('');

	for my $i ( 0 .. length($word) - 1 ) {
		$pieces[-1] .= $word[$i];
		$ref_points->[ 2 + $i ] % 2 and push @pieces, '';
	}

	return join( $delim, @pieces );
}

sub _get_exceptions_words {
	return [qw /
	Melchísedech
	 /];
}

sub _get_non_official_fr_patterns {
	return [qw/
	
	
	/];
}

sub _get_exceptions_proper_nouns_words {
	my $this = shift;
	return {} if ( $this->{_cut_proper_nouns} != 0 );
	my %proper_nouns = map { lc($_) => 1 } qw /
	  
	  /;
	return \%proper_nouns;
}

# From http://www.dicollecte.org - Césure 3.0
sub _get_official_fr_patterns {
	return [
		qw /
	
.a2b3l
.anti1  .anti3m2n
.circu2m1
.co2n1iun
.di2s3cine
.e2x1
.o2b3                                
.para1i  .para1u
.su2b3lu .su2b3r
2s3que.  2s3dem.
3p2sic
3p2neu
æ1 œ1 .æ1

1b   2bb   2bd   b2l   2bm  2bn  b2r  2bt  2bs  2b.
1c   2cc   c2h2  c2l   2cm  2cn  2cq  c2r  2cs  2ct  2cz  2c.
1d   2dd   2dg   2dm   d2r  2ds  2dv  2d.
1f   2ff   f2l   2fn   f2r  2ft  2f.
1g   2gg   2gd   2gf   g2l  2gm  g2n  g2r  2gs  2gv  2g.
1h   2hp   2ht   2h.
1j
1k   2kk   k2h2
1l   2lb   2lc   2ld   2lf  l3f2t 2lg 2lk  2ll  2lm  2ln  2lp  2lq  2lr
     2ls   2lt   2lv   2l.
1m   2mm   2mb   2mp   2ml  2mn  2mq  2mr  2mv  2m.
1n   2nb   2nc   2nd   2nf  2ng  2nl  2nm  2nn  2np  2nq  2nr  2ns
     n2s3m n2s3f 2nt   2nv  2nx  2n.
1p   p2h   p2l   2pn   2pp  p2r  2ps  2pt  2pz  2php 2pht 2p.
1qu2
1r   2rb   2rc   2rd   2rf  2rg  r2h  2rl  2rm  2rn  2rp  2rq  2rr  2rs  2rt
     2rv   2rz   2r.
1s2  2s3ph 2s3s  2stb  2stc 2std 2stf 2stg 2st3l     2stm 2stn 2stp 2stq
     2sts  2stt  2stv  2s.  2st.
1t   2tb   2tc   2td   2tf  2tg  t2h  t2l  t2r  2tm  2tn  2tp  2tq  2tt
     2tv   2t.
1v   v2l   v2r   2vv
1x   2xt   2xx   2x.
1z   2z.
a1i a1o 
e1a e1i e1o e1u
i1a i1e i1o i1u
u1a u1e u1i u1o
si1o
me1o tu1a i1e u1u 
me1um me1am tu1um tu1am
me1i
i1it
		  /
	];
}
# 
# a1ia a1ie  a1io  a1iu ae1a ae1o ae1u
# e1iu
# io1i
# o1ia o1ie  o1io  o1iu
# uo3u                               
# 
# 
# a1ua a1ue a1ui a1uo a1uu
# e1ua e1ue e1ui e1uo e1uu
# i1ua i1ue i1ui i1uo i1uu
# o1ua o1ue o1ui o1uo o1uu
# u1ua u1ue u1ui u1uo u1uu
# 
# a2l1ua a2l1ue a2l1ui a2l1uo a2l1uu
# e2l1ua e2l1ue e2l1ui e2l1uo e2l1uu
# i2l1ua i2l1ue i2l1ui i2l1uo i2l1uu
# o2l1ua o2l1ue o2l1ui o2l1uo o2l1uu
# u2l1ua u2l1ue u2l1ui u2l1uo u2l1uu
# 
# a2m1ua a2m1ue a2m1ui a2m1uo a2m1uu
# e2m1ua e2m1ue e2m1ui e2m1uo e2m1uu
# i2m1ua i2m1ue i2m1ui i2m1uo i2m1uu
# o2m1ua o2m1ue o2m1ui o2m1uo o2m1uu
# u2m1ua u2m1ue u2m1ui u2m1uo u2m1uu
# 
# a2n1ua a2n1ue a2n1ui a2n1uo a2n1uu
# e2n1ua e2n1ue e2n1ui e2n1uo e2n1uu
# i2n1ua i2n1ue i2n1ui i2n1uo i2n1uu
# o2n1ua o2n1ue o2n1ui o2n1uo o2n1uu
# u2n1ua u2n1ue u2n1ui u2n1uo u2n1uu
# 
# a2r1ua a2r1ue a2r1ui a2r1uo a2r1uu
# e2r1ua e2r1ue e2r1ui e2r1uo e2r1uu
# i2r1ua i2r1ue i2r1ui i2r1uo i2r1uu
# o2r1ua o2r1ue o2r1ui o2r1uo o2r1uu
# u2r1ua u2r1ue u2r1ui u2r1uo u2r1uu

1;    # End of Lingua::FR::Hyphen

__END__

=encoding utf8

=head1 NAME

Lingua::FR::Hyphen - Hyphenate French words

=head1 SYNOPSIS

    #!/usr/bin/perl
    use strict;
    use warnings;
    use Lingua::FR::Hyphen;
    use utf8;
      
    binmode( STDOUT, ':utf8' );
    my $hyphenator = new Lingua::FR::Hyphen;
      
    foreach (qw/  
        représentation  Montpellier avocat porte-monnaie 
        0102030405 rouge-gorge transaction consultant 
        rubicon développement UNESCO 
        /) {
        print "$_ -> " . $hyphenator->hyphenate($_) . "\n";
    }

    # représentation -> repré-sen-ta-tion
    # Montpellier -> Montpellier
    # avocat -> avo-cat
    # porte-monnaie -> porte-monnaie
    # 0102030405 -> 0102030405
    # rouge-gorge -> rouge-gorge
    # transaction -> tran-sac-tion
    # consultant -> consul-tant
    # rubicon -> rubicon
    # développement -> déve-lop-pe-ment
    # UNESCO -> UNESCO

=head1 DESCRIPTION

Lingua::FR::Hyphen hyphenates French words using Knuth Liang algorithm.

=head1 CONSTRUCTOR/METHODS

=head2 new

This constructor allows you to create a new Lingua::FR::Hyphen object.

B<$hyphenator = Lingua::FR::Hyphen-E<gt>new([OPTIONS])>

=over 4

=item B<min_word> =E<gt> I<integer>

Minimum length of word to be hyphenated. (default : 6).

  min_word => 4,

=back

=over 4

=item B<min_prefix> =E<gt> I<integer>

Minimal prefix to leave without any hyphens. (default : 3).

  min_prefix => 3,

=back

=over 4

=item B<min_suffix> =E<gt> I<integer>

Minimal suffix to leave without any hyphens. (default : 3).

  min_suffix => 3,

=back

=over 4

=item B<cut_proper_nouns> =E<gt> I<integer 0 or 1>

hyphenates or not proper nouns: (default : 0 (recommended)). 

  cut_proper_nouns => 0,

=back

=over 4

=item B<cut_compounds> =E<gt> I<integer 0 or 1>

hyphenates compounds: (default : 0 (recommended)). 

  cut_compounds => 0,

=back

=head2 hyphenate

hyphenates French words using Knuth Liang algorithm and following the rules of the French language.

B<$hyphenator-E<gt>hyphenate($word, $delimiter ? )>

Two arguments : the word and the delimiter (optionnal) (default : "-").

  $hyphenator->hyphenate($word1); 
  $hyphenator->hyphenate($word2, '/');

=head1 AUTHORS

Djibril Ousmanou, C<< <djibel at cpan.org> >>

Laurent Rosenfeld, C<< <laurent.rosenfeld at googlemail.com> >>


=head1 ACKNOWLEDGEMENTS

This module is based on the Knuth-Liang Algorithm. Frank Liang wrote his Stanford Ph.D. thesis (under the supervision of
Donald Knuth) on a hyphenation algorithm that was aimed at TeX (the typesetting utility written by Knuth) and is now standard in
Tex, and has been adapted to many open source projects such as OpenOffice, LibreOffice, Firefox, Thunderbird, etc. His 1983 PhD thesis 
can be found at L<http://www.tug.org/docs/liang/>. He invented both the "packed or compressed trie" structure for storing 
efficiently the patterns and the way to represent possible hyphens in those patterns.

This module is also partly derived from Alex Kapranoff's L<Text::Hyphen> module to hyphenate English language words.

The list of hyphenation (« césure » or « coupure de mots » in French) patterns for the French language was derived from the Dicollecte site 
(L<http://www.dicollecte.org/home.php?prj=fr>), which produces several French open source 
spell check dictionaries, used notably for Latex, OpenOffice and LibreOffice. The list of 
patterns itself can be found there: L<http://www.dicollecte.org/download/fr/hyph-fr-v3.0.zip>.

The list of proper nouns used for preventing their hyphenation (it is usually considered bad to hyphenate proper nouns
in French) was compiled from several sources, but the main source was the Hunspell dictionary for French words,
which can also be found on the Dicollect site (see L<http://www.dicollecte.org/download.php?prj=fr>) from which we extracted
proper nouns as well as acronyms (which also should no be hyphenated), although this module will not hyphenate all-capital
words anyway.


=head1 BUGS

Please report any bugs or feature requests to C<bug-lingua-fr-hyphen at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lingua-FR-Hyphen>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SEE ALSO

See L<Text::Hyphen>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lingua::FR::Hyphen


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Lingua-FR-Hyphen>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Lingua-FR-Hyphen>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Lingua-FR-Hyphen>

=item * Search CPAN

L<http://search.cpan.org/dist/Lingua-FR-Hyphen/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Djibril Ousmanou.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

