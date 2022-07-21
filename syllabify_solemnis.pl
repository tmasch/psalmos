use lib '.';
use Hyphen;


# sed 's/.*OUT.*//' < print | sed 's/#.*//' | sed 's/.*INC.*//' | sed 's/.*print_music.*//' > print1.txt

$hyphenator = Hyphen->new({"min_prefix" => 1	, "min_suffix" => 1, "min_word" => 1});


@toni=(
"C_1_D",
"C_1_D2",
"C_1_f",
"C_1_g",
"C_1_g2",
"C_1_a",
"C_1_a2",
"C_1_a3",
"C_2_D",
"C_2_A",
"C_3_b",
"C_3_a",
"C_3_a2",
"C_3_g",
"C_4_E",
"C_4_A",
"C_4_As",
"C_5_a",
"C_6_F",
"C_6_C",
"C_7_a",
"C_7_b",
"C_7_c",
"C_7_c2",
"C_7_d",
"C_8_G",
"C_8_Gs",
"C_8_c",
"CS_1_D",
"CS_1_D2",
"CS_1_f",
"CS_1_g",
"CS_1_g2",
"CS_1_a",
"CS_1_a2",
"CS_1_a3",
"CS_2_D",
"CS_2_A",
"CS_3_b",
"CS_3_a",
"CS_3_a2",
"CS_3_g",
"CS_4_E",
"CS_4_A",
"CS_4_As",
"CS_5_a",
"CS_6_F",
"CS_6_C",
"CS_7_a",
"CS_7_b",
"CS_7_c",
"CS_7_c2",
"CS_7_d",
"CS_8_G",
"CS_8_Gs",
"CS_8_c"
);

#@toni=("1_f");

open(INC,">includeall.tex");
open(PROB,">problems.txt");
open(UNACC,">unaccented.txt");


@psalms=();

push(@psalms,"Magnificat");
#@psalms=();


