# Wordle-helper
A Perl Script to help "you" guess wordle words.


There is a prompt-- enter the word you guess then the response from wordle.  Code the green with Y, tan y and black n.

It will give you some hints!


It works by selecting the words that will eliminate the most number of choices... then ranking the rmaining words agian.
example ::

~/Desktop/wordle [08:16:53] ./wordle-solver.pl
input WORD [Y|N|y]{5}
WHERE:

WORD -five letter word
YNy -whether each caracter is:
        Y--In the right spot
        y--In the word,or
        n--not in word
example: ratio Ynyyy


12927 words in db

seora
arose
serai
raise
arise


Recommend: seora

input WORD [Y|N|y]{5}(cntl-c to quit)> arose nyynn

169 matches

yourt
turio
yourn
curio
houri
tourn
duroy
loury
tumor
throu
rougy
roguy
goury
cornu
guiro
toric
roupy
rohun
norit
mucro


Recommend: yourt

input WORD [Y|N|y]{5}(cntl-c to quit)> yourt nyyyn

12 matches

mucor
rumbo
curio
occur
humor
rubor
buroo
unrow
okrug
uvrou
juror
furor


Recommend: mucor

input WORD [Y|N|y]{5}(cntl-c to quit)> mucor yYnYY

1 matches

humor


Recommend: humor

input WORD [Y|N|y]{5}(cntl-c to quit)> humor YYYYY
Got it in 4 tries!!

~/Desktop/wordle [08:17:46]
