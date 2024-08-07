```
$ perl sohf.pl
- The sieve of Hardy-Francis is a modern algorithm for finding all prime numbers up to any given limit.
- It does so by iteratively finding primes and marking as composite (i.e. not prime) the unique prime multiplies of each prime, starting with the 3rd prime number, 5.
- This is the sieve's key distinction from the sieve of Eratosthenes where non-unique multiplies of each prime result in more marking [1].
- Another distinction is the sieve also reveals primes in order as the algorithm is running, and must not mark all composites first.
- Another distinction is the sieve only considers a subset of integers; 6n +/- 1.
- [1] E.g. 2x3 and 3x2 result in double marking the prime candidate 6.

- To find all the prime numbers less than or equal to a given integer n by Hardy-Francis' method:
- 1. Enumerate through candidate integers from 5 through n via 6n +/- 1, e.g. if n=250 (5, 7, 11, 13, ..., 239, 241, 245, 247).
- 2. At each integer perform candidate business logic, and if not marked, the candidate is prime.
- 3. Business logic at candidate:
- At any candidate, mark a unique more_factors_count_future_candidate which is candidate x candidate highest prime factor, i.e. one factor bigger.
- At non-prime candidate, mark a unique same_factors_count_future_candidate which is the product of candidate factors after the highest prime factor is replaced with the next highest prime factor.
- Example business logic -- for non-consecutive candidates -- resulting from candidate 5 which is prime:
- At candidate=5   so more_factors_count_future_candidate = 5 x  5          =   25, i.e. candidate is prime.
- At candidate=25  so more_factors_count_future_candidate = 5 x  5 x  5     =  125, i.e. extra prime factor is also highest prime factor  5
- At candidate=25  so same_factors_count_future_candidate = 5 x  7          =   35, i.e. candidate is non-prime and highest prime factor  5 is replaced with next highest prime factor  7.
- At candidate=35  so more_factors_count_future_candidate = 5 x  7 x  7     =  245, i.e. extra prime factor is also highest prime factor  7
- At candidate=35  so same_factors_count_future_candidate = 5 x 11          =   55, i.e. candidate is non-prime and highest prime factor  7 is replaced with next highest prime factor 11.
- At candidate=55  so more_factors_count_future_candidate = 5 x 11 x 11     =  605, i.e. extra prime factor is also highest prime factor 11
- At candidate=55  so same_factors_count_future_candidate = 5 x 13          =   65, i.e. candidate is non-prime and highest prime factor 11 is replaced with next highest prime factor 13.
- At candidate=65  so more_factors_count_future_candidate = 5 x 13 x 13     =  845, i.e. extra prime factor is also highest prime factor 13
- At candidate=65  so same_factors_count_future_candidate = 5 x 17          =   85, i.e. candidate is non-prime and highest prime factor 13 is replaced with next highest prime factor 17.
- At candidate=85  so more_factors_count_future_candidate = 5 x 17 x 17     = 1445, i.e. extra prime factor is also highest prime factor 17
- At candidate=85  so same_factors_count_future_candidate = 5 x 19          =   95, i.e. candidate is non-prime and highest prime factor 17 is replaced with next highest prime factor 19.
- At candidate=95  so more_factors_count_future_candidate = 5 x 19 x 19     = 1805, i.e. extra prime factor is also highest prime factor 19
- At candidate=95  so same_factors_count_future_candidate = 5 x 23          =  115, i.e. candidate is non-prime and highest prime factor 19 is replaced with next highest prime factor 23.
- At candidate=115 so more_factors_count_future_candidate = 5 x 23 x 23     = 2645, i.e. extra prime factor is also highest prime factor 23
- At candidate=115 so same_factors_count_future_candidate = 5 x 29          =  145, i.e. candidate is non-prime and highest prime factor 23 is replaced with next highest prime factor 29.
- At candidate=125 so more_factors_count_future_candidate = 5 x  5 x  5 x 5 =  625, i.e. extra prime factor is also highest prime factor  5
- At candidate=125 so same_factors_count_future_candidate = 5 x  5 x  7     =  175, i.e. candidate is non-prime and highest prime factor  5 is replaced with next highest prime factor  7.

- Conjecture 1: The factor(s) for 6n +/- 1 are always prime.
- Conjecture 2: The integers for 6n +/- 1 only get marked once using the above algorithm.

- Notes on this slower reference implementation:
- 1. Marking future candidates is implemented via a hash table, which is also used to sanity check that marking is unique per candidate.
- 2. An alternative prime numbers library is used to validate the results of this algorithm
- 3. The business logic instrumentation for each candidate is presented on a single line
- 4. Perhaps a faster C implementation is possible with sort-by-insertion double linked lists replacing the hash table?
```