for $ips (@psalms){

$filename="psalmi/".$ips.".txt";

print "IPS",$ips;

print "\n  ".$ips.": ";
print $filename."\n";

@psalmus=();
open(PSF,'<',$filename);
$nl=0;
while ($lpsf = <PSF>){
chomp $lpsf;
$nl++;
#$lpsf=~s/$ips.$nl //;
$tmp=$lpsf;
#print $tmp."\n";
	$i=index($tmp,' ');
#	print $i."\n";
	$tmp=substr($tmp,$i+1,length($tmp));
#print $tmp."\n";
push(@psalmus,$tmp);
}
close(PSF);

$tmp="Glória Patri et Fílio * et Spirítui Sancto";
push(@psalmus,$tmp);
$tmp="Sicut erat in princípio et nunc et semper * et in sǽcula sǽculorum. Amen.";
push(@psalmus,$tmp);



@tmp=split('\*', $psalmus[0]);
print @tmp;

print INC "\\newpage\n";
$incipit=deaccentify($tmp[0]);

print "INCIPIT\n".$incipit."\n\n\n\n\n";
print INC "\\section{".$ips." ".$incipit."}\n";
for $ton (@toni){

$tmp=$ton;
$tmp=~s/C_//g;
$tmp=~s/CS_/solemnis /g;
$tmp=~s/_/ /g;
$tmp=~s/D1/D/g;
$tmp=~s/D2/D\$\^2\$/g;
$tmp=~s/c2/c\$\^2\$/g;
$tmp=~s/g2/g\$\^2\$/g;
$tmp=~s/g3/g\$\^3\$/g;
$tmp=~s/a2/a\$\^2\$/g;
$tmp=~s/a3/a\$\^3\$/g;
$tmp=~s/As/A\$^\\ast\$/g;
$tmp=~s/Gs/G\$^\\ast\$/g;
$tmp=~s/Per/T. Per./g;

if ($tmp eq "2"){$tmp="2 D";}
if ($tmp eq "5"){$tmp="5 a";}
if ($tmp eq "6"){$tmp="6 F";}


print INC "\\newpage\n";
print INC "\\subsection{".$ips." Tonus ".$tmp."}\n";
print INC "\\greannotation{{\\color{red}".$tmp."}}\n";
print INC "\\gregorioscore[a]{./gabc/psalmus".$ips."_".$ton.".gabc}\n";
print INC "\\begin{multicols}{2}\n";
print INC "\\input{./versus/versus".$ips."_".$ton.".tex}\n";
print INC "\\end{multicols}\n";


open(OUT,">./gabc/psalmus".$ips."_".$ton.".gabc");
open(OUTi,">./versus/versus".$ips."_".$ton.".tex");
print OUT "%%\n";

print $ton." - ";

%tonus=select_tonus($ton);
print $tonus{"flexa"}."-----";
%tonus_flexa=%tonus;
$tonus_flexa{"1-apu"}=$tonus{"1-0"};
$tonus_flexa{"1-pu"}=$tonus{"1-0"};
$tonus_flexa{"1-u"}=$tonus{"1-0"};
$tonus_flexa{"1-4"}=$tonus{"1-0"};
$tonus_flexa{"1-5"}=$tonus{"1-0"};
$tonus_flexa{"1-6"}=$tonus{"1-0"};
$tonus_flexa{"1-7"}=$tonus{"1-0"};
$tonus_flexa{"1-8"}=$tonus{"flexa"};
$tonus_flexa{"1-9"}=$tonus{"flexa"}.".";
$tonus_flexa{"1-s"}=0;
$tonus_flexa{"1-format"}="SM";
print "tn flex ".$tonus_flexa{"1-8"}." "."asdf";
print %tonus_flexa;

print OUT $tonus{"clef"}."\n";
#print OUT "1. ";

$first_flexa="";
$first_flexa_versus=0;

$versus=0;
for $totum (@psalmus){
$versus++;
print $totum."\n";



$print_music=1;
if ($versus > 2){
$print_music=0;
}
if($print_music==1){print OUT $versus.". ";}
if ($print_music!=1){print OUTi "\\versusindent ".$versus.". ";}

$totum=replace_exceptions($totum);

@partes=split(' \* ',$totum);
$sent=$partes[0];
#if ($versus<=1){
$initium=1;
#}

if ($sent =~ 'Magníficat'){

write_magnificat($ton);


}
else{


print "\n\n versus ".$versus." initium ".$initium."\n\n";

$flexa=0;
if ($sent =~ '\+'){#flexa!
	$flexa=1;
	@tmp=split('\+',$sent);
	$sent0=$tmp[0];
	if (!$first_flexa){$first_flexa=$sent0;$first_flexa_versus=$versus;}
	$sent=$tmp[1];
	@words_hyphen=hyphenate($sent0);
	@acc=accentify(@words_hyphen);
	$schema=find_schema($initium,@acc);
#	$schema=~s/4/0/g;
#	$schema=~s/5/0/g;
#	$schema=~s/6/0/g;
	print $schema;
	if (length($schema) <= 6){$la="";for $w (@acc){$la=$la.$w;};$la=~s/~//g;print PROB $ips.":".$versus."_1_".$la."_".$schema." ".$totum."\n";}
	$lw="";
	if ($schema !~ "9"){print PROB $ips.":".$versus." ".$totum."\n";}
	for $w (@words_hyphen){$lw=$lw.$w;}
	#if ($tonus{"1-format"} =~ "MM"){format_pars_MM("1",$print_music,$lw,$schema,%tonus);}
	#if ($tonus{"1-format"} =~ "MW"){format_pars_MW("1",$print_music,$lw,$schema,%tonus);}
	format_pars_SM("0",$print_music,$lw,$schema,%tonus_flexa);
	#if ($tonus{"1-format"} =~ "SW"){format_pars_SW("1",$print_music,$lw,$schema,%tonus);}
	print "flexa done\n";
	if ($print_music==1){print OUT " <v>\\dagger</v>(,) ";}
	if ($print_music!=1){print OUTi " \\dagger\\ ";}
	$initium=0;
}

#print "zxcvzcxv".$sent;
@words_hyphen=hyphenate($sent);
@acc=accentify(@words_hyphen);
$schema=find_schema($initium,@acc);
print $schema;
if ($flexa==1){
$schema=~s/123/000/g;
}

if (length($schema) <= 6){$la="";for $w (@acc){$la=$la.$w;};$la=~s/~//g;print PROB $ips.":".$versus."_1_".$la."_".$schema." ".$totum."\n";}
$lw="";
if ($schema !~ "9"){print PROB $ips.":".$versus." ".$totum."\n";}
for $w (@words_hyphen){$lw=$lw.$w;}
if ($tonus{"1-format"} =~ "MM"){format_pars_MM("1",$print_music,$lw,$schema,%tonus);}
if ($tonus{"1-format"} =~ "MW"){format_pars_MW("1",$print_music,$lw,$schema,%tonus);}
if ($tonus{"1-format"} =~ "SM"){format_pars_SM("1",$print_music,$lw,$schema,%tonus);}
if ($tonus{"1-format"} =~ "SW"){format_pars_SW("1",$print_music,$lw,$schema,%tonus);}


if ($print_music==1){print OUT " \*(:) ";}
if ($print_music!=1){print OUTi " \* ";}
#print OUTi "\\\\ \\hspace*{2em} ";
#print " \*(:) ";

}




$sent=$partes[1];
@words_hyphen=hyphenate($sent);
@acc=accentify(@words_hyphen);
$initium=0;
$schema=find_schema($initium,@acc);
if (length($schema) <= 6){$la="";for $w (@acc){$la=$la.$w;};$la=~s/~//g;print PROB $ips.":".$versus."_2_".$la."_".$schema." ".$totum."\n";}


if ($schema !~ "9"){print PROB $ips.":".$versus." ".$totum."\n";}
$lw="";
for $w (@words_hyphen){$lw=$lw.$w;}
if ($tonus{"2-format"} =~ "MM"){format_pars_MM("2",$print_music,$lw,$schema,%tonus);}
if ($tonus{"2-format"} =~ "MW"){format_pars_MW("2",$print_music,$lw,$schema,%tonus);}
if ($tonus{"2-format"} =~ "SM"){format_pars_SM("2",$print_music,$lw,$schema,%tonus);}
if ($tonus{"2-format"} =~ "SW"){format_pars_SW("2",$print_music,$lw,$schema,%tonus);}

#print "(::)";
if ($print_music==1){print OUT "(::) \n";}
if ($print_music!=1){print OUTi "\\\\ \n";}
#print "\n";

print "\n\n psalmus ".$ips." versus ".$versus." initium ".$initium." done \n\n";


}#versus loop

print "Versus loop done\n";


#add first flexa
if ($first_flexa_versus > 1){
	print "First flexa\n";
	print OUT " () <i>Flexa:</i>() ";
	$sent0=$first_flexa;
	@tmp=split(" ",$sent0);
	print $sent0."\n";
#	$sent0=$tmp[scalar(@tmp)-1];
	@words_hyphen=hyphenate($sent0);
	print "words_hyphen:";
	print @words_hyphen;
	print "\n";
	@acc=accentify(@words_hyphen);
	$initium=0;
#	$acc[0]="0~0~0~0~0~0~".$acc[0];
	print "acc";
	print @acc;
	print "\n";
	$schema=find_schema($initium,@acc);
#	$schema=substr($schema,6,length($schema));
	print $schema."\n";
	$lw="";
	$n=scalar(@words_hyphen);
	print $n."\n";

	
	if ($acc[$n-1]!=2){
	$lw=$words_hyphen[$n-1];
	$ns=$acc[$n-1];
	print "ns".$ns."\n";
	$ns=~s/ //g;
	$ns=~s/~//g;
	$ns=length($ns);
	print $lw;
	print "ns".$ns."\n";
	print "schema".$schema."\n";
	$schema=substr($schema,length($schema)-$ns,$ns);
	print "schema".$schema."\n";
	}
	if ($acc[$n-1]==2){
	$lw=$words_hyphen[$n-2].$words_hyphen[$n-1];
	$ns=$acc[$n-2].$acc[$n-1];
	$ns=~s/ //g;
	$ns=~s/~//g;
	$ns=length($ns);
	print $ns;
	$schema=substr($schema,length($schema)-$ns,$ns);
	print $schema;
	}
	print $lw."\n";
	
	
	
#	print $lw;
	format_pars_SM("0","1",$lw,$schema,%tonus_flexa);
	print "first flexa done\n";
	print OUT " <v>\\dagger</v>(,) ";
	print OUT " (".$tonus{"1-0"}.")";
	print OUT " (".$tonus{"1-0"}.")";
	print OUT " (".$tonus{"1-0"}.")";
	print OUT " (::) ";
}

close(OUT);
close(OUTi);
}# tonus loop

}# psalm loop

close(INC);


sub tonus_i(){
#=1D
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="f";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="ixi";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-7"}="g";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="MM";

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="g";
$tonus{"2-u"}="f";
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gvFED.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}

sub tonus_i_D(){
%tonus=tonus_i();
return(%tonus);
}

sub tonus_i_D1(){
%tonus=tonus_i();
$tonus{"2-7"}="g";
return(%tonus);
}

sub tonus_i_D2(){
%tonus=tonus_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="gf";
$tonus{"2-9"}="d.";
$tonus{"2-format"}="SW";
return(%tonus);
}

sub tonus_i_f(){
%tonus=tonus_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gf..";
return(%tonus);
}

sub tonus_i_g(){
%tonus=tonus_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
return(%tonus);
}

sub tonus_i_g2(){
%tonus=tonus_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="g";
$tonus{"2-9"}="ghg.";
return(%tonus);
}

sub tonus_i_g3(){
%tonus=tonus_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
return(%tonus);
}

sub tonus_i_a(){
%tonus=tonus_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="h";
$tonus{"2-9"}="h.";
return(%tonus);
}

sub tonus_i_a2(){
%tonus=tonus_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}


sub tonus_i_a3(){
%tonus=tonus_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}


sub tonus_ii(){
#=2
%tonus=();
$tonus{"clef"}="(f3)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="e";
$tonus{"1-2"}="f";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="h";
$tonus{"1-7"}="i";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="f";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="g";
$tonus{"2-7"}="e";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=1;

return(%tonus)
}


sub tonus_iii(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="j";
$tonus{"1-1"}="g";
$tonus{"1-2"}="hj";
$tonus{"1-3"}="j";
$tonus{"1-4"}="k";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-7"}="j";
$tonus{"1-8"}="ih";
$tonus{"1-9"}="j.";
$tonus{"1-format"}="MW";

$tonus{"flexa"}="h";

$tonus{"2-0"}="j";
$tonus{"2-1"}="j";
$tonus{"2-2"}="j";
$tonus{"2-3"}="j";
$tonus{"2-4"}="j";
$tonus{"2-5"}="j";
$tonus{"2-6"}="j";
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="j";
$tonus{"2-u"}="h";
$tonus{"2-7"}="j";
$tonus{"2-8"}="j";
$tonus{"2-9"}="i.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=1;

return(%tonus)
}



sub tonus_iii_b(){
%tonus=tonus_iii();
return(%tonus);
}

sub tonus_iii_a(){
%tonus=tonus_iii();
$tonus{"2-9"}="ih..";
return(%tonus);
}


sub tonus_iii_a2(){
%tonus=tonus_iii();
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="ji";
$tonus{"2-u"}="hi";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;
return(%tonus);
}

sub tonus_iii_g(){
%tonus=tonus_iii();
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="ji";
$tonus{"2-u"}="hi";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;
return(%tonus);
}

sub tonus_iii_g2(){
%tonus=tonus_iii();
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="j";
$tonus{"2-u"}="i";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=3;
return(%tonus);
}


sub tonus_iv_1(){
#=ivg
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="h";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="g";
$tonus{"1-u"}="h";
$tonus{"1-7"}="i";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=2;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="h";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=0;

return(%tonus)
}

sub tonus_iv_g(){
%tonus=tonus_iv_1();
return(%tonus);
}

sub tonus_iv_E(){
%tonus=tonus_iv_1();
$tonus{"2-apu"}="g";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="ih";
$tonus{"2-7"}="g";
$tonus{"2-8"}="gf";
$tonus{"2-9"}="e.";
$tonus{"2-format"}="SW";
$tonus{"2-s"}=3;
return(%tonus);
}

sub tonus_iv_2(){
#=iv c
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="i";
$tonus{"1-1"}="i";
$tonus{"1-2"}="hi";
$tonus{"1-3"}="i";
$tonus{"1-4"}="i";
$tonus{"1-5"}="i";
$tonus{"1-6"}="i";
$tonus{"1-apu"}="i";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="i";
$tonus{"1-7"}="j";
$tonus{"1-8"}="i";
$tonus{"1-9"}="i.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=2;

$tonus{"flexa"}="h";

$tonus{"2-0"}="i";
$tonus{"2-1"}="i";
$tonus{"2-2"}="i";
$tonus{"2-3"}="i";
$tonus{"2-4"}="i";
$tonus{"2-5"}="i";
$tonus{"2-6"}="i";
$tonus{"2-apu"}="i";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="i";
$tonus{"2-7"}="i";
$tonus{"2-8"}="h";
$tonus{"2-9"}="h.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=0;

return(%tonus)
}

sub tonus_iv_c(){
%tonus=tonus_iv_2();
return(%tonus);
}

sub tonus_iv_A(){
%tonus=tonus_iv_2();
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="j";
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=3;
return(%tonus);
}

sub tonus_iv_As(){
%tonus=tonus_iv_2();
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="j";
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="fg..";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=3;
return(%tonus);
}

sub tonus_v(){
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="d";
$tonus{"1-2"}="f";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="h";
$tonus{"1-7"}="i";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="f";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="i";
$tonus{"2-5"}="g";
$tonus{"2-6"}="g";
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="MM";

return(%tonus)
}


# sub tonus_vi(){
# %tonus=();
# $tonus{"clef"}="(cf)";
# $tonus{"1-0"}="h";
# $tonus{"1-1"}="d";
# $tonus{"1-2"}="f";
# $tonus{"1-3"}="h";
# $tonus{"1-4"}="h";
# $tonus{"1-5"}="h";
# $tonus{"1-6"}="h";
# $tonus{"1-apu"}="h";
# $tonus{"1-pu"}="h";
# $tonus{"1-u"}="h";
# $tonus{"1-7"}="i";
# $tonus{"1-8"}="h";
# $tonus{"1-9"}="h.";
# $tonus{"1-format"}="SM";
# $tonus{"1-s"}=0;
# 
# $tonus{"2-0"}="h";
# $tonus{"2-1"}="h";
# $tonus{"2-2"}="h";
# $tonus{"2-3"}="h";
# $tonus{"2-4"}="i";
# $tonus{"2-5"}="g";
# $tonus{"2-6"}="g";
# $tonus{"2-7"}="h";
# $tonus{"2-8"}="f";
# $tonus{"2-9"}="f.";
# $tonus{"2-format"}="MM";
# 
# return(%tonus)
# }


sub tonus_vi(){
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="f";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="h";
$tonus{"1-7"}="ixi";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="gh";
$tonus{"2-7"}="g";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}


sub tonus_vii(){
#=vii a
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="i";
$tonus{"1-1"}="hg";
$tonus{"1-2"}="hi";
$tonus{"1-3"}="i";
$tonus{"1-4"}="k";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-7"}="i";
$tonus{"1-8"}="j";
$tonus{"1-9"}="j.";
$tonus{"1-format"}="MM";
$tonus{"1-s"}=2;

$tonus{"flexa"}="h";

$tonus{"2-0"}="i";
$tonus{"2-1"}="i";
$tonus{"2-2"}="i";
$tonus{"2-3"}="i";
$tonus{"2-4"}="j";
$tonus{"2-5"}="i";
$tonus{"2-6"}="i";
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gf..";
$tonus{"2-format"}="MM";
$tonus{"2-s"}=0;

return(%tonus)
}

sub tonus_vii_a(){
%tonus=tonus_vii();
return(%tonus);
}


sub tonus_vii_b(){
%tonus=tonus_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="g.";
return(%tonus);
}

sub tonus_vii_c(){
%tonus=tonus_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gh..";
return(%tonus);
}

sub tonus_vii_c2(){
%tonus=tonus_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="ih.";
return(%tonus);
}

sub tonus_vii_d(){
%tonus=tonus_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gi..";
return(%tonus);
}

sub tonus_viii(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="j";
$tonus{"1-1"}="g";
$tonus{"1-2"}="h";
$tonus{"1-3"}="j";
$tonus{"1-4"}="j";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-apu"}="j";
$tonus{"1-pu"}="j";
$tonus{"1-u"}="j";
$tonus{"1-7"}="k";
$tonus{"1-8"}="j";
$tonus{"1-9"}="j.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="h";

$tonus{"2-0"}="j";
$tonus{"2-1"}="j";
$tonus{"2-2"}="j";
$tonus{"2-3"}="j";
$tonus{"2-4"}="j";
$tonus{"2-5"}="j";
$tonus{"2-6"}="j";
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="j";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}


sub tonus_viii_G(){
%tonus=tonus_viii();
return(%tonus);
}

sub tonus_viii_Gs(){
%tonus=tonus_viii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}

sub tonus_viii_c(){
%tonus=tonus_viii();
$tonus{"2-pu"}="h";
$tonus{"2-u"}="j";
$tonus{"2-7"}="k";
$tonus{"2-8"}="j";
$tonus{"2-9"}="j.";
return(%tonus);
}
# 
# 
# sub tonus_ii(){
# #=2
# %tonus=();
# $tonus{"clef"}="(f3)";
# $tonus{"1-0"}="h";
# $tonus{"1-1"}="e";
# $tonus{"1-2"}="f";
# $tonus{"1-3"}="h";
# $tonus{"1-4"}="h";
# $tonus{"1-5"}="h";
# $tonus{"1-6"}="h";
# $tonus{"1-apu"}="h";
# $tonus{"1-pu"}="h";
# $tonus{"1-u"}="h";
# $tonus{"1-7"}="i";
# $tonus{"1-8"}="h";
# $tonus{"1-9"}="h.";
# $tonus{"1-format"}="SM";
# $tonus{"1-s"}=0;
# 
# $tonus{"2-0"}="h";
# $tonus{"2-1"}="h";
# $tonus{"2-2"}="h";
# $tonus{"2-3"}="h";
# $tonus{"2-4"}="h";
# $tonus{"2-5"}="h";
# $tonus{"2-6"}="h";
# $tonus{"2-apu"}="h";
# $tonus{"2-pu"}="h";
# $tonus{"2-u"}="g";
# $tonus{"2-7"}="e";
# $tonus{"2-8"}="f";
# $tonus{"2-9"}="f.";
# $tonus{"2-format"}="SM";
# $tonus{"2-s"}=1;
# 
# return(%tonus)
# }
# 

sub tonus_peregrinus(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="ixhi";
$tonus{"1-2"}="h";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="g";
$tonus{"1-pu"}="ixi";
$tonus{"1-u"}="h";
$tonus{"1-7"}="g";
$tonus{"1-8"}="f";
$tonus{"1-9"}="f.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="g";
$tonus{"2-1"}="g";
$tonus{"2-2"}="g";
$tonus{"2-3"}="g";
$tonus{"2-4"}="g";
$tonus{"2-5"}="g";
$tonus{"2-6"}="g";
$tonus{"2-apu"}="g";
$tonus{"2-pu"}="g";
$tonus{"2-u"}="d";
$tonus{"2-7"}="f";
$tonus{"2-8"}="f";
$tonus{"2-9"}="ed..";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=1;

return(%tonus)
}


sub tonus_c_i(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="f";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="ixi";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="j";
$tonus{"1-pu"}="j";
$tonus{"1-u"}="j";
$tonus{"1-7"}="g";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="MM";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="g";
$tonus{"2-u"}="f";
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gvFED.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}



sub tonus_c_i_D(){
%tonus=tonus_c_i();
return(%tonus);
}

sub tonus_c_i_D2(){
%tonus=tonus_c_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="gf";
$tonus{"2-9"}="d.";
$tonus{"2-format"}="SW";
return(%tonus);
}

sub tonus_c_i_f(){
%tonus=tonus_c_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gf..";
return(%tonus);
}

sub tonus_c_i_g(){
%tonus=tonus_c_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
return(%tonus);
}

sub tonus_c_i_g2(){
%tonus=tonus_c_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="g";
$tonus{"2-9"}="ghg.";
return(%tonus);
}

sub tonus_c_i_a(){
%tonus=tonus_c_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="h";
$tonus{"2-9"}="h.";
return(%tonus);
}


sub tonus_c_i_a2(){
%tonus=tonus_c_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}

sub tonus_c_i_a3(){
%tonus=tonus_c_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}


sub tonus_c_ii(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="e";
$tonus{"1-2"}="f";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="h";
$tonus{"1-7"}="i";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="g";
$tonus{"2-7"}="e";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=1;

return(%tonus)
}

sub tonus_c_ii_D(){
%tonus=tonus_c_ii();
$tonus{"clef"}="(f3)";
return(%tonus);
}

sub tonus_c_ii_A(){
%tonus=tonus_c_ii();
return(%tonus);
}


sub tonus_c_iii(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="j";
$tonus{"1-1"}="g";
$tonus{"1-2"}="hj";
$tonus{"1-3"}="j";
$tonus{"1-4"}="k";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-apu"}="j";
$tonus{"1-pu"}="j";
$tonus{"1-u"}="j";
$tonus{"1-7"}="j";
$tonus{"1-8"}="ih";
$tonus{"1-9"}="j.";
$tonus{"1-format"}="MW";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="j";
$tonus{"2-1"}="j";
$tonus{"2-2"}="j";
$tonus{"2-3"}="j";
$tonus{"2-4"}="j";
$tonus{"2-5"}="j";
$tonus{"2-6"}="j";
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="j";
$tonus{"2-u"}="h";
$tonus{"2-7"}="j";
$tonus{"2-8"}="j";
$tonus{"2-9"}="i.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=1;

return(%tonus)
}


sub tonus_c_iii_b(){
%tonus=tonus_c_iii();
return(%tonus);
}

sub tonus_c_iii_a(){
%tonus=tonus_c_iii();
$tonus{"2-7"}="j";
$tonus{"2-8"}="j";
$tonus{"2-9"}="ih..";
return(%tonus);
}

sub tonus_c_iii_a2(){
%tonus=tonus_c_iii();
$tonus{"2-pu"}="ji";
$tonus{"2-u"}="hi";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
$tonus{"2-s"}=2;
return(%tonus);
}

sub tonus_c_iii_g(){
%tonus=tonus_c_iii();
$tonus{"2-pu"}="ji";
$tonus{"2-u"}="hi";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-s"}=2;
return(%tonus);
}



sub tonus_c_iv_E(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="h";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="g";
$tonus{"1-u"}="h";
$tonus{"1-7"}="i";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=2;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="g";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="ih";
$tonus{"2-7"}="g";
$tonus{"2-8"}="gf";
$tonus{"2-9"}="e.";
$tonus{"2-format"}="SW";
$tonus{"2-s"}=3;

return(%tonus)
}



sub tonus_c_iv_A(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="i";
$tonus{"1-1"}="i";
$tonus{"1-2"}="hi";
$tonus{"1-3"}="i";
$tonus{"1-4"}="i";
$tonus{"1-5"}="i";
$tonus{"1-6"}="i";
$tonus{"1-apu"}="i";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="i";
$tonus{"1-7"}="j";
$tonus{"1-8"}="i";
$tonus{"1-9"}="i.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=2;

$tonus{"flexa"}="g";

$tonus{"2-0"}="i";
$tonus{"2-1"}="i";
$tonus{"2-2"}="i";
$tonus{"2-3"}="i";
$tonus{"2-4"}="i";
$tonus{"2-5"}="i";
$tonus{"2-6"}="i";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="j";
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=3;

return(%tonus)
}

sub tonus_c_iv_As(){
%tonus=tonus_c_iv_A();
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="fg..";
return(%tonus);
}


sub tonus_c_v_a(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="d";
$tonus{"1-2"}="f";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="h";
$tonus{"1-7"}="i";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="i";
$tonus{"2-5"}="g";
$tonus{"2-6"}="g";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="h";
$tonus{"2-7"}="i";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="MM";
$tonus{"2-s"}=0;

return(%tonus)
}


sub tonus_c_vi_F(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="f";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="g";
$tonus{"1-7"}="h";
$tonus{"1-8"}="f";
$tonus{"1-9"}="f.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=1;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="f";
$tonus{"2-u"}="gh";
$tonus{"2-7"}="g";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}

sub tonus_c_vi_C(){
%tonus=tonus_c_vi_F();
$tonus{"clef"}="(c2)";
return(%tonus);
}

sub tonus_c_vii(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="i";
$tonus{"1-1"}="hg";
$tonus{"1-2"}="hi";
$tonus{"1-3"}="i";
$tonus{"1-4"}="k";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-apu"}="i";
$tonus{"1-pu"}="i";
$tonus{"1-u"}="i";
$tonus{"1-7"}="i";
$tonus{"1-8"}="j";
$tonus{"1-9"}="j.";
$tonus{"1-format"}="MM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="i";
$tonus{"2-1"}="i";
$tonus{"2-2"}="i";
$tonus{"2-3"}="i";
$tonus{"2-4"}="j";
$tonus{"2-5"}="i";
$tonus{"2-6"}="i";
$tonus{"2-apu"}="i";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="i";
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gf..";
$tonus{"2-format"}="MM";
$tonus{"2-s"}=2;

return(%tonus)
}


sub tonus_c_vii_a(){
%tonus=tonus_c_vii();
return(%tonus);
}

sub tonus_c_vii_b(){
%tonus=tonus_c_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="g.";
return(%tonus);
}

sub tonus_c_vii_c(){
%tonus=tonus_c_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gh..";
return(%tonus);
}

sub tonus_c_vii_c2(){
%tonus=tonus_c_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="ih..";
return(%tonus);
}

sub tonus_c_vii_d(){
%tonus=tonus_c_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gi..";
return(%tonus);
}


sub tonus_c_viii(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="j";
$tonus{"1-1"}="g";
$tonus{"1-2"}="h";
$tonus{"1-3"}="j";
$tonus{"1-4"}="j";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-apu"}="j";
$tonus{"1-pu"}="j";
$tonus{"1-u"}="j";
$tonus{"1-7"}="k";
$tonus{"1-8"}="j";
$tonus{"1-9"}="j.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="j";
$tonus{"2-1"}="j";
$tonus{"2-2"}="j";
$tonus{"2-3"}="j";
$tonus{"2-4"}="j";
$tonus{"2-5"}="j";
$tonus{"2-6"}="j";
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="j";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}


sub tonus_c_viii_G(){
%tonus=tonus_c_viii();
return(%tonus);
}

sub tonus_c_viii_Gs(){
%tonus=tonus_c_viii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gh..";
return(%tonus);
}


sub tonus_c_viii_c(){
%tonus=tonus_c_viii();
$tonus{"2-pu"}="h";
$tonus{"2-u"}="j";
$tonus{"2-7"}="k";
$tonus{"2-8"}="j";
$tonus{"2-9"}="j.";
return(%tonus);
}



sub tonus_cs_i(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="f";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="ixi";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="hg";
$tonus{"1-pu"}="ixgi";
$tonus{"1-u"}="h";
$tonus{"1-7"}="h";
$tonus{"1-8"}="hg";
$tonus{"1-9"}="gh..";
$tonus{"1-format"}="SW";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="g";
$tonus{"2-u"}="f";
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gvFED.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}



sub tonus_cs_i_D(){
%tonus=tonus_cs_i();
return(%tonus);
}

sub tonus_cs_i_D2(){
%tonus=tonus_cs_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="gf";
$tonus{"2-9"}="d.";
$tonus{"2-format"}="SW";
return(%tonus);
}

sub tonus_cs_i_f(){
%tonus=tonus_cs_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gf..";
return(%tonus);
}

sub tonus_cs_i_g(){
%tonus=tonus_cs_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
return(%tonus);
}

sub tonus_cs_i_g2(){
%tonus=tonus_cs_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="g";
$tonus{"2-9"}="ghg.";
return(%tonus);
}

sub tonus_cs_i_a(){
%tonus=tonus_cs_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="h";
$tonus{"2-9"}="h.";
return(%tonus);
}


sub tonus_cs_i_a2(){
%tonus=tonus_cs_i();
$tonus{"2-7"}="g";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}

sub tonus_cs_i_a3(){
%tonus=tonus_cs_i();
$tonus{"2-7"}="gh";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}


sub tonus_cs_ii(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="e";
$tonus{"1-2"}="f";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="hg";
$tonus{"1-pu"}="hi";
$tonus{"1-u"}="i";
$tonus{"1-7"}="hi";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="g";
$tonus{"2-7"}="e";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=1;

return(%tonus)
}

sub tonus_cs_ii_D(){
%tonus=tonus_cs_ii();
$tonus{"clef"}="(f3)";
return(%tonus);
}

sub tonus_cs_ii_A(){
%tonus=tonus_cs_ii();
return(%tonus);
}


sub tonus_cs_iii(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="j";
$tonus{"1-1"}="g";
$tonus{"1-2"}="hj";
$tonus{"1-3"}="j";
$tonus{"1-4"}="jk";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-apu"}="j";
$tonus{"1-pu"}="j";
$tonus{"1-u"}="j";
$tonus{"1-7"}="j";
$tonus{"1-8"}="ih";
$tonus{"1-9"}="hj..";
$tonus{"1-format"}="MW";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="j";
$tonus{"2-1"}="j";
$tonus{"2-2"}="j";
$tonus{"2-3"}="j";
$tonus{"2-4"}="j";
$tonus{"2-5"}="j";
$tonus{"2-6"}="j";
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="j";
$tonus{"2-u"}="h";
$tonus{"2-7"}="j";
$tonus{"2-8"}="j";
$tonus{"2-9"}="i.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=1;

return(%tonus)
}


sub tonus_cs_iii_b(){
%tonus=tonus_cs_iii();
return(%tonus);
}

sub tonus_cs_iii_a(){
%tonus=tonus_cs_iii();
$tonus{"2-7"}="j";
$tonus{"2-8"}="j";
$tonus{"2-9"}="ih..";
return(%tonus);
}

sub tonus_cs_iii_a2(){
%tonus=tonus_cs_iii();
$tonus{"2-pu"}="ji";
$tonus{"2-u"}="hi";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
$tonus{"2-s"}=2;
return(%tonus);
}

sub tonus_cs_iii_g(){
%tonus=tonus_cs_iii();
$tonus{"2-pu"}="ji";
$tonus{"2-u"}="hi";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-s"}=2;
return(%tonus);
}



sub tonus_cs_iv_E(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="h";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="hg";
$tonus{"1-pu"}="gi";
$tonus{"1-u"}="i";
$tonus{"1-7"}="hi";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="g";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="ih";
$tonus{"2-7"}="g";
$tonus{"2-8"}="gf";
$tonus{"2-9"}="e.";
$tonus{"2-format"}="SW";
$tonus{"2-s"}=3;

return(%tonus)
}



sub tonus_cs_iv_A(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="i";
$tonus{"1-1"}="i";
$tonus{"1-2"}="hi";
$tonus{"1-3"}="i";
$tonus{"1-4"}="i";
$tonus{"1-5"}="i";
$tonus{"1-6"}="i";
$tonus{"1-apu"}="ih";
$tonus{"1-pu"}="hj";
$tonus{"1-u"}="j";
$tonus{"1-7"}="ij";
$tonus{"1-8"}="i";
$tonus{"1-9"}="i.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="i";
$tonus{"2-1"}="i";
$tonus{"2-2"}="i";
$tonus{"2-3"}="i";
$tonus{"2-4"}="i";
$tonus{"2-5"}="i";
$tonus{"2-6"}="i";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="j";
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=3;

return(%tonus)
}

sub tonus_cs_iv_As(){
%tonus=tonus_cs_iv_A();
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="fg..";
return(%tonus);
}


sub tonus_cs_v_a(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="d";
$tonus{"1-2"}="f";
$tonus{"1-3"}="h";
$tonus{"1-4"}="h";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="h";
$tonus{"1-pu"}="h";
$tonus{"1-u"}="i";
$tonus{"1-7"}="i";
$tonus{"1-8"}="h";
$tonus{"1-9"}="h.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=1;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="i";
$tonus{"2-5"}="g";
$tonus{"2-6"}="g";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="h";
$tonus{"2-u"}="h";
$tonus{"2-7"}="h";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="MM";
$tonus{"2-s"}=0;

return(%tonus)
}


sub tonus_cs_vi_F(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="h";
$tonus{"1-1"}="f";
$tonus{"1-2"}="gh";
$tonus{"1-3"}="h";
$tonus{"1-4"}="ixi";
$tonus{"1-5"}="h";
$tonus{"1-6"}="h";
$tonus{"1-apu"}="hg";
$tonus{"1-pu"}="gixi";
$tonus{"1-u"}="h";
$tonus{"1-7"}="h";
$tonus{"1-8"}="hg";
$tonus{"1-9"}="gh..";
$tonus{"1-format"}="SW";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="h";
$tonus{"2-1"}="h";
$tonus{"2-2"}="h";
$tonus{"2-3"}="h";
$tonus{"2-4"}="h";
$tonus{"2-5"}="h";
$tonus{"2-6"}="h";
$tonus{"2-apu"}="h";
$tonus{"2-pu"}="f";
$tonus{"2-u"}="gh";
$tonus{"2-7"}="g";
$tonus{"2-8"}="f";
$tonus{"2-9"}="f.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}

sub tonus_cs_vi_C(){
%tonus=tonus_cs_vi_F();
$tonus{"clef"}="(c2)";
return(%tonus);
}

sub tonus_cs_vii(){
#=3d
%tonus=();
$tonus{"clef"}="(c3)";
$tonus{"1-0"}="i";
$tonus{"1-1"}="hg";
$tonus{"1-2"}="hi";
$tonus{"1-3"}="i";
$tonus{"1-4"}="ik";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-apu"}="i";
$tonus{"1-pu"}="i";
$tonus{"1-u"}="i";
$tonus{"1-7"}="j";
$tonus{"1-8"}="ji";
$tonus{"1-9"}="ij..";
$tonus{"1-format"}="MW";
$tonus{"1-s"}=0;

$tonus{"flexa"}="g";

$tonus{"2-0"}="i";
$tonus{"2-1"}="i";
$tonus{"2-2"}="i";
$tonus{"2-3"}="i";
$tonus{"2-4"}="j";
$tonus{"2-5"}="i";
$tonus{"2-6"}="i";
$tonus{"2-apu"}="i";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="i";
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gf..";
$tonus{"2-format"}="MM";
$tonus{"2-s"}=2;

return(%tonus)
}


sub tonus_cs_vii_a(){
%tonus=tonus_cs_vii();
return(%tonus);
}

sub tonus_cs_vii_b(){
%tonus=tonus_cs_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="g.";
return(%tonus);
}

sub tonus_cs_vii_c(){
%tonus=tonus_cs_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gh..";
return(%tonus);
}

sub tonus_cs_vii_c2(){
%tonus=tonus_cs_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="ih..";
return(%tonus);
}

sub tonus_cs_vii_d(){
%tonus=tonus_cs_vii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="h";
$tonus{"2-9"}="gi..";
return(%tonus);
}


sub tonus_cs_viii(){
#=3d
%tonus=();
$tonus{"clef"}="(c4)";
$tonus{"1-0"}="j";
$tonus{"1-1"}="g";
$tonus{"1-2"}="h";
$tonus{"1-3"}="j";
$tonus{"1-4"}="j";
$tonus{"1-5"}="j";
$tonus{"1-6"}="j";
$tonus{"1-apu"}="ji";
$tonus{"1-pu"}="jk";
$tonus{"1-u"}="k";
$tonus{"1-7"}="jk";
$tonus{"1-8"}="j";
$tonus{"1-9"}="j.";
$tonus{"1-format"}="SM";
$tonus{"1-s"}=3;

$tonus{"flexa"}="g";

$tonus{"2-0"}="j";
$tonus{"2-1"}="j";
$tonus{"2-2"}="j";
$tonus{"2-3"}="j";
$tonus{"2-4"}="j";
$tonus{"2-5"}="j";
$tonus{"2-6"}="j";
$tonus{"2-apu"}="j";
$tonus{"2-pu"}="i";
$tonus{"2-u"}="j";
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="g.";
$tonus{"2-format"}="SM";
$tonus{"2-s"}=2;

return(%tonus)
}


sub tonus_cs_viii_G(){
%tonus=tonus_cs_viii();
return(%tonus);
}

sub tonus_cs_viii_Gs(){
%tonus=tonus_cs_viii();
$tonus{"2-7"}="h";
$tonus{"2-8"}="g";
$tonus{"2-9"}="gh..";
return(%tonus);
}


sub tonus_cs_viii_c(){
%tonus=tonus_cs_viii();
$tonus{"2-pu"}="h";
$tonus{"2-u"}="j";
$tonus{"2-7"}="k";
$tonus{"2-8"}="j";
$tonus{"2-9"}="j.";
return(%tonus);
}



sub select_tonus(){
$sel=shift;
#print "-sel-".$sel."-";
%tonus=();
if ($sel eq "1_D"){%tonus=tonus_i_D();}
if ($sel eq "1_D1"){%tonus=tonus_i_D1();}
if ($sel eq "1_D2"){%tonus=tonus_i_D2();}
if ($sel eq "1_f"){%tonus=tonus_i_f();}
if ($sel eq "1_g"){%tonus=tonus_i_g();}
if ($sel eq "1_g2"){%tonus=tonus_i_g2();}
if ($sel eq "1_g3"){%tonus=tonus_i_g3();}
if ($sel eq "1_a"){%tonus=tonus_i_a();}
if ($sel eq "1_a2"){%tonus=tonus_i_a2();}
if ($sel eq "1_a3"){%tonus=tonus_i_a3();}
if ($sel eq "2"){%tonus=tonus_ii();}
if ($sel eq "3_b"){%tonus=tonus_iii_b();}
if ($sel eq "3_a"){%tonus=tonus_iii_a();}
if ($sel eq "3_a2"){%tonus=tonus_iii_a2();}
if ($sel eq "3_g"){%tonus=tonus_iii_g();}
if ($sel eq "3_g2"){%tonus=tonus_iii_g2();}
if ($sel eq "4_g"){%tonus=tonus_iv_g();}
if ($sel eq "4_E"){%tonus=tonus_iv_E();}
if ($sel eq "4_c"){%tonus=tonus_iv_c();}
if ($sel eq "4_A"){%tonus=tonus_iv_A();}
if ($sel eq "4_As"){%tonus=tonus_iv_As();}
if ($sel eq "5"){%tonus=tonus_v();}
if ($sel eq "6"){%tonus=tonus_vi();}
if ($sel eq "7_a"){%tonus=tonus_vii_a();}
if ($sel eq "7_b"){%tonus=tonus_vii_b();}
if ($sel eq "7_c"){%tonus=tonus_vii_c();}
if ($sel eq "7_c2"){%tonus=tonus_vii_c2();}
if ($sel eq "7_d"){%tonus=tonus_vii_d();}
if ($sel eq "8_G"){%tonus=tonus_viii_G();}
if ($sel eq "8_Gs"){%tonus=tonus_viii_Gs();}
if ($sel eq "8_c"){%tonus=tonus_viii_c();}
if ($sel eq "Per"){%tonus=tonus_peregrinus();}
if ($sel eq "C_1_D"){%tonus=tonus_c_i_D();}
if ($sel eq "C_1_D2"){%tonus=tonus_c_i_D2();}
if ($sel eq "C_1_f"){%tonus=tonus_c_i_f();}
if ($sel eq "C_1_g"){%tonus=tonus_c_i_g();}
if ($sel eq "C_1_g2"){%tonus=tonus_c_i_g2();}
if ($sel eq "C_1_a"){%tonus=tonus_c_i_a();}
if ($sel eq "C_1_a2"){%tonus=tonus_c_i_a2();}
if ($sel eq "C_1_a3"){%tonus=tonus_c_i_a3();}
if ($sel eq "C_2_D"){%tonus=tonus_c_ii_D();}
if ($sel eq "C_2_A"){%tonus=tonus_c_ii_A();}
if ($sel eq "C_3_b"){%tonus=tonus_c_iii_b();}
if ($sel eq "C_3_a"){%tonus=tonus_c_iii_a();}
if ($sel eq "C_3_a2"){%tonus=tonus_c_iii_a2();}
if ($sel eq "C_3_g"){%tonus=tonus_c_iii_g();}
if ($sel eq "C_4_E"){%tonus=tonus_c_iv_E();}
if ($sel eq "C_4_A"){%tonus=tonus_c_iv_A();}
if ($sel eq "C_4_As"){%tonus=tonus_c_iv_As();}
if ($sel eq "C_5_a"){%tonus=tonus_c_v_a();}
if ($sel eq "C_6_F"){%tonus=tonus_c_vi_F();}
if ($sel eq "C_6_C"){%tonus=tonus_c_vi_C();}
if ($sel eq "C_7_a"){%tonus=tonus_c_vii_a();}
if ($sel eq "C_7_b"){%tonus=tonus_c_vii_b();}
if ($sel eq "C_7_c"){%tonus=tonus_c_vii_c();}
if ($sel eq "C_7_c2"){%tonus=tonus_c_vii_c2();}
if ($sel eq "C_7_d"){%tonus=tonus_c_vii_d();}
if ($sel eq "C_8_G"){%tonus=tonus_c_viii_G();}
if ($sel eq "C_8_Gs"){%tonus=tonus_c_viii_Gs();}
if ($sel eq "C_8_c"){%tonus=tonus_c_viii_c();}
if ($sel eq "CS_1_D"){%tonus=tonus_cs_i_D();}
if ($sel eq "CS_1_D2"){%tonus=tonus_cs_i_D2();}
if ($sel eq "CS_1_f"){%tonus=tonus_cs_i_f();}
if ($sel eq "CS_1_g"){%tonus=tonus_cs_i_g();}
if ($sel eq "CS_1_g2"){%tonus=tonus_cs_i_g2();}
if ($sel eq "CS_1_a"){%tonus=tonus_cs_i_a();}
if ($sel eq "CS_1_a2"){%tonus=tonus_cs_i_a2();}
if ($sel eq "CS_1_a3"){%tonus=tonus_cs_i_a3();}
if ($sel eq "CS_2_D"){%tonus=tonus_cs_ii_D();}
if ($sel eq "CS_2_A"){%tonus=tonus_cs_ii_A();}
if ($sel eq "CS_3_b"){%tonus=tonus_cs_iii_b();}
if ($sel eq "CS_3_a"){%tonus=tonus_cs_iii_a();}
if ($sel eq "CS_3_a2"){%tonus=tonus_cs_iii_a2();}
if ($sel eq "CS_3_g"){%tonus=tonus_cs_iii_g();}
if ($sel eq "CS_4_E"){%tonus=tonus_cs_iv_E();}
if ($sel eq "CS_4_A"){%tonus=tonus_cs_iv_A();}
if ($sel eq "CS_4_As"){%tonus=tonus_cs_iv_As();}
if ($sel eq "CS_5_a"){%tonus=tonus_cs_v_a();}
if ($sel eq "CS_6_F"){%tonus=tonus_cs_vi_F();}
if ($sel eq "CS_6_C"){%tonus=tonus_cs_vi_C();}
if ($sel eq "CS_7_a"){%tonus=tonus_cs_vii_a();}
if ($sel eq "CS_7_b"){%tonus=tonus_cs_vii_b();}
if ($sel eq "CS_7_c"){%tonus=tonus_cs_vii_c();}
if ($sel eq "CS_7_c2"){%tonus=tonus_cs_vii_c2();}
if ($sel eq "CS_7_d"){%tonus=tonus_cs_vii_d();}
if ($sel eq "CS_8_G"){%tonus=tonus_c_viii_G();}
if ($sel eq "CS_8_Gs"){%tonus=tonus_c_viii_Gs();}
if ($sel eq "CS_8_c"){%tonus=tonus_c_viii_c();}

return(%tonus);
}





sub replace_exceptions(){
my $totum=shift;


$totum=~s/æquitas/ǽ~qui~tas/g;
$totum=~s/Æquitas/Ǽ~qui~tas/g;
$totum=~s/æquitáte/æ~qui~tá~te/g;
$totum=~s/Ægýpti/Æ~gýp~ti/g;
$totum=~s/Ægýpto/Æ~gýp~to/g;
$totum=~s/Ægypto/Æ~gýp~to/g;
$totum=~s/aquárum/a~quá~rum/g;
$totum=~s/æreum,/ǽ~re~um,/g;
$totum=~s/Æthíopum/Æ~thí~o~pum/g;
$totum=~s/Æthíopes/Æ~thí~o~pes/g;
$totum=~s/adhæret/ad~hǽ~ret/g;
$totum=~s/Adhæreat/Ad~hǽ~re~at/g;
$totum=~s/adhæsit/ad~hǽ~sit/g;
$totum=~s/Adhæsit/Ad~hǽ~sit/g;
$totum=~s/Adhæsi/Ad~hǽ~si/g;
$totum=~s/adhuc/ad~huc/g;
$totum=~s/Adhuc/Ad~huc/g;
$totum=~s/ádjuva/ád~ju~va/g;
$totum=~s/Allevat/Al~lé~vat/g;
$totum=~s/Amorrhæórum/A~mor~rhæ~ó~rum/g;
$totum=~s/Amplius/Ám~pli~us/g;
$totum=~s/ancíllæ/an~cí~llæ/g;
$totum=~s/Aperis/A~pé~ris/g;
$totum=~s/Aruit/Á~ru~it/g;
$totum=~s/aquæ/a~quæ/g;
$totum=~s/Audivit/Au~dí~vit/g;
$totum=~s/Audiam/Áu~di~am/g;
$totum=~s/Audient/Áu~di~ent/g;

$totum=~s/circúmdabit/cir~cúm~da~bit/g;
$totum=~s/circúmdedit/cir~cúm~de~dit/g;
$totum=~s/cœnomyía/cœ~no~my~í~a/g;
$totum=~s/Confitebor/Con~fi~té~bor/g;

$totum=~s/Domino/Dó~mi~no/g;
$totum=~s/Domine,/Dó~mi~ne/g;
$totum=~s/diéi/di~é~i/g;
$totum=~s/déerit/dé~e~rit/g;

$totum=~s/eorum/eórum/g;
$totum=~s/Ephrem/Eph~rem/g;
$totum=~s/érigens/é~ri~gens/g;
$totum=~s/Erue/É~ru~e/g;
$totum=~s/euge/é~u~ge/g;
$totum=~s/Euge/É~u~ge/g;

$totum=~s/faciéi/fa~ci~é~i/g;
$totum=~s/faciéntibus/fa~ci~én~ti~bus/g;
$totum=~s/filias/fí~li~as/g;
$totum=~s/fremuérunt/fre~mu~é~runt/g;
$totum=~s/Fílio/Fí~li~o/g;

$totum=~s/Ideo/Í~de~o/g;
$totum=~s/Idumæam/I~du~mǽ~am/g;
$totum=~s/Idumæórum/I~du~mæ~ó~rum/g;
$totum=~s/Impleat/Ím~ple~at/g;
$totum=~s/ímpii/ím~pi~i/g;
$totum=~s/iræ/i~ræ/g;
$totum=~s/Israël/Is~rá~el/g;

$totum=~s/Joseph/Jo~seph/g;
$totum=~s/Jubilate/Ju~bi~lá~te/g;

$totum=~s/lingua/lín~gu~a/g;
$totum=~s/Lingua/Lín~gu~a/g;
$totum=~s/linguæ/lín~gu~æ/g;
$totum=~s/linguis/lín~gu~is/g;
$totum=~s/Linguam/Lín~gu~am/g;
$totum=~s/linguis/lín~gu~is/g;

$totum=~s/Melchísedech/Mel~chí~se~dech/g;
$totum=~s/Memento,/Me~mén~to,/g;

$totum=~s/Omnia/Óm~ni~a/g;
$totum=~s/ópera/ó~pe~ra/g;

$totum=~s/Præparans/Prǽ~pa~rans/g;
$totum=~s/prædicans/prǽ~di~cans/g;
$totum=~s/prælia/prǽlia/g;
$totum=~s/prælio/prǽlio/g;
$totum=~s/prælium/prǽlium/g;
$totum=~s/períbit/per~í~bit/g;
$totum=~s/pinguis/pín~gu~is/g;
$totum=~s/pingue/pín~gu~e/g;
$totum=~s/pingues/pín~gu~es/g;
$totum=~s/populum/pó~pu~lum/g;
$totum=~s/profundis/pro~fún~dis/g;
$totum=~s/psalmi/psal~mi/g;
$totum=~s/psalmum/psal~mum/g;
$totum=~s/psallat/psal~lat/g;
$totum=~s/psallant/psal~lant/g;
$totum=~s/psalmum/psal~mum/g;
$totum=~s/psalmus/psal~mus/g;
$totum=~s/psallam/psal~lam/g;
$totum=~s/Psallam,/Psal~lam/g;
$totum=~s/púeri/pú~er~i/g;


$totum=~s/quærant/quæ~rant/g;
$totum=~s/quære/quæ~re/g;
$totum=~s/quærens/quæ~rens/g;
$totum=~s/quærent/quæ~rent/g;
$totum=~s/quæres/quæ~res/g;
$totum=~s/quæret/quæ~ret/g;
$totum=~s/quærit/quæ~rit/g;
$totum=~s/quæritis/quǽ~ri~tis/g;
$totum=~s/quærunt/quæ~runt/g;
$totum=~s/quámdiu/quám~di~u/g;

$totum=~s/reverentia/re~ve~rén~ti~a/g;

$totum=~s/sæcula/sǽcula/g;
$totum=~s/sæculi/sǽculi/g;
$totum=~s/sæculum/sǽculum/g;
$totum=~s/suæ/su~æ/g;

$totum=~s/tædio:/tǽ~di~o/g;
$totum=~s/tuæ/tu~æ/g;
$totum=~s/thronus/thro~nus/g;
$totum=~s/thronum/thro~num/g;

$totum=~s/Ultio/Úl~ti~o/g;
$totum=~s/unguéntum/un~gu~én~tum/g;
return($totum);
}
####### ####### ####### ####### ####### ####### ####### 
####### ####### ####### ####### ####### ####### ####### 
####### ####### ####### ####### ####### ####### ####### 


sub format_pars_MM(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;
	$pum=$i-2;
	$apum=$i-3;
	$t=$pars;
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);

	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;
	print "INITIUM INITIUM INITIUM INITIUM INITIUM INITIUM ";}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==5){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
	if ($s==6){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;
		if ($schema !~ /5/){
		print OUT "(".$tonus{$t."-5"}."r)".$sp;
		}
	}
	if ($pars==0){
		if ($s==4){print OUT "".$syllables[$i].""."(".$tonus{$tt}.")".$sp;}
		if ($s==7){print OUT "".$syllables[$i].""."(".$tonus{$tt}.")".$sp;}
	}
	if ($pars==1){
		if ($s==4){print OUT "<v>\\iaccpu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
		if ($s==7){print OUT "<v>\\iaccu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	}
	if ($pars==2){
		if ($s==4){print OUT "<v>\\iiaccpu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
		if ($s==7){print OUT "<v>\\iiaccu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	}

	if ($s==8){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
	if ($s==9){	
		if ($schema !~ /8/){
		print OUT "(".$tonus{$t."-8"}."r)".$sp;
		}
	print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;
	}

}

if ($print_music!=1){
	if ($pars==0){
		if ($s==4){print OUTi "".$syllables[$i]."".$sp;}
		if ($s==7){print OUTi "".$syllables[$i]."".$sp;}
	}
	if ($pars==1){
		if ($s==4){print OUTi "\\iaccpu{".$syllables[$i]."}\\-".$sp;}
		if ($s==7){print OUTi "\\iaccu{".$syllables[$i]."}\\-".$sp;}
	}
	if ($pars==2){
		if ($s==4){print OUTi "\\iiaccpu{".$syllables[$i]."}\\-".$sp;}
		if ($s==7){print OUTi "\\iiaccu{".$syllables[$i]."}\\-".$sp;}
	}

		if ($s==1){print OUTi $syllables[$i].$sp;}
		if ($s==2){print OUTi $syllables[$i].$sp;}
		if ($s==3){print OUTi $syllables[$i].$sp;}
		if ($s==0){print OUTi $syllables[$i].$sp;}
		if ($s==5){print OUTi $syllables[$i].$sp;}
		if ($s==6){print OUTi $syllables[$i].$sp;}
		if ($s==8){print OUTi $syllables[$i].$sp;}
		if ($s==9){print OUTi $syllables[$i].$sp;}
}

	}
}

sub format_pars_MW(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
#	if ($schema !~ "8"){$schema=~s/7/8/;}
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;
	$pum=$i-2;
	$apum=$i-3;
	$t=$pars;
	if ($pars==1){$ip="i";}
	if ($pars==2){$ip="ii";}
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);

	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==4){print OUT "<v>\\".$ip."accpu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	if ($s==5){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
	if ($s==6){
		if ($schema !~ /5/){
		print OUT "(".$tonus{$t."-5"}."r)";
#		print OUT $syllables[$i]."(".$tonus{$t."-5"}."r".$tonus{$tt}.")".$sp;
		}
#		else{
		print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;
#		}
	}
}
if ($schema =~ "8"){
	 if ($s==7){
if ($print_music==1){print OUT "<v>\\".$ip."sa{".$syllables[$i]."}</v>"."(".$tonus{$tt}."r[ocba:1{])".$sp;}
if ($print_music!=1){print OUTi "\\".$ip."sa{".$syllables[$i]."}\\-".$sp;}
	 }
 }else{
	 if ($s==7){
if ($print_music==1){
$tt=$t."-7";
print OUT "<v> </v>	(".$tonus{$tt}."r[ocba:1{]) ".$sp;
$tt=$t."-8";
print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}."[ocba:0}])".$sp;}
#print OUT $syllables[$i]."(".$tonus{$tt}."[ocba:0}])".$sp;}
if ($print_music!=1){print OUTi "\\".$ip."accu{".$syllables[$i]."}\\-".$sp;}
	 }
 }
 
 if ($print_music==1){
	if ($s==8){print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}."[ocba:0}])".$sp;}
	if ($s==9){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($print_music!=1){
	if ($s==1){print OUTi $syllables[$i].$sp;}
	if ($s==2){print OUTi $syllables[$i].$sp;}
	if ($s==3){print OUTi $syllables[$i].$sp;}
	if ($s==0){print OUTi $syllables[$i].$sp;}
	if ($s==4){print OUTi "\\".$ip."accpu{".$syllables[$i]."}".$sp;}
	if ($s==5){print OUTi $syllables[$i].$sp;}
	if ($s==6){print OUTi $syllables[$i].$sp;}
	if ($s==8){print OUTi "\\".$ip."accu{".$syllables[$i]."}\\-".$sp;}
	if ($s==9){print OUTi $syllables[$i].$sp;}
}

	}
}

# sub format_pars_SW(){
# my	($pars,$lw,$schema,%tonus)=@_;
# print "\n".$schema."\n";
# if ($schema !~ "8"){$schema=~s/7/8/;}
# print "\n".$schema."\n";
# format_pars_SM("1",$lw,$schema,%tonus);
# }

sub format_pars_SM(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;$pum=$i-2;$apum=$i-3;
print $n." ".$apum." ".$pum." ".$um;
#print "\n";
	$t=$pars;
	if ($pars==0){$t="1";}
	if ($pars==1){$ip="i";}
	if ($pars==2){$ip="ii";}
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);
#	print $i."x".$s."-";
	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($i < $apum){
	if ($print_music==1){if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}}
	if ($print_music!=1){if ($s==0){print OUTi $syllables[$i].$sp;}}
}
if ($print_music==1){
	if ($pars!=0){
	if ($s==7){print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	}
	else{
	if ($s==7){print OUT "".$syllables[$i].""."(".$tonus{$tt}.")".$sp;}	
	}
	if ($s==8){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
	if ($s==9){	
		if ($schema !~ /8/){
		print OUT "(".$tonus{$t."-8"}."r)".$sp;
		}
		print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;
	}
}
if ($print_music!=1){
	if ($s==1){print OUTi $syllables[$i].$sp;}
	if ($s==2){print OUTi $syllables[$i].$sp;}
	if ($s==3){print OUTi $syllables[$i].$sp;}
	if ($pars != 0){
	if ($s==7){print OUTi "\\".$ip."accu{".$syllables[$i]."}\\-".$sp;}
	}
	else{
	if ($s==7){print OUTi "".$syllables[$i]."".$sp;}
	
	}
	if ($s==8){print OUTi $syllables[$i].$sp;}
	if ($s==9){print OUTi $syllables[$i].$sp;}
}

if ($tonus{$t."-s"} == "0"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}

	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}	
}

if ($tonus{$t."-s"} == "1"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}\\-".$sp;}
	}	
}

if ($tonus{$t."-s"} == "2"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}\\-".$sp;}
	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}\\-".$sp;}
	}	
}

