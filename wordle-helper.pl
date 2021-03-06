#!/usr/bin/perl
-e 'fives.txt' || die("Run this command\n\ncurl -s https://raw.githubusercontent.com/dwyl/english-words/master/words.zip \n unzip words.zip \ncat words.txt | grep -e \"^[a-z]\\{5\\}\\\$\" > fives.txt\n\n");

sub remove{
    my ($l,$s) = @_;
    1 == length($s) && return $s;
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

sub wordsort {
    my ($f,$a) = @_;
    my @histogram = (0) x 26;
   
    for (my $i=0; $i < length($f); $i++) {
        my $c = substr($f,$i,1);
        my $d = index($a,$c);
        if (-1 != $d){
            $histogram[$d]++;
        }
    }

    my $ret = "";
    for my $w ( split(/\n/,$f)) {
        $w =~ s/^\s+|\s+$//g;
        $ret .= sprintf("$w %d\n", score($w,$a,@histogram));
    }

    return `printf "$ret" | sort -k 2 -g -r | sed 's/ .*\$//g'`;
}
    
my $alpha = 'abcdefghijklmnopqrstuvwxyz';
my $fives = `cat fives.txt`;
$fives = wordsort($fives,$alpha);
my $maxword = substr($fives,0,5);
my @l = ($alpha,$alpha,$alpha,$alpha,$alpha);
my $wrongplace = "";
my $tries = 0;
my $top = `printf "$fives" | head -n 5`;
my $count = count($fives,"\n");
$ARGV[1] eq "-q" || print("input WORD [Y|N|y]{5}\nWHERE:\n\nWORD -five letter word\nYNy -whether each caracter is:\n\tY--In the right spot\n\ty--In the word,or\n\tn--not in word\nexample: ratio Ynyyy\n\n\n$count words in db\n\n$top\n\nRecommend: $maxword \n\ninput WORD [Y|N|y]{5}(cntl-c to quit)> ");
while ($line=readline(STDIN)){
    my ($word,$yn) = split(' ',$line);
    $tries++;
    $yn eq "YYYYY" && die "Got it in $tries tries!!\n\n";
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
        my $wpg = join(" | grep ",split(undef,$wrongplace));
        $fives = `printf "$fives" | grep -e "$g" | grep $wpg `;
    } else {
        $fives = `printf "$fives" | grep -e "$g"  `;
    }
    $fives = wordsort($fives,$alpha);
    $maxword = substr($fives,0,5);
    $count = count($fives,"\n");
    if ($ARGV[1] eq "-q") {
        print "$maxword $count\n";
    } else {
        if ($count < 20) {
            print "\n$count matches\n\n$fives\n\n";
        } else {
            print "\n$count matches\n\n" . `echo \"$fives\" | head -n 20` ."\n\n";
        }
        $ARGV[1] eq "-q" || print("Recommend: $maxword \n\n");
        print("input WORD [Y|N|y]{5}(cntl-c to quit)> ");
    }

}