```
- For each prime candidate in the sequence 6n +/- 1, run business logic to discover if it's prime:
-         1*6-1 =         5 IS     prime         p[0];         5=hi of 1 factor(s) [1]:             25=hi*[1] = (p[0]=5) x (p[0]=5); [1] 5
-         1*6+1 =         7 IS     prime         p[1];         7=hi of 1 factor(s) [1]:             49=hi*[1] = (p[1]=7) x (p[1]=7); [1] 7
-         2*6-1 =        11 IS     prime         p[2];        11=hi of 1 factor(s) [1]:            121=hi*[1] = (p[2]=11) x (p[2]=11); [1] 11
-         2*6+1 =        13 IS     prime         p[3];        13=hi of 1 factor(s) [1]:            169=hi*[1] = (p[3]=13) x (p[3]=13); [1] 13
-         3*6-1 =        17 IS     prime         p[4];        17=hi of 1 factor(s) [1]:            289=hi*[1] = (p[4]=17) x (p[4]=17); [1] 17
-         3*6+1 =        19 IS     prime         p[5];        19=hi of 1 factor(s) [1]:            361=hi*[1] = (p[5]=19) x (p[5]=19); [1] 19
-         4*6-1 =        23 IS     prime         p[6];        23=hi of 1 factor(s) [1]:            529=hi*[1] = (p[6]=23) x (p[6]=23); [1] 23
-         4*6+1 =        25 IS NOT prime        np[0];         5=hi of 2 factor(s) [1]:            125=hi*[1] = (p[0]=5) x (np[0]=25) via (p[0]=5) x (p[0]=5); [1] 5x5
-         5*6-1 =        29 IS     prime         p[7];        29=hi of 1 factor(s) [1]:            841=hi*[1] = (p[7]=29) x (p[7]=29); [1] 29
-         5*6+1 =        31 IS     prime         p[8];        31=hi of 1 factor(s) [1]:            961=hi*[1] = (p[8]=31) x (p[8]=31); [1] 31
-         6*6-1 =        35 IS NOT prime        np[1];         7=hi of 2 factor(s) [1]:            245=hi*[1] = (p[1]=7) x (np[1]=35) via (p[1]=7) x (p[0]=5); [1] 7x5
-         6*6+1 =        37 IS     prime         p[9];        37=hi of 1 factor(s) [1]:           1369=hi*[1] = (p[9]=37) x (p[9]=37); [1] 37
-         7*6-1 =        41 IS     prime        p[10];        41=hi of 1 factor(s) [1]:           1681=hi*[1] = (p[10]=41) x (p[10]=41); [1] 41
-         7*6+1 =        43 IS     prime        p[11];        43=hi of 1 factor(s) [1]:           1849=hi*[1] = (p[11]=43) x (p[11]=43); [1] 43
-         8*6-1 =        47 IS     prime        p[12];        47=hi of 1 factor(s) [1]:           2209=hi*[1] = (p[12]=47) x (p[12]=47); [1] 47
-         8*6+1 =        49 IS NOT prime        np[2];         7=hi of 2 factor(s) [1]:            343=hi*[1] = (p[1]=7) x (np[2]=49) via (p[1]=7) x (p[1]=7); [1] 7x7
-         9*6-1 =        53 IS     prime        p[13];        53=hi of 1 factor(s) [1]:           2809=hi*[1] = (p[13]=53) x (p[13]=53); [1] 53
-         9*6+1 =        55 IS NOT prime        np[3];        11=hi of 2 factor(s) [1]:            605=hi*[1] = (p[2]=11) x (np[3]=55) via (p[2]=11) x (p[0]=5); [1] 11x5
-        10*6-1 =        59 IS     prime        p[14];        59=hi of 1 factor(s) [1]:           3481=hi*[1] = (p[14]=59) x (p[14]=59); [1] 59
-        10*6+1 =        61 IS     prime        p[15];        61=hi of 1 factor(s) [1]:           3721=hi*[1] = (p[15]=61) x (p[15]=61); [1] 61
-        11*6-1 =        65 IS NOT prime        np[4];        13=hi of 2 factor(s) [1]:            845=hi*[1] = (p[3]=13) x (np[4]=65) via (p[3]=13) x (p[0]=5); [1] 13x5
-        11*6+1 =        67 IS     prime        p[16];        67=hi of 1 factor(s) [1]:           4489=hi*[1] = (p[16]=67) x (p[16]=67); [1] 67
-        12*6-1 =        71 IS     prime        p[17];        71=hi of 1 factor(s) [1]:           5041=hi*[1] = (p[17]=71) x (p[17]=71); [1] 71
-        12*6+1 =        73 IS     prime        p[18];        73=hi of 1 factor(s) [1]:           5329=hi*[1] = (p[18]=73) x (p[18]=73); [1] 73
-        13*6-1 =        77 IS NOT prime        np[5];        11=hi of 2 factor(s) [1]:            847=hi*[1] = (p[2]=11) x (np[5]=77) via (p[2]=11) x (p[1]=7); [1] 11x7
-        13*6+1 =        79 IS     prime        p[19];        79=hi of 1 factor(s) [1]:           6241=hi*[1] = (p[19]=79) x (p[19]=79); [1] 79
-        14*6-1 =        83 IS     prime        p[20];        83=hi of 1 factor(s) [1]:           6889=hi*[1] = (p[20]=83) x (p[20]=83); [1] 83
-        14*6+1 =        85 IS NOT prime        np[6];        17=hi of 2 factor(s) [1]:           1445=hi*[1] = (p[4]=17) x (np[6]=85) via (p[4]=17) x (p[0]=5); [1] 17x5
-        15*6-1 =        89 IS     prime        p[21];        89=hi of 1 factor(s) [1]:           7921=hi*[1] = (p[21]=89) x (p[21]=89); [1] 89
-        15*6+1 =        91 IS NOT prime        np[7];        13=hi of 2 factor(s) [1]:           1183=hi*[1] = (p[3]=13) x (np[7]=91) via (p[3]=13) x (p[1]=7); [1] 13x7
-        16*6-1 =        95 IS NOT prime        np[8];        19=hi of 2 factor(s) [1]:           1805=hi*[1] = (p[5]=19) x (np[8]=95) via (p[5]=19) x (p[0]=5); [1] 19x5
-        16*6+1 =        97 IS     prime        p[22];        97=hi of 1 factor(s) [1]:           9409=hi*[1] = (p[22]=97) x (p[22]=97); [1] 97
-        17*6-1 =       101 IS     prime        p[23];       101=hi of 1 factor(s) [1]:          10201=hi*[1] = (p[23]=101) x (p[23]=101); [1] 101
-        17*6+1 =       103 IS     prime        p[24];       103=hi of 1 factor(s) [1]:          10609=hi*[1] = (p[24]=103) x (p[24]=103); [1] 103
-        18*6-1 =       107 IS     prime        p[25];       107=hi of 1 factor(s) [1]:          11449=hi*[1] = (p[25]=107) x (p[25]=107); [1] 107
-        18*6+1 =       109 IS     prime        p[26];       109=hi of 1 factor(s) [1]:          11881=hi*[1] = (p[26]=109) x (p[26]=109); [1] 109
-        19*6-1 =       113 IS     prime        p[27];       113=hi of 1 factor(s) [1]:          12769=hi*[1] = (p[27]=113) x (p[27]=113); [1] 113
-        19*6+1 =       115 IS NOT prime        np[9];        23=hi of 2 factor(s) [1]:           2645=hi*[1] = (p[6]=23) x (np[9]=115) via (p[6]=23) x (p[0]=5); [1] 23x5
-        20*6-1 =       119 IS NOT prime       np[10];        17=hi of 2 factor(s) [1]:           2023=hi*[1] = (p[4]=17) x (np[10]=119) via (p[4]=17) x (p[1]=7); [1] 17x7
-        20*6+1 =       121 IS NOT prime       np[11];        11=hi of 2 factor(s) [1]:           1331=hi*[1] = (p[2]=11) x (np[11]=121) via (p[2]=11) x (p[2]=11); [1] 11x11
-        21*6-1 =       125 IS NOT prime       np[12];         5=hi of 3 factor(s) [1]:            625=hi*[1] = (p[0]=5) x (np[12]=125) via (p[0]=5) x (np[0]=25); [1] 5x5x5
-        21*6+1 =       127 IS     prime        p[28];       127=hi of 1 factor(s) [1]:          16129=hi*[1] = (p[28]=127) x (p[28]=127); [1] 127
-        22*6-1 =       131 IS     prime        p[29];       131=hi of 1 factor(s) [1]:          17161=hi*[1] = (p[29]=131) x (p[29]=131); [1] 131
-        22*6+1 =       133 IS NOT prime       np[13];        19=hi of 2 factor(s) [1]:           2527=hi*[1] = (p[5]=19) x (np[13]=133) via (p[5]=19) x (p[1]=7); [1] 19x7
-        23*6-1 =       137 IS     prime        p[30];       137=hi of 1 factor(s) [1]:          18769=hi*[1] = (p[30]=137) x (p[30]=137); [1] 137
-        23*6+1 =       139 IS     prime        p[31];       139=hi of 1 factor(s) [1]:          19321=hi*[1] = (p[31]=139) x (p[31]=139); [1] 139
-        24*6-1 =       143 IS NOT prime       np[14];        13=hi of 2 factor(s) [1]:           1859=hi*[1] = (p[3]=13) x (np[14]=143) via (p[3]=13) x (p[2]=11); [1] 13x11
-        24*6+1 =       145 IS NOT prime       np[15];        29=hi of 2 factor(s) [1]:           4205=hi*[1] = (p[7]=29) x (np[15]=145) via (p[7]=29) x (p[0]=5); [1] 29x5
-        25*6-1 =       149 IS     prime        p[32];       149=hi of 1 factor(s) [1]:          22201=hi*[1] = (p[32]=149) x (p[32]=149); [1] 149
-        25*6+1 =       151 IS     prime        p[33];       151=hi of 1 factor(s) [1]:          22801=hi*[1] = (p[33]=151) x (p[33]=151); [1] 151
-        26*6-1 =       155 IS NOT prime       np[16];        31=hi of 2 factor(s) [1]:           4805=hi*[1] = (p[8]=31) x (np[16]=155) via (p[8]=31) x (p[0]=5); [1] 31x5
-        26*6+1 =       157 IS     prime        p[34];       157=hi of 1 factor(s) [1]:          24649=hi*[1] = (p[34]=157) x (p[34]=157); [1] 157
-        27*6-1 =       161 IS NOT prime       np[17];        23=hi of 2 factor(s) [1]:           3703=hi*[1] = (p[6]=23) x (np[17]=161) via (p[6]=23) x (p[1]=7); [1] 23x7
-        27*6+1 =       163 IS     prime        p[35];       163=hi of 1 factor(s) [1]:          26569=hi*[1] = (p[35]=163) x (p[35]=163); [1] 163
-        28*6-1 =       167 IS     prime        p[36];       167=hi of 1 factor(s) [1]:          27889=hi*[1] = (p[36]=167) x (p[36]=167); [1] 167
-        28*6+1 =       169 IS NOT prime       np[18];        13=hi of 2 factor(s) [1]:           2197=hi*[1] = (p[3]=13) x (np[18]=169) via (p[3]=13) x (p[3]=13); [1] 13x13
-        29*6-1 =       173 IS     prime        p[37];       173=hi of 1 factor(s) [1]:          29929=hi*[1] = (p[37]=173) x (p[37]=173); [1] 173
-        29*6+1 =       175 IS NOT prime       np[19];         7=hi of 3 factor(s) [1]:           1225=hi*[1] = (p[1]=7) x (np[19]=175) via (p[1]=7) x (np[0]=25); [1] 7x5x5
-        30*6-1 =       179 IS     prime        p[38];       179=hi of 1 factor(s) [1]:          32041=hi*[1] = (p[38]=179) x (p[38]=179); [1] 179
-        30*6+1 =       181 IS     prime        p[39];       181=hi of 1 factor(s) [1]:          32761=hi*[1] = (p[39]=181) x (p[39]=181); [1] 181
-        31*6-1 =       185 IS NOT prime       np[20];        37=hi of 2 factor(s) [1]:           6845=hi*[1] = (p[9]=37) x (np[20]=185) via (p[9]=37) x (p[0]=5); [1] 37x5
-        31*6+1 =       187 IS NOT prime       np[21];        17=hi of 2 factor(s) [1]:           3179=hi*[1] = (p[4]=17) x (np[21]=187) via (p[4]=17) x (p[2]=11); [1] 17x11
-        32*6-1 =       191 IS     prime        p[40];       191=hi of 1 factor(s) [1]:          36481=hi*[1] = (p[40]=191) x (p[40]=191); [1] 191
-        32*6+1 =       193 IS     prime        p[41];       193=hi of 1 factor(s) [1]:          37249=hi*[1] = (p[41]=193) x (p[41]=193); [1] 193
-        33*6-1 =       197 IS     prime        p[42];       197=hi of 1 factor(s) [1]:          38809=hi*[1] = (p[42]=197) x (p[42]=197); [1] 197
-        33*6+1 =       199 IS     prime        p[43];       199=hi of 1 factor(s) [1]:          39601=hi*[1] = (p[43]=199) x (p[43]=199); [1] 199
-        34*6-1 =       203 IS NOT prime       np[22];        29=hi of 2 factor(s) [1]:           5887=hi*[1] = (p[7]=29) x (np[22]=203) via (p[7]=29) x (p[1]=7); [1] 29x7
-        34*6+1 =       205 IS NOT prime       np[23];        41=hi of 2 factor(s) [1]:           8405=hi*[1] = (p[10]=41) x (np[23]=205) via (p[10]=41) x (p[0]=5); [1] 41x5
-        35*6-1 =       209 IS NOT prime       np[24];        19=hi of 2 factor(s) [1]:           3971=hi*[1] = (p[5]=19) x (np[24]=209) via (p[5]=19) x (p[2]=11); [1] 19x11
-        35*6+1 =       211 IS     prime        p[44];       211=hi of 1 factor(s) [1]:          44521=hi*[1] = (p[44]=211) x (p[44]=211); [1] 211
-        36*6-1 =       215 IS NOT prime       np[25];        43=hi of 2 factor(s) [1]:           9245=hi*[1] = (p[11]=43) x (np[25]=215) via (p[11]=43) x (p[0]=5); [1] 43x5
-        36*6+1 =       217 IS NOT prime       np[26];        31=hi of 2 factor(s) [1]:           6727=hi*[1] = (p[8]=31) x (np[26]=217) via (p[8]=31) x (p[1]=7); [1] 31x7
-        37*6-1 =       221 IS NOT prime       np[27];        17=hi of 2 factor(s) [1]:           3757=hi*[1] = (p[4]=17) x (np[27]=221) via (p[4]=17) x (p[3]=13); [1] 17x13
-        37*6+1 =       223 IS     prime        p[45];       223=hi of 1 factor(s) [1]:          49729=hi*[1] = (p[45]=223) x (p[45]=223); [1] 223
-        38*6-1 =       227 IS     prime        p[46];       227=hi of 1 factor(s) [1]:          51529=hi*[1] = (p[46]=227) x (p[46]=227); [1] 227
-        38*6+1 =       229 IS     prime        p[47];       229=hi of 1 factor(s) [1]:          52441=hi*[1] = (p[47]=229) x (p[47]=229); [1] 229
-        39*6-1 =       233 IS     prime        p[48];       233=hi of 1 factor(s) [1]:          54289=hi*[1] = (p[48]=233) x (p[48]=233); [1] 233
-        39*6+1 =       235 IS NOT prime       np[28];        47=hi of 2 factor(s) [1]:          11045=hi*[1] = (p[12]=47) x (np[28]=235) via (p[12]=47) x (p[0]=5); [1] 47x5
-        40*6-1 =       239 IS     prime        p[49];       239=hi of 1 factor(s) [1]:          57121=hi*[1] = (p[49]=239) x (p[49]=239); [1] 239
-        40*6+1 =       241 IS     prime        p[50];       241=hi of 1 factor(s) [1]:          58081=hi*[1] = (p[50]=241) x (p[50]=241); [1] 241
-        41*6-1 =       245 IS NOT prime       np[29];         7=hi of 3 factor(s) [1]:           1715=hi*[1] = (p[1]=7) x (np[29]=245) via (p[1]=7) x (np[1]=35); [1] 7x7x5
-        41*6+1 =       247 IS NOT prime       np[30];        19=hi of 2 factor(s) [1]:           4693=hi*[1] = (p[5]=19) x (np[30]=247) via (p[5]=19) x (p[3]=13); [1] 19x13
...
```