if ($tonus{$t."-s"} == "3"){
	if ($i==$apum){$tt=$t."-apu";
#print " apu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylapu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylapu{".$syllables[$i]."}\\-".$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
#print " pu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}\\-".$sp;}

	}
	if ($i==$um){$tt=$t."-u";
#print " u ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}\\-".$sp;}
	}	
}

}

}


sub format_pars_SW(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;$pum=$i-2;$apum=$i-3;
#	if ($schema !~ "8"){$schema=~s/7/8/;}
#print $n." ".$apum." ".$pum." ".$um;
#print "\n";
#print $schema;
	$t=$pars;
	if ($pars==1){$ip="i";}
	if ($pars==2){$ip="ii";}
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);
#	print $i."x".$s."-";
	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($i < $apum){
if ($print_music==1){if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}}
if ($print_music!=1){if ($s==0){print OUTi $syllables[$i].$sp;}}
}

	 if ($schema !~ "8"){
		if ($s==7){
			if ($print_music==1){
			$tt=$t."-7";
			print OUT "(".$tonus{$tt}."r[ocba:1{])".$sp;
			$tt=$t."-8";
			print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}."[ocba:0}])".$sp;
			}
		if ($print_music!=1){print OUTi "\\".$ip."accu{".$syllables[$i]."}\\-".$sp;}
		}
	}else{
		if ($s==7){
		if ($print_music==1){print OUT "<v>\\".$ip."sa{".$syllables[$i]."}</v>"."(".$tonus{$tt}."r[ocba:1{])".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sa{".$syllables[$i]."}\\-".$sp;}
		}
	}

if ($print_music==1){	
	if ($s==8){print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}."[ocba:0}])".$sp;}	
	if ($s==9){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}

if ($print_music!=1){
	if ($s==1){print OUTi $syllables[$i].$sp;}
	if ($s==2){print OUTi $syllables[$i].$sp;}
	if ($s==3){print OUTi $syllables[$i].$sp;}
	if ($s==8){print OUTi "\\".$ip."accu{".$syllables[$i]."}\\-".$sp;}
	if ($s==9){print OUTi $syllables[$i].$sp;}
}

if ($tonus{$t."-s"} == "0"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}	
}
if ($tonus{$t."-s"} == "1"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}\\-".$sp;}
	}	
}

