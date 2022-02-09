#!/usr/bin/perl
-e 'fives.txt' || die("Run this command\n\ncurl -s http://www.mieliestronk.com/corncob_lowercase.txt | grep -e '^......\$' > fives.txt\n\n");
sub remove{
    my ($l,$s) = @_;
    my $i = index($s,$l);
    if(-1 != $i){
        my $len = length($s);
        if ($i==0) {
            return(substr($s,1,$len-1));
        }
        if ($i==$l) {
            return(substr($s,0,$len-1));
        }
        return( substr($s,0,$i) . substr($s,$i+1,$len-($i+1)))
    }
    return($s);
}
sub count {
    my ($s,$c) = @_;
    my $z =0;
    foreach $k (split(undef,$s)){
        $c eq $k && $z++;
    }
    return $z;
}
sub score {
    my ($w,$a,@h) = @_;
    my $score = 0;
    for (my $k =0; $k < length($w); $k++){
        my $c = substr($w,$k,1);
        if ($k == index($w,$c)) { # FIRST IN WORD
            my $idx=index($a,$c);
            if ($idx != -1){
                $score += $h[$idx];
            }
        }
    }
    return $score;
}

sub findmaxword {
    my ($f,$a, @hi) = @_;
    my $mw = "";
    my $mxs = 0;
    for my $w ( split(/^/, $f) ) {	
	$w =~ s/^\s+|\s+$//g;
        my $ws = score($w,$a,@hi);
        if ($ws > $mxs){
            $mxs = $ws;
            $mw = $w;
        }
    }
    $mw =~ s/^\s+|\s+$//g;
    return $mw;
}



my $fives = `cat fives.txt`;
my $alpha = 'abcdefghijklmnopqrstuvwxyz';
my @histogram = (0) x 26;
for (my $i=0; $i < length($fives); $i++) {
    my $c = substr($fives,$i,1);
    my $d = index($alpha,$c);
    if (-1 != $d){
        $histogram[$d]++;
    }
}

my @l = ($alpha,$alpha,$alpha,$alpha,$alpha);
my $wrongplace = "";
my $maxword = findmaxword($fives, $alpha, @histogram);
$ARGV[1] eq "-q" || print("input WORD [Y|N|y]{5}\nWHERE:\n\nWORD -five letter word\nYNy -whether each caracter is:\n\tY--In the right spot\n\ty--In the word,or\n\tn--not in word\nexample: ratio Ynyyy\n\nRecommend: $maxword \n\ninput WORD [Y|N|y]{5}(cntl-c to quit)> ");
while ($line=readline(STDIN)){
    my ($word,$yn) = split(' ',$line);
    $wrongplace = "";
    for (my $i=0;$i<5;$i++){
        my $char = substr($word,$i,1);
        my $code = substr($yn,$i,1);
        if ('Y' eq $code) {
            $l[$i]=$char;
        } else {
            if ('y' eq $code) {
                $l[$i] = remove($char,$l[$i]);
                if (-1 == index($wrongplace,$char)) {
                    $wrongplace .= $char;
                }
            } else {
                for (my $j=0;$j<5;$j++){
                    $l[$j] = remove($char,$l[$j]);
                }
            }
        }
    }
    my $g = '';;
    for (my $i=0;$i<5;$i++){
        if ( 1 < length(@l[$i]) ) {
            $g .= "[" . join('|',split(undef,@l[$i])) ."]"
        } else {
            $g .=  join('',@l[$i]);
        }
    }
    if ($wrongplace ne "") {
        my $wpg = "| grep " . join(" | grep ",split(undef,$wrongplace));
        print $wpg . "\n\n";
        $fives = `echo "$fives" | grep -e "$g" $wpg `;
    } else {
        $fives = `echo "$fives" | grep -e "$g"  `;
    }
    $maxword = findmaxword($fives, $alpha, @histogram);
    my $count = count($fives,"\n");
    if ($ARGV[1] eq "-q") {
        print "$maxword $count\n";
    } else {
        if ($count < 20) {
            print "\n$count matches\n$fives\n\n";
        } else {
            print "\n$count matches\n" . `echo \"$fives\" | shuf -n 20` ."\n\n";
        }
        $ARGV[1] eq "-q" || print("Recommend: $maxword \n\n");
        print("input WORD [Y|N|y]{5}(cntl-c to quit)> ");
    }
}