```
...
-    999990*6-1 =   5999939 IS NOT prime  np[1587133];    545449=hi of 2 factor(s) [1]:  3272660727611=hi*[1] = (p[44974]=545449) x (np[1587133]=5999939) via (p[44974]=545449) x (p[2]=11); [1] 545449x11
-    999990*6+1 =   5999941 IS NOT prime  np[1587134];       739=hi of 3 factor(s) [1]:     4433956399=hi*[1] = (p[128]=739) x (np[1587134]=5999941) via (p[128]=739) x (np[1686]=8119); [1] 739x353x23
-    999991*6-1 =   5999945 IS NOT prime  np[1587135];    171427=hi of 3 factor(s) [1]:  1028552571515=hi*[1] = (p[15613]=171427) x (np[1587135]=5999945) via (p[15613]=171427) x (np[1]=35); [1] 171427x7x5
-    999991*6+1 =   5999947 IS     prime    p[412845];   5999947=hi of 1 factor(s) [1]: 35999364002809=hi*[1] = (p[412845]=5999947) x (p[412845]=5999947); [1] 5999947
-    999992*6-1 =   5999951 IS NOT prime  np[1587136];     13921=hi of 2 factor(s) [1]:    83525317871=hi*[1] = (p[1643]=13921) x (np[1587136]=5999951) via (p[1643]=13921) x (p[80]=431); [1] 13921x431
-    999992*6+1 =   5999953 IS NOT prime  np[1587137];       691=hi of 3 factor(s) [1]:     4145967523=hi*[1] = (p[122]=691) x (np[1587137]=5999953) via (p[122]=691) x (np[1814]=8683); [1] 691x457x19
-    999993*6-1 =   5999957 IS NOT prime  np[1587138];      5231=hi of 3 factor(s) [1]:    31385775067=hi*[1] = (p[692]=5231) x (np[1587138]=5999957) via (p[692]=5231) x (np[194]=1147); [1] 5231x37x31
-    999993*6+1 =   5999959 IS NOT prime  np[1587139];    857137=hi of 2 factor(s) [1]:  5142786857383=hi*[1] = (p[68136]=857137) x (np[1587139]=5999959) via (p[68136]=857137) x (p[1]=7); [1] 857137x7
-    999994*6-1 =   5999963 IS NOT prime  np[1587140];    352939=hi of 2 factor(s) [1]:  2117620941257=hi*[1] = (p[30207]=352939) x (np[1587140]=5999963) via (p[30207]=352939) x (p[4]=17); [1] 352939x17
-    999994*6+1 =   5999965 IS NOT prime  np[1587141];   1199993=hi of 2 factor(s) [1]:  7199916000245=hi*[1] = (p[92934]=1199993) x (np[1587141]=5999965) via (p[92934]=1199993) x (p[0]=5); [1] 1199993x5
-    999995*6-1 =   5999969 IS NOT prime  np[1587142];     33149=hi of 2 factor(s) [1]:   198892972381=hi*[1] = (p[3549]=33149) x (np[1587142]=5999969) via (p[3549]=33149) x (p[39]=181); [1] 33149x181
-    999995*6+1 =   5999971 IS NOT prime  np[1587143];      1433=hi of 3 factor(s) [1]:     8597958443=hi*[1] = (p[224]=1433) x (np[1587143]=5999971) via (p[224]=1433) x (np[822]=4187); [1] 1433x79x53
-    999996*6-1 =   5999975 IS NOT prime  np[1587144];    239999=hi of 3 factor(s) [1]:  1439988000025=hi*[1] = (p[21218]=239999) x (np[1587144]=5999975) via (p[21218]=239999) x (np[0]=25); [1] 239999x5x5
-    999996*6+1 =   5999977 IS NOT prime  np[1587145];     17291=hi of 2 factor(s) [1]:   103745602307=hi*[1] = (p[1984]=17291) x (np[1587145]=5999977) via (p[1984]=17291) x (p[66]=347); [1] 17291x347
-    999997*6-1 =   5999981 IS NOT prime  np[1587146];     11257=hi of 3 factor(s) [1]:    67541786117=hi*[1] = (p[1358]=11257) x (np[1587146]=5999981) via (p[1358]=11257) x (np[79]=533); [1] 11257x41x13
-    999997*6+1 =   5999983 IS NOT prime  np[1587147];      2341=hi of 3 factor(s) [1]:    14045960203=hi*[1] = (p[344]=2341) x (np[1587147]=5999983) via (p[344]=2341) x (np[480]=2563); [1] 2341x233x11
-    999998*6-1 =   5999987 IS NOT prime  np[1587148];       449=hi of 4 factor(s) [1]:     2693994163=hi*[1] = (p[84]=449) x (np[1587148]=5999987) via (p[84]=449) x (np[2870]=13363); [1] 449x83x23x7
-    999998*6+1 =   5999989 IS NOT prime  np[1587149];      3919=hi of 2 factor(s) [1]:    23513956891=hi*[1] = (p[540]=3919) x (np[1587149]=5999989) via (p[540]=3919) x (p[239]=1531); [1] 3919x1531
-    999999*6-1 =   5999993 IS     prime    p[412846];   5999993=hi of 1 factor(s) [1]: 35999916000049=hi*[1] = (p[412846]=5999993) x (p[412846]=5999993); [1] 5999993
-    999999*6+1 =   5999995 IS NOT prime  np[1587150];   1199999=hi of 2 factor(s) [1]:  7199988000005=hi*[1] = (p[92935]=1199999) x (np[1587150]=5999995) via (p[92935]=1199999) x (p[0]=5); [1] 1199999x5
-   1000000*6-1 =   5999999 IS NOT prime  np[1587151];      5923=hi of 2 factor(s) [1]:    35537994077=hi*[1] = (p[775]=5923) x (np[1587151]=5999999) via (p[775]=5923) x (p[167]=1013); [1] 5923x1013
-   1000000*6+1 =   6000001 IS NOT prime  np[1587152];    122449=hi of 3 factor(s) [1]:   734694122449=hi*[1] = (p[11514]=122449) x (np[1587152]=6000001) via (p[11514]=122449) x (np[2]=49); [1] 122449x7x7
```