if ($tonus{$t."-s"} == "2"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}\\-".$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}\\-".$sp;}
	}	
}

if ($tonus{$t."-s"} == "3"){
	if ($i==$apum){$tt=$t."-apu";
#print " apu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylapu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylapu{".$syllables[$i]."}\\-".$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
#print " pu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}\\-".$sp;}

	}
	if ($i==$um){$tt=$t."-u";
#print " u ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}\\-".$sp;}
	}	
}

}

}


####### ####### ####### ####### ####### ####### ####### 
####### ####### ####### ####### ####### ####### ####### 
####### ####### ####### ####### ####### ####### ####### 


sub format_pars_MM_no_blank(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;
	$pum=$i-2;
	$apum=$i-3;
	$t=$pars;
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);

	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==5){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==6){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
if ($pars==1){
	if ($s==4){print OUT "<v>\\iaccpu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	if ($s==7){print OUT "<v>\\iaccu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
}
if ($pars==2){
	if ($s==4){print OUT "<v>\\iiaccpu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	if ($s==7){print OUT "<v>\\iiaccu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
}

	if ($s==8){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
	if ($s==9){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}

if ($print_music!=1){
	if ($pars==1){
		if ($s==4){print OUTi "\\iaccpu{".$syllables[$i]."}".$sp;}
		if ($s==7){print OUTi "\\iaccu{".$syllables[$i]."}".$sp;}
	}
	if ($pars==2){
		if ($s==4){print OUTi "\\iiaccpu{".$syllables[$i]."}".$sp;}
		if ($s==7){print OUTi "\\iiaccu{".$syllables[$i]."}".$sp;}
	}

		if ($s==1){print OUTi $syllables[$i].$sp;}
		if ($s==2){print OUTi $syllables[$i].$sp;}
		if ($s==3){print OUTi $syllables[$i].$sp;}
		if ($s==0){print OUTi $syllables[$i].$sp;}
		if ($s==5){print OUTi $syllables[$i].$sp;}
		if ($s==6){print OUTi $syllables[$i].$sp;}
		if ($s==8){print OUTi $syllables[$i].$sp;}
		if ($s==9){print OUTi $syllables[$i].$sp;}
}

	}
}

sub format_pars_MW_no_blank(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
#	if ($schema !~ "8"){$schema=~s/7/8/;}
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;
	$pum=$i-2;
	$apum=$i-3;
	$t=$pars;
	if ($pars==1){$ip="i";}
	if ($pars==2){$ip="ii";}
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);

	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==4){print OUT "<v>\\".$ip."accpu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	if ($s==5){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
	if ($s==6){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
 if ($schema =~ "8"){
	 if ($s==7){
if ($print_music==1){print OUT "<v>\\".$ip."sa{".$syllables[$i]."}</v>"."(".$tonus{$tt}."r)".$sp;}
if ($print_music!=1){print OUTi "\\".$ip."sa{".$syllables[$i]."}".$sp;}
	 }
 }else{
	 if ($s==7){$tt=$t."-8";
#	 print  "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;
if ($print_music==1){print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
if ($print_music!=1){print OUTi "\\".$ip."accu{".$syllables[$i]."}".$sp;}
	 }
 }
 if ($print_music==1){
	if ($s==8){print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	if ($s==9){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($print_music!=1){
	if ($s==1){print OUTi $syllables[$i].$sp;}
	if ($s==2){print OUTi $syllables[$i].$sp;}
	if ($s==3){print OUTi $syllables[$i].$sp;}
	if ($s==0){print OUTi $syllables[$i].$sp;}
	if ($s==4){print OUTi "\\".$ip."accpu{".$syllables[$i]."}".$sp;}
	if ($s==5){print OUTi $syllables[$i].$sp;}
	if ($s==6){print OUTi $syllables[$i].$sp;}
	if ($s==8){print OUTi "\\".$ip."accu{".$syllables[$i]."}".$sp;}
	if ($s==9){print OUTi $syllables[$i].$sp;}
}

	}
}


sub format_pars_SM_no_blank(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;$pum=$i-2;$apum=$i-3;
#print $n." ".$apum." ".$pum." ".$um;
#print "\n";
	$t=$pars;
	if ($pars==1){$ip="i";}
	if ($pars==2){$ip="ii";}
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);
#	print $i."x".$s."-";
	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($i < $apum){
	if ($print_music==1){if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}}
	if ($print_music!=1){if ($s==0){print OUTi $syllables[$i].$sp;}}
}
if ($print_music==1){
	if ($s==7){print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
	if ($s==8){print OUT $syllables[$i]."(".$tonus{$tt}."r)".$sp;}
	if ($s==9){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($print_music!=1){
	if ($s==1){print OUTi $syllables[$i].$sp;}
	if ($s==2){print OUTi $syllables[$i].$sp;}
	if ($s==3){print OUTi $syllables[$i].$sp;}
	if ($s==7){print OUTi "\\".$ip."accu{".$syllables[$i]."}".$sp;}
	if ($s==8){print OUTi $syllables[$i].$sp;}
	if ($s==9){print OUTi $syllables[$i].$sp;}
}

if ($tonus{$t."-s"} == "0"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}

	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}	
}

if ($tonus{$t."-s"} == "1"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}".$sp;}
	}	
}

if ($tonus{$t."-s"} == "2"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}".$sp;}
	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}".$sp;}
	}	
}

