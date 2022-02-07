#!/usr/bin/perl
-e 'corncob_lowercase.txt' || system("wget http://www.mieliestronk.com/corncob_lowercase.txt");  #don't really know what this is--just looks like raw english words
-e 'fives.txt'  || system("cat corncob_lowercase.txt | grep -e '^......$' > fives.txt");
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
my $fives = `cat fives.txt`; 				
my $alpha = 'abcdefghijklmnopqrstuvwxyz';
my @l = ($alpha,$alpha,$alpha,$alpha,$alpha);
my $wrongplace = "";
print("input WORD [Y|N|y]{5}\nWHERE:\n\nWORD -five letter word\nYNy -whether each caracter is:\n\tY--In the right spot\n\ty--In the word,or\n\tn--not in word\nexample: ratio Ynyyy\n\ninput WORD [Y|N|y]{5}(cntl-c to quit)> ");
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
    my $count = count($fives,"\n");
    if ($count < 20) {
	print "\n$count matches\n$fives\n\n";	
    } else {
	print "\n$count matches\n" . `echo \"$fives\" | head -n 20` ."\n\n";
    }
    print("input WORD [Y|N|y]{5}(cntl-c to quit)> ");
}