```
- 2000000 integers on 6n +/- 1 between 5 and 6000001
- 1587153 non-primes between 5 and 6000001
- 412847 primes between 5 and 6000001: 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 .. 5999743 5999767 5999779 5999831 5999863 5999869 5999881 5999909 5999911 5999921 5999923 5999927 5999933 5999947 5999993
- show how prime factor lo used, e.g. 83854*6+1 = 503125 = 23x7x5x5x5x5x5 with 7 factors; 1 factor not shown for brevity:
-         5 prime lo factor used 400000 total = 1 +  92936 for 2 factors 166897 for 3 factors 102119 for 4 factors  31133 for 5 factors   5989 for 6 factors    831 for 7 factors     88 for 8 factors      6 for 9 factors
-         7 prime lo factor used 228572 total = 1 +  68136 for 2 factors 104634 for 3 factors  46669 for 4 factors   8370 for 5 factors    727 for 6 factors     34 for 7 factors      1 for 8 factors
-        11 prime lo factor used 124676 total = 1 +  44973 for 2 factors  59343 for 3 factors  18689 for 4 factors   1639 for 5 factors     31 for 6 factors
-        13 prime lo factor used  95904 total = 1 +  38570 for 2 factors  45870 for 3 factors  10960 for 4 factors    502 for 5 factors      1 for 6 factors
-        17 prime lo factor used  67697 total = 1 +  30204 for 2 factors  31954 for 3 factors   5452 for 4 factors     86 for 5 factors
-        19 prime lo factor used  57009 total = 1 +  27251 for 2 factors  26436 for 3 factors   3305 for 4 factors     16 for 5 factors
-        23 prime lo factor used  44611 total = 1 +  22895 for 2 factors  20047 for 3 factors   1668 for 4 factors
-        29 prime lo factor used  33843 total = 1 +  18528 for 2 factors  14588 for 3 factors    726 for 4 factors
-        31 prime lo factor used  30574 total = 1 +  17448 for 2 factors  12714 for 3 factors    411 for 4 factors
-        37 prime lo factor used  24801 total = 1 +  14851 for 2 factors   9798 for 3 factors    151 for 4 factors
-        41 prime lo factor used  21786 total = 1 +  13525 for 2 factors   8204 for 3 factors     56 for 4 factors
-        43 prime lo factor used  20278 total = 1 +  12956 for 2 factors   7300 for 3 factors     21 for 4 factors
-        47 prime lo factor used  18134 total = 1 +  11941 for 2 factors   6190 for 3 factors      2 for 4 factors
-        53 prime lo factor used  15734 total = 1 +  10714 for 2 factors   5019 for 3 factors
-        59 prime lo factor used  13853 total = 1 +   9722 for 2 factors   4130 for 3 factors
-        61 prime lo factor used  13150 total = 1 +   9427 for 2 factors   3722 for 3 factors
-        67 prime lo factor used  11747 total = 1 +   8653 for 2 factors   3093 for 3 factors
-        71 prime lo factor used  10891 total = 1 +   8219 for 2 factors   2671 for 3 factors
-        73 prime lo factor used  10417 total = 1 +   8016 for 2 factors   2400 for 3 factors
-        79 prime lo factor used   9458 total = 1 +   7457 for 2 factors   2000 for 3 factors
-        83 prime lo factor used   8861 total = 1 +   7134 for 2 factors   1726 for 3 factors
-        89 prime lo factor used   8133 total = 1 +   6691 for 2 factors   1441 for 3 factors
-        97 prime lo factor used   7349 total = 1 +   6195 for 2 factors   1153 for 3 factors
-       101 prime lo factor used   6969 total = 1 +   5980 for 2 factors    988 for 3 factors
-       103 prime lo factor used   6751 total = 1 +   5875 for 2 factors    875 for 3 factors
-       107 prime lo factor used   6413 total = 1 +   5661 for 2 factors    751 for 3 factors
-       109 prime lo factor used   6222 total = 1 +   5565 for 2 factors    656 for 3 factors
-       113 prime lo factor used   5934 total = 1 +   5388 for 2 factors    545 for 3 factors
-       127 prime lo factor used   5216 total = 1 +   4841 for 2 factors    374 for 3 factors
-       131 prime lo factor used   5017 total = 1 +   4712 for 2 factors    304 for 3 factors
-       137 prime lo factor used   4769 total = 1 +   4531 for 2 factors    237 for 3 factors
-       139 prime lo factor used   4670 total = 1 +   4475 for 2 factors    194 for 3 factors
-       149 prime lo factor used   4323 total = 1 +   4194 for 2 factors    128 for 3 factors
-       151 prime lo factor used   4245 total = 1 +   4142 for 2 factors    102 for 3 factors
-       157 prime lo factor used   4067 total = 1 +   3997 for 2 factors     69 for 3 factors
-       163 prime lo factor used   3908 total = 1 +   3867 for 2 factors     40 for 3 factors
-       167 prime lo factor used   3805 total = 1 +   3778 for 2 factors     26 for 3 factors
-       173 prime lo factor used   3679 total = 1 +   3665 for 2 factors     13 for 3 factors
-       179 prime lo factor used   3551 total = 1 +   3547 for 2 factors      3 for 3 factors
-       181 prime lo factor used   3513 total = 1 +   3511 for 2 factors      1 for 3 factors
-       191 prime lo factor used   3344 total = 1 +   3343 for 2 factors
-       193 prime lo factor used   3307 total = 1 +   3306 for 2 factors
-       197 prime lo factor used   3245 total = 1 +   3244 for 2 factors
-       199 prime lo factor used   3217 total = 1 +   3216 for 2 factors
- ...
-  800834 occurrences for unique non-primes with 2 factors, e.g. 5999999 = 5923x1013
-  546636 occurrences for unique non-primes with 3 factors, e.g. 6000001 = 122449x7x7
-  190229 occurrences for unique non-primes with 4 factors, e.g. 5999987 = 449x83x23x7
-   41746 occurrences for unique non-primes with 5 factors, e.g. 5999875 = 6857x7x5x5x5
-    6748 occurrences for unique non-primes with 6 factors, e.g. 5999375 = 331x29x5x5x5x5
-     865 occurrences for unique non-primes with 7 factors, e.g. 5996875 = 101x19x5x5x5x5x5
-      89 occurrences for unique non-primes with 8 factors, e.g. 5890625 = 29x13x5x5x5x5x5x5
-       6 occurrences for unique non-primes with 9 factors, e.g. 5359375 = 7x7x7x5x5x5x5x5x5
- 1587153 occurrences for unique non-primes with * factors
```