if ($tonus{$t."-s"} == "3"){
	if ($i==$apum){$tt=$t."-apu";
#print " apu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylapu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylapu{".$syllables[$i]."}".$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
#print " pu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}".$sp;}

	}
	if ($i==$um){$tt=$t."-u";
#print " u ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}".$sp;}
	}	
}

}

}


sub format_pars_SW_no_blank(){
my	($pars,$print_music,$lw,$schema,%tonus)=@_;
	@syllables=split("~",$lw);
	$n=length($schema)-1;
	$i=index($schema,"7");
	$um=$i-1;$pum=$i-2;$apum=$i-3;
#	if ($schema !~ "8"){$schema=~s/7/8/;}
#print $n." ".$apum." ".$pum." ".$um;
#print "\n";
#print $schema;
	$t=$pars;
	if ($pars==1){$ip="i";}
	if ($pars==2){$ip="ii";}
	for($i=0;$i<=$n;$i++){
	$sp="";
	if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
	$s=substr($schema,$i,1);
#	print $i."x".$s."-";
	$tt=$t."-".$s;
if ($print_music==1){
	if ($s==1){print OUT deaccentify($syllables[$i])."(".$tonus{$tt}.")".$sp;}
	if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
	if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($i < $apum){
if ($print_music==1){if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}}
if ($print_music!=1){if ($s==0){print OUTi $syllables[$i].$sp;}}
}

	 if ($schema !~ "8"){
		if ($s==7){$tt=$t."-8";#print "Asdf";
		if ($print_music==1){
		print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;
		}
		if ($print_music!=1){print OUTi "\\".$ip."accu{".$syllables[$i]."}".$sp;}
		}
	}else{
		if ($s==7){
		if ($print_music==1){print OUT "<v>\\".$ip."sa{".$syllables[$i]."}</v>"."(".$tonus{$tt}."r)".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sa{".$syllables[$i]."}".$sp;}
		}
	}

if ($print_music==1){	
	if ($s==8){print OUT "<v>\\".$ip."accu{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}	
	if ($s==9){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
}
if ($print_music!=1){
	if ($s==1){print OUTi $syllables[$i].$sp;}
	if ($s==2){print OUTi $syllables[$i].$sp;}
	if ($s==3){print OUTi $syllables[$i].$sp;}
	if ($s==8){print OUTi "\\".$ip."accu{".$syllables[$i]."}".$sp;}
	if ($s==9){print OUTi $syllables[$i].$sp;}
}

if ($tonus{$t."-s"} == "0"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}	
}
if ($tonus{$t."-s"} == "1"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}".$sp;}
	}	
}

if ($tonus{$t."-s"} == "2"){
	if ($i==$apum){$tt=$t."-apu";
		if ($print_music==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi $syllables[$i].$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}".$sp;}

	}
	if ($i==$um){$tt=$t."-u";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}".$sp;}
	}	
}

if ($tonus{$t."-s"} == "3"){
	if ($i==$apum){$tt=$t."-apu";
#print " apu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylapu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylapu{".$syllables[$i]."}".$sp;}
	}
	if ($i==$pum){$tt=$t."-pu";
#print " pu ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylpu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylpu{".$syllables[$i]."}".$sp;}

	}
	if ($i==$um){$tt=$t."-u";
#print " u ";
		if ($print_music==1){print OUT "<v>\\".$ip."sylu{".$syllables[$i]."}</v>(".$tonus{$tt}.")".$sp;}
		if ($print_music!=1){print OUTi "\\".$ip."sylu{".$syllables[$i]."}".$sp;}
	}	
}

}

}

