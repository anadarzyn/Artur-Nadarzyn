#!/bin/bash

# rozwiazanie laboratiorium
# http://wbzyl.inf.ug.edu.pl/sp/labs06

# punkt 1

grep [^.] plik.txt

# punkt 2

grep ^[0-9] pl*

# punkt 3

grep -l ^........r *

# punkt 4

grep -c bash /etc/passwd

# punkt 5

grep   "\b[IVXLCDM]\+\b"  plik.txt