```
$ perl sohf.pl | egrep "; \[1\] 5x"
-         4*6+1 =        25 IS NOT prime        np[0];         5=hi of 2 factor(s) [1]:            125=hi*[1] = (p[0]=5) x (np[0]=25) via (p[0]=5) x (p[0]=5); [1] 5x5
-        21*6-1 =       125 IS NOT prime       np[12];         5=hi of 3 factor(s) [1]:            625=hi*[1] = (p[0]=5) x (np[12]=125) via (p[0]=5) x (np[0]=25); [1] 5x5x5
-       104*6+1 =       625 IS NOT prime       np[95];         5=hi of 4 factor(s) [1]:           3125=hi*[1] = (p[0]=5) x (np[95]=625) via (p[0]=5) x (np[12]=125); [1] 5x5x5x5
-       521*6-1 =      3125 IS NOT prime      np[597];         5=hi of 5 factor(s) [1]:          15625=hi*[1] = (p[0]=5) x (np[597]=3125) via (p[0]=5) x (np[95]=625); [1] 5x5x5x5x5
-      2604*6+1 =     15625 IS NOT prime     np[3388];         5=hi of 6 factor(s) [1]:          78125=hi*[1] = (p[0]=5) x (np[3388]=15625) via (p[0]=5) x (np[597]=3125); [1] 5x5x5x5x5x5
-     13021*6-1 =     78125 IS NOT prime    np[18371];         5=hi of 7 factor(s) [1]:         390625=hi*[1] = (p[0]=5) x (np[18371]=78125) via (p[0]=5) x (np[3388]=15625); [1] 5x5x5x5x5x5x5
-     65104*6+1 =    390625 IS NOT prime    np[97091];         5=hi of 8 factor(s) [1]:        1953125=hi*[1] = (p[0]=5) x (np[97091]=390625) via (p[0]=5) x (np[18371]=78125); [1] 5x5x5x5x5x5x5x5
-    325521*6-1 =   1953125 IS NOT prime   np[505329];         5=hi of 9 factor(s) [1]:        9765625=hi*[1] = (p[0]=5) x (np[505329]=1953125) via (p[0]=5) x (np[97091]=390625); [1] 5x5x5x5x5x5x5x5x5
```