####### ####### ####### ####### ####### ####### ####### 
####### ####### ####### ####### ####### ####### ####### 
####### ####### ####### ####### ####### ####### ####### 



sub hyphenate(){
my ($sent)=@_;
#my $sent=shift;
print "hyphenate sent:".$sent."---\n";



@words="";
#if ($sent=~ " "){
@words=split(" ",$sent);
#}else{
#push(@words,$sent);print "pushing";
#}
print @words;
print scalar($words);
$sent_syl=" ";
@words_hyphen=();
if (length($sent) > 0){
for $word (@words){
print "x".$word."x";
	$n0=-1;
	$i=0;
	while ($n0 < 0){
	if(substr($word,$i,1) =~ /[a-zA-zóæ]/){$n0=$i}#;print "n0 ".$i." ".$n0."\n";}
	$i++;
	}
$ante=substr($word,0,$n0);
#print "before -".$ante."-";
	$n1=-1;
	$i=length($word);
	while ($n1 < 0){
	if(substr($word,$i,1) =~ /[a-zA-zæ]/){$n1=$i;}#print "n1 ".$i." ".$n1."\n";}a
	$i--;
	}
$post=substr($word,$n1+1,length($word));
#print "after -".$post."-";
$w=substr($word,$n0,$n1+1);
$w=~s/\.//g;
#print "word -".$w."-";
$tmp=$w;
	if ($w !~ "~"){$tmp=$hyphenator->hyphenate($w,"~");
	$tmp=~s/ió/i~ó/g;$tmp=~s/eó/e~ó/g;$tmp=~s/eá/e~á/g;$tmp=~s/iá/i~á/g;$tmp=~s/ié/i~é/g;$tmp=~s/uá/u~á/g;$tmp=~s/uó/u~ó/g;
	$tmp=~s/uí/u~í/g;$tmp=~s/uæ/u~æ/g;$tmp=~s/iæ/i~æ/g;$tmp=~s/eæ/e~æ/g;
	$tmp=~s/~~/~/g;
	$tmp=~s/qu~æ/quæ/g;$tmp=~s/Qu~æ/quæ/g;
	$tmp=~s/Qu~ó/Quó/g;$tmp=~s/qu~ó/quó/g;
	}
push(@words_hyphen,$ante.$tmp.$post." ~");
print "-".$ante.$tmp.$post."-\n";
}
}
else{
push(@words_hyphen,$sent);
}
return(@words_hyphen);
}

sub accentify(){
my @words_hyphen=@_;
@acc=();
for $word (@words_hyphen){
#print $word." ";
@ss=split("~",$word);
if (scalar(@ss)==1){$aa="2";}
if (scalar(@ss)==2){$aa="1~0";}
if (scalar(@ss)>2){
	$aa="";
	for $s (@ss){
	$a="0~";
	if ($s =~ /[áéíóúǽ]/g){$a="1~";}
	if ($s =~ /[æÆ]/g){$a="0~";}
	$aa=$aa.$a;
#	print $s." ".$a;
#	if(scalar($aa)==0){$aa=$a;}else{}
	}
	chomp($aa);
	$tmp=$word;
	$tmp=~s/~//g;
	$tmp=~s/ //g;
	if ($aa !~ /1/){print UNACC "\$totum=~s/".$tmp."/".$word."/g;\n";}
}
#print $s." ".$aa;
push(@acc,$aa);
#print "\n";
}
return(@acc);
}

sub find_schema(){
my ($ini,@acc)=@_;
#print "schema";
#print @acc;
$la="";
for $w (@acc){$la=$la.$w;}
#@a=split("~",$la);
$la=~s/~//g;
#print $la;
#print $la;
#print " x ";

$n1=-1000;
$n=length($la)-1;
$i=$n;
while ($n1 <= -1000){
if(substr($la,$i,1) =~ /1/){$n1=$i;}#print "n1 ".$i." ".$n1."\n";}
$i--;
if ($i==0){$n1=-1;}
}
$nultima=$n1;
#print $nultima." x ";

if (substr($la,$n,1) eq "2" and substr($la,$n-1,1) eq 2 ){
$nultima=$n-1;
}

$n1=-1000;
$i=$nultima-1;
while ($n1 <= -1000){
if(substr($la,$i,1) =~ /1/){$n1=$i;}
$i--;
if ($i==0){$n1=-1;}
}
$npaenultima=$n1;
#print $npaenultima." x ";




$terminatio="";
if ($nultima==$n-1){
if ($npaenultima==$nultima-2){#print "-_-_";
$terminatio="4679";}
if ($npaenultima==$nultima-3){#print "-_ _ - _";
$terminatio="45679";}
if ($npaenultima<$nultima-3){#print "'_ - _";
$terminatio="4679";}
}
if ($nultima==$n-2){
if ($npaenultima==$nultima-2){#print "-_-_ _";
$terminatio="46789";}
if ($npaenultima==$nultima-3){#print "-_ _ - _ _";
$terminatio="456789";}
if ($npaenultima<$nultima-3){#print "'_ - _ _";
$terminatio="46789";}
}
if ($nultima==$n-3){
$terminatio="4679";
}

$nt=length($terminatio);
if ($ini==1){
$init="123";
$ni=3;
}
else{
$init="";
$ni=0;
}

$tmp=$la;
$tmp=~s/[1-9]/0/g;
$tmp=substr($tmp,0,$n-$nt-$ni+1);
#print $terminatio;
$schema=$init.$tmp.$terminatio;
#print $schema."\n";
return($schema);
}