```
$ perl sohf.pl | egrep "of 7 factor.*x7$" | nl
     1	-    137257*6+1 =    823543 IS NOT prime   np[208830];         7=hi of 7 factor(s) [1]:        5764801=hi*[1] = (p[1]=7) x (np[208830]=823543) via (p[1]=7) x (np[28119]=117649); [1] 7x7x7x7x7x7x7
     2	-    215690*6-1 =   1294139 IS NOT prime   np[331764];        11=hi of 7 factor(s) [1]:       14235529=hi*[1] = (p[2]=11) x (np[331764]=1294139) via (p[2]=11) x (np[28119]=117649); [1] 11x7x7x7x7x7x7
     3	-    254906*6+1 =   1529437 IS NOT prime   np[393574];        13=hi of 7 factor(s) [1]:       19882681=hi*[1] = (p[3]=13) x (np[393574]=1529437) via (p[3]=13) x (np[28119]=117649); [1] 13x7x7x7x7x7x7
     4	-    333339*6-1 =   2000033 IS NOT prime   np[517743];        17=hi of 7 factor(s) [1]:       34000561=hi*[1] = (p[4]=17) x (np[517743]=2000033) via (p[4]=17) x (np[28119]=117649); [1] 17x7x7x7x7x7x7
     5	-    338941*6+1 =   2033647 IS NOT prime   np[526601];        11=hi of 7 factor(s) [1]:       22370117=hi*[1] = (p[2]=11) x (np[526601]=2033647) via (p[2]=11) x (np[44892]=184877); [1] 11x11x7x7x7x7x7
     6	-    372555*6+1 =   2235331 IS NOT prime   np[580026];        19=hi of 7 factor(s) [1]:       42471289=hi*[1] = (p[5]=19) x (np[580026]=2235331) via (p[5]=19) x (np[28119]=117649); [1] 19x7x7x7x7x7x7
     7	-    400567*6-1 =   2403401 IS NOT prime   np[624608];        13=hi of 7 factor(s) [1]:       31244213=hi*[1] = (p[3]=13) x (np[624608]=2403401) via (p[3]=13) x (np[44892]=184877); [1] 13x11x7x7x7x7x7
     8	-    450988*6-1 =   2705927 IS NOT prime   np[704933];        23=hi of 7 factor(s) [1]:       62236321=hi*[1] = (p[6]=23) x (np[704933]=2705927) via (p[6]=23) x (np[28119]=117649); [1] 23x7x7x7x7x7x7
     9	-    473397*6+1 =   2840383 IS NOT prime   np[740648];        13=hi of 7 factor(s) [1]:       36924979=hi*[1] = (p[3]=13) x (np[740648]=2840383) via (p[3]=13) x (np[53350]=218491); [1] 13x13x7x7x7x7x7
    10	-    523818*6+1 =   3142909 IS NOT prime   np[821271];        17=hi of 7 factor(s) [1]:       53429453=hi*[1] = (p[4]=17) x (np[821271]=3142909) via (p[4]=17) x (np[44892]=184877); [1] 17x11x7x7x7x7x7
    11	-    532622*6-1 =   3195731 IS NOT prime   np[835328];        11=hi of 7 factor(s) [1]:       35153041=hi*[1] = (p[2]=11) x (np[835328]=3195731) via (p[2]=11) x (np[71574]=290521); [1] 11x11x11x7x7x7x7
    12	-    568637*6-1 =   3411821 IS NOT prime   np[892927];        29=hi of 7 factor(s) [1]:       98942809=hi*[1] = (p[7]=29) x (np[892927]=3411821) via (p[7]=29) x (np[28119]=117649); [1] 29x7x7x7x7x7x7
    13	-    585444*6-1 =   3512663 IS NOT prime   np[919903];        19=hi of 7 factor(s) [1]:       66740597=hi*[1] = (p[5]=19) x (np[919903]=3512663) via (p[5]=19) x (np[44892]=184877); [1] 19x11x7x7x7x7x7
    14	-    607853*6+1 =   3647119 IS NOT prime   np[955817];        31=hi of 7 factor(s) [1]:      113060689=hi*[1] = (p[8]=31) x (np[955817]=3647119) via (p[8]=31) x (np[28119]=117649); [1] 31x7x7x7x7x7x7
    15	-    619058*6-1 =   3714347 IS NOT prime   np[973776];        17=hi of 7 factor(s) [1]:       63143899=hi*[1] = (p[4]=17) x (np[973776]=3714347) via (p[4]=17) x (np[53350]=218491); [1] 17x13x7x7x7x7x7
    16	-    629462*6+1 =   3776773 IS NOT prime   np[990472];        13=hi of 7 factor(s) [1]:       49098049=hi*[1] = (p[3]=13) x (np[990472]=3776773) via (p[3]=13) x (np[71574]=290521); [1] 13x11x11x7x7x7x7
    17	-    691888*6+1 =   4151329 IS NOT prime  np[1090674];        19=hi of 7 factor(s) [1]:       78875251=hi*[1] = (p[5]=19) x (np[1090674]=4151329) via (p[5]=19) x (np[53350]=218491); [1] 19x13x7x7x7x7x7
    18	-    708695*6+1 =   4252171 IS NOT prime  np[1117657];        23=hi of 7 factor(s) [1]:       97799933=hi*[1] = (p[6]=23) x (np[1117657]=4252171) via (p[6]=23) x (np[44892]=184877); [1] 23x11x7x7x7x7x7
    19	-    725502*6+1 =   4353013 IS NOT prime  np[1144728];        37=hi of 7 factor(s) [1]:      161061481=hi*[1] = (p[9]=37) x (np[1144728]=4353013) via (p[9]=37) x (np[28119]=117649); [1] 37x7x7x7x7x7x7
    20	-    743910*6-1 =   4463459 IS NOT prime  np[1174266];        13=hi of 7 factor(s) [1]:       58024967=hi*[1] = (p[3]=13) x (np[1174266]=4463459) via (p[3]=13) x (np[84999]=343343); [1] 13x13x11x7x7x7x7
    21	-    803935*6-1 =   4823609 IS NOT prime  np[1270885];        41=hi of 7 factor(s) [1]:      197767969=hi*[1] = (p[10]=41) x (np[1270885]=4823609) via (p[10]=41) x (np[28119]=117649); [1] 41x7x7x7x7x7x7
    22	-    809537*6+1 =   4857223 IS NOT prime  np[1279915];        17=hi of 7 factor(s) [1]:       82572791=hi*[1] = (p[4]=17) x (np[1279915]=4857223) via (p[4]=17) x (np[70340]=285719); [1] 17x17x7x7x7x7x7
    23	-    823143*6-1 =   4938857 IS NOT prime  np[1301776];        17=hi of 7 factor(s) [1]:       83960569=hi*[1] = (p[4]=17) x (np[1301776]=4938857) via (p[4]=17) x (np[71574]=290521); [1] 17x11x11x7x7x7x7
    24	-    836977*6+1 =   5021863 IS NOT prime  np[1324038];        11=hi of 7 factor(s) [1]:       55240493=hi*[1] = (p[2]=11) x (np[1324038]=5021863) via (p[2]=11) x (np[113977]=456533); [1] 11x11x11x11x7x7x7
    25	-    837549*6-1 =   5025293 IS NOT prime  np[1324963];        23=hi of 7 factor(s) [1]:      115581739=hi*[1] = (p[6]=23) x (np[1324963]=5025293) via (p[6]=23) x (np[53350]=218491); [1] 23x13x7x7x7x7x7
    26	-    843151*6+1 =   5058907 IS NOT prime  np[1333983];        43=hi of 7 factor(s) [1]:      217533001=hi*[1] = (p[11]=43) x (np[1333983]=5058907) via (p[11]=43) x (np[28119]=117649); [1] 43x7x7x7x7x7x7
    27	-    879166*6+1 =   5274997 IS NOT prime  np[1392029];        13=hi of 7 factor(s) [1]:       68574961=hi*[1] = (p[3]=13) x (np[1392029]=5274997) via (p[3]=13) x (np[100971]=405769); [1] 13x13x13x7x7x7x7
    28	-    893572*6+1 =   5361433 IS NOT prime  np[1415270];        29=hi of 7 factor(s) [1]:      155481557=hi*[1] = (p[7]=29) x (np[1415270]=5361433) via (p[7]=29) x (np[44892]=184877); [1] 29x11x7x7x7x7x7
    29	-    904777*6-1 =   5428661 IS NOT prime  np[1433352];        19=hi of 7 factor(s) [1]:      103144559=hi*[1] = (p[5]=19) x (np[1433352]=5428661) via (p[5]=19) x (np[70340]=285719); [1] 19x17x7x7x7x7x7
    30	-    919983*6+1 =   5519899 IS NOT prime  np[1457910];        19=hi of 7 factor(s) [1]:      104878081=hi*[1] = (p[5]=19) x (np[1457910]=5519899) via (p[5]=19) x (np[71574]=290521); [1] 19x11x11x7x7x7x7
    31	-    921584*6-1 =   5529503 IS NOT prime  np[1460509];        47=hi of 7 factor(s) [1]:      259886641=hi*[1] = (p[12]=47) x (np[1460509]=5529503) via (p[12]=47) x (np[28119]=117649); [1] 47x7x7x7x7x7x7
    32	-    955198*6-1 =   5731187 IS NOT prime  np[1514776];        31=hi of 7 factor(s) [1]:      177666797=hi*[1] = (p[8]=31) x (np[1514776]=5731187) via (p[8]=31) x (np[44892]=184877); [1] 31x11x7x7x7x7x7
    33	-    972805*6+1 =   5836831 IS NOT prime  np[1543262];        17=hi of 7 factor(s) [1]:       99226127=hi*[1] = (p[4]=17) x (np[1543262]=5836831) via (p[4]=17) x (np[84999]=343343); [1] 17x13x11x7x7x7x7
    34	-    989155*6-1 =   5934929 IS NOT prime  np[1569598];        13=hi of 7 factor(s) [1]:       77154077=hi*[1] = (p[3]=13) x (np[1569598]=5934929) via (p[3]=13) x (np[113977]=456533); [1] 13x11x11x11x7x7x7
```