sub deaccentify(){
my ($work)=@_;
@out=();
$word=$work;
$word=~s/á/a/g;
$word=~s/Á/a/g;
$word=~s/é/e/g;
$word=~s/É/E/g;
$word=~s/í/i/g;
$word=~s/Í/I/g;
$word=~s/ó/o/g;
$word=~s/Ó/O/g;
$word=~s/ú/u/g;
$word=~s/Ú/U/g;
$word=~s/ǽ/æ/g;
$word=~s/Ǽ/Æ/g;
#push(@out,$word);
#print $word;

return($word);
}



#print $totum;
# print "index".$i."\n";
# print $totum."\n";
# $tot=$totum;
# $tot=~s/á/a/g;
# $tot=~s/é/e/g;
# $tot=~s/í/i/g;
# $tot=~s/ó/o/g;
# $tot=~s/ú/u/g;
# print $tot."\n";
#$sent=$tot;
# $tot=~s/,/ /g;
# $tot=~s/;/ /g;
# $tot=~s/:/ /g;
# $tot=~s/\./ /g;
# $tot=~s/\*/ /g;
# $tot=~s/[a-z]/x/g;
# $tot=~s/[A-Z]/x/g;
# print $tot."\n";
#@tmp=split("x",$tot);
#for $t (@tmp){
#print $t."-";
#}
#print index($totum,"ó");
# $word=$totum;



#10001000102100
#1230000456789
#print $sent_syl;
# @syls=split("~",$sent_syl);
# for $syl (@syls){
# print $syl."-";

# }
# print "\n";
# $n=scalar(@syls)-1;
# print $n;
# 
# print @syls[$n]."--";
# print @syls[$n-1]."--";
# 
#print $hyphenator["tree"]."\n";
#print keys(%{$hyphenator})."\n";



#print "asdf";
#print $hyphenator["tree"]."\n";
#print "asdf";
#print hyphenate($word,'~');
# @syllables=split("~",$lw);
# $n=length($schema)-1;
# print "-".$schema."-";
# 
# print "index \n";
# $i=index($schema,"7");
# $um=$i-1;
# $pum=$i-2;
# $apum=$i-3;
# print $apum." ".$pum." ".$um;
# print "\n";
# 
# $t=1;
# for($i=0;$i<=$n;$i++){
# $sp="";
# if ($syllables[$i]=~ / /){$sp=" ";chop $syllables[$i];}
# $s=substr($schema,$i,1);
# print $i." ".$s;
# $tt=$t."-".$s;
# if ($s==1){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==2){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==3){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==0){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# #$if ($schema =~ /456/){
# if ($s==4){print "{".$syllables[$i]."}"."(".$tonus{$tt}.")".$sp;}
# if ($s==5){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==6){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==7){print "{".$syllables[$i]."}"."(".$tonus{$tt}.")".$sp;}
# if ($s==8){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==9){print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# #if ($i==$um){$tt=$t."-um";print $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# #if ($i==$pum){$tt=$t."-pum";print "{".$syllables[$i]."}"."(".$tonus{$tt}.")".$sp;}
# #if ($i==$apum){$tt=$t."-apum";print "{".$syllables[$i]."}"."(".$tonus{$tt}.")".$sp;}
# 
# 
# 
# if ($s==1){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==2){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==3){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==0){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==4){print OUT "<v>\\dashuline{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
# if ($s==5){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==6){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==7){print OUT "<v>\\dashuline{".$syllables[$i]."}</v>"."(".$tonus{$tt}.")".$sp;}
# if ($s==8){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# if ($s==9){print OUT $syllables[$i]."(".$tonus{$tt}.")".$sp;}
# 
# if ($s==1){print OUTi $syllables[$i].$sp;}
# if ($s==2){print OUTi $syllables[$i].$sp;}
# if ($s==3){print OUTi $syllables[$i].$sp;}
# if ($s==0){print OUTi $syllables[$i].$sp;}
# if ($s==4){print OUTi "\\uline{\\itshape{".$syllables[$i]."}}".$sp;}
# if ($s==5){print OUTi $syllables[$i].$sp;}
# if ($s==6){print OUTi $syllables[$i].$sp;}
# if ($s==7){print OUTi "\\uline{\\bfseries{".$syllables[$i]."}}".$sp;}
# if ($s==8){print OUTi $syllables[$i].$sp;}
# if ($s==9){print OUTi $syllables[$i].$sp;}
# 
# 
# }



# print length($tot)." ".length($totum);
# @words=();
# $iw=0;
# print "totum\n";
# $imax=length($totum);
# for ($i=0;$i<$imax;$i++){
# print $i.substr($totum,$i,1);
# if (substr($tot,$i,1) =~ "x"){print substr($totum,$i,1);}
# if (substr($tot,$i,1) != "x"){print " ";}
# }
# print "\n\n";


sub write_magnificat( ){

if ($sel eq "C_1_D"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_1_D2"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_1_f"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_1_g"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_1_g2"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_1_a"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_1_a2"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_1_a3"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_2_D"){$m="Ma(e)gní(fe)fi(eh)cat(h.)";}
if ($sel eq "C_2_A"){$m="Ma(e)gní(fe)fi(eh)cat(h.)";}
if ($sel eq "C_3_b"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "C_3_a"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "C_3_a2"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "C_3_g"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "C_4_E"){$m="Ma(h)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_4_A"){$m="Ma(i)gní(hi)fi(i)cat(i.)";}
if ($sel eq "C_4_As"){$m="Ma(i)gní(hi)fi(i)cat(i.)";}
if ($sel eq "C_5_a"){$m="Ma(d)gní(f)fi(h)cat(h.)";}
if ($sel eq "C_6_F"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_6_C"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "C_7_a"){$m="Ma(hg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "C_7_b"){$m="Ma(hg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "C_7_c"){$m="Ma(hg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "C_7_c2"){$m="Ma(hg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "C_7_d"){$m="Ma(hg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "C_8_G"){$m="Ma(g)gní(hg)fi(gj)cat(j.)";}
if ($sel eq "C_8_Gs"){$m="Ma(g)gní(hg)fi(gj)cat(j.)";}
if ($sel eq "C_8_c"){$m="Ma(g)gní(hg)fi(gj)cat(j.)";}

if ($sel eq "CS_1_D"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_1_D2"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_1_f"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_1_g"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_1_g2"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_1_a"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_1_a2"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_1_a3"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_2_D"){$m="Ma(e)gní(fe)fi(eh)cat(h.)";}
if ($sel eq "CS_2_A"){$m="Ma(e)gní(fe)fi(eh)cat(h.)";}
if ($sel eq "CS_3_b"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "CS_3_a"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "CS_3_a2"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "CS_3_g"){$m="Ma(g)gní(hj)fi(j)cat(j.)";}
if ($sel eq "CS_4_E"){$m="Ma(h)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_4_A"){$m="Ma(i)gní(hi)fi(i)cat(i.)";}
if ($sel eq "CS_4_As"){$m="Ma(i)gní(hi)fi(i)cat(i.)";}
if ($sel eq "CS_5_a"){$m="Ma(d)gní(f)fi(h)cat(h.)";}
if ($sel eq "CS_6_F"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_6_C"){$m="Ma(f)gní(gh)fi(h)cat(h.)";}
if ($sel eq "CS_7_a"){$m="Ma(ehg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "CS_7_b"){$m="Ma(ehg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "CS_7_c"){$m="Ma(ehg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "CS_7_c2"){$m="Ma(ehg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "CS_7_d"){$m="Ma(hg)gní(hi)fi(i)cat(i.)";}
if ($sel eq "CS_8_G"){$m="Ma(g)gní(hg)fi(gj)cat(j.)";}
if ($sel eq "CS_8_Gs"){$m="Ma(g)gní(hg)fi(gj)cat(j.)";}
if ($sel eq "CS_8_c"){$m="Ma(g)gní(hg)fi(gj)cat(j.)";}

print OUT $m;
print OUT " \*(:) ";
}
