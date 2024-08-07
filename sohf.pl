use strict;
use Math::Prime::Util;

my $double_check_primes = 1;
my @p;
my $pi = 0;
my @np;
my $npi = 0;
my $h;
my $p2pi;
my $prime_candidate_last;
my $n = 100_000;
my $p_f;
my $f_eg;

my @a;
if($double_check_primes){
	@a = @{Math::Prime::Util::primes( $n * 6 + 1 )};
	shift @a; shift @a;
}

printf qq[- The sieve of Hardy-Francis is a modern algorithm for finding all prime numbers up to any given limit.\n];
printf qq[- It does so by iteratively finding primes and marking as composite (i.e. not prime) the unique prime multiplies of each prime, starting with the 3rd prime number, 5.\n];
printf qq[- This is the sieve's key distinction from the sieve of Eratosthenes where non-unique multiplies of each prime result in more marking [1].\n];
printf qq[- Another distinction is the sieve also reveals primes in order as the algorithm is running, and must not mark all composites first.\n];
printf qq[- Another distinction is the sieve only considers a subset of integers; 6n +/- 1.\n];
printf qq[- [1] E.g. 2x3 and 3x2 result in double marking the prime candidate 6.\n];
printf qq[\n];
printf qq[- To find all the prime numbers less than or equal to a given integer n by Hardy-Francis' method:\n];
printf qq[- 1. Enumerate through candidate integers from 5 through n via 6n +/- 1, e.g. if n=250 (5, 7, 11, 13, ..., 239, 241, 245, 247).\n];
printf qq[- 2. At each integer perform candidate business logic, and if not marked, the candidate is prime.\n];
printf qq[- 3. Business logic at candidate:\n];
printf qq[- At any candidate, mark a unique more_factors_count_future_candidate which is candidate x candidate highest prime factor, i.e. one factor bigger.\n];
printf qq[- At non-prime candidate, mark a unique same_factors_count_future_candidate which is the product of candidate factors after the highest prime factor is replaced with the next highest prime factor.\n];
printf qq[- Example business logic -- for non-consecutive candidates -- resulting from candidate 5 which is prime:\n];
printf qq[- At candidate=5   so more_factors_count_future_candidate = 5 x  5          =   25, i.e. candidate is prime.\n];
printf qq[- At candidate=25  so more_factors_count_future_candidate = 5 x  5 x  5     =  125, i.e. extra prime factor is also highest prime factor  5\n];
printf qq[- At candidate=25  so same_factors_count_future_candidate = 5 x  7          =   35, i.e. candidate is non-prime and highest prime factor  5 is replaced with next highest prime factor  7.\n];
printf qq[- At candidate=35  so more_factors_count_future_candidate = 5 x  7 x  7     =  245, i.e. extra prime factor is also highest prime factor  7\n];
printf qq[- At candidate=35  so same_factors_count_future_candidate = 5 x 11          =   55, i.e. candidate is non-prime and highest prime factor  7 is replaced with next highest prime factor 11.\n];
printf qq[- At candidate=55  so more_factors_count_future_candidate = 5 x 11 x 11     =  605, i.e. extra prime factor is also highest prime factor 11\n];
printf qq[- At candidate=55  so same_factors_count_future_candidate = 5 x 13          =   65, i.e. candidate is non-prime and highest prime factor 11 is replaced with next highest prime factor 13.\n];
printf qq[- At candidate=65  so more_factors_count_future_candidate = 5 x 13 x 13     =  845, i.e. extra prime factor is also highest prime factor 13\n];
printf qq[- At candidate=65  so same_factors_count_future_candidate = 5 x 17          =   85, i.e. candidate is non-prime and highest prime factor 13 is replaced with next highest prime factor 17.\n];
printf qq[- At candidate=85  so more_factors_count_future_candidate = 5 x 17 x 17     = 1445, i.e. extra prime factor is also highest prime factor 17\n];
printf qq[- At candidate=85  so same_factors_count_future_candidate = 5 x 19          =   95, i.e. candidate is non-prime and highest prime factor 17 is replaced with next highest prime factor 19.\n];
printf qq[- At candidate=95  so more_factors_count_future_candidate = 5 x 19 x 19     = 1805, i.e. extra prime factor is also highest prime factor 19\n];
printf qq[- At candidate=95  so same_factors_count_future_candidate = 5 x 23          =  115, i.e. candidate is non-prime and highest prime factor 19 is replaced with next highest prime factor 23.\n];
printf qq[- At candidate=115 so more_factors_count_future_candidate = 5 x 23 x 23     = 2645, i.e. extra prime factor is also highest prime factor 23\n];
printf qq[- At candidate=115 so same_factors_count_future_candidate = 5 x 29          =  145, i.e. candidate is non-prime and highest prime factor 23 is replaced with next highest prime factor 29.\n];
printf qq[- At candidate=125 so more_factors_count_future_candidate = 5 x  5 x  5 x 5 =  625, i.e. extra prime factor is also highest prime factor  5\n];
printf qq[- At candidate=125 so same_factors_count_future_candidate = 5 x  5 x  7     =  175, i.e. candidate is non-prime and highest prime factor  5 is replaced with next highest prime factor  7.\n];
printf qq[\n];
printf qq[- Conjecture 1: The factor(s) for 6n +/- 1 are always prime.\n];
printf qq[- Conjecture 2: The integers for 6n +/- 1 only get marked once using the above algorithm.\n];
printf qq[\n];
printf qq[- Notes on this slower reference implementation:\n];
printf qq[- 1. Marking future candidates is implemented via a hash table, which is also used to sanity check that marking is unique per candidate.\n];
printf qq[- 2. An alternative prime numbers library is used to validate the results of this algorithm\n];
printf qq[- 3. The business logic instrumentation for each candidate is presented on a single line\n];
printf qq[- 4. Perhaps a faster C implementation is possible with sort-by-insertion double linked lists replacing the hash table?\n];
printf qq[\n];

printf qq[- For each prime candidate in the sequence 6n +/- 1, run business logic to discover if it's prime:\n];
foreach my $n(1..$n){
	is_prime($n, -1);
	is_prime($n, +1);
}
my $p_lo = join(" ", @p[0..14]);
my $p_hi = join(" ", @p[($#p-14)..($#p-0)]);
printf qq[- %d integers on 6n +/- 1 between %d and %d\n], scalar(@np) + scalar(@p), 5, 6 * $n + 1;
printf qq[- %d non-primes between %d and %d\n], scalar @np, 5, 6 * $n + 1;
printf qq[- %d primes between %d and %d: %s .. %s\n], scalar @p, 5, 6 * $n + 1, $p_lo, $p_hi;

printf qq[- show how prime factor lo used, e.g. 83854*6+1 = 503125 = 23x7x5x5x5x5x5 with 7 factors; 1 factor not shown for brevity:\n];
my $f;
foreach my $prime_factors_lo(sort {$a <=> $b} keys %{$p_f}){
	if($prime_factors_lo < 200){
		printf qq[- %9d prime lo factor used], $prime_factors_lo;
	}
	my $prime_factors_lo_t = 0;
	foreach my $prime_factors_num(sort {$a <=> $b} keys %{$p_f->{$prime_factors_lo}}){
		$prime_factors_lo_t += $p_f->{$prime_factors_lo}{$prime_factors_num}
	}
	if($prime_factors_lo < 200){
		printf qq[ %6d total = 1 +], $prime_factors_lo_t;
	}
	foreach my $prime_factors_num(sort {$a <=> $b} keys %{$p_f->{$prime_factors_lo}}){
		next if(1 == $prime_factors_num);
		if($prime_factors_lo < 200){
			printf qq[ %6d for %d factors], $p_f->{$prime_factors_lo}{$prime_factors_num}, $prime_factors_num;
		}
		$f->{$prime_factors_num} += $p_f->{$prime_factors_lo}{$prime_factors_num};
	}
	if($prime_factors_lo < 200){
		printf qq[\n];
	}
}
printf qq[- ...\n];
my $ft = 0;
foreach my $prime_factors_num(sort {$a <=> $b} keys %{$f}){
	printf qq[- %6d occurrences for unique non-primes with %d factors, e.g. %s\n], $f->{$prime_factors_num}, $prime_factors_num, $f_eg->{$prime_factors_num};
	$ft += $f->{$prime_factors_num};
}
printf qq[- %6d occurrences for unique non-primes with * factors\n], $ft;

my $ai = 0;

sub is_prime{
	my ($n, $pom) = @_;
	my $prime_candidate = 6 * $n + $pom;
	my @prime_factors = Math::Prime::Util::factor( $prime_candidate );
	my @prime_factors_s = sort {$b <=> $a} @prime_factors;
	my $prime_factors_s_x = join("x", @prime_factors_s);
	my $prime_factors_hi = $prime_factors_s[0];
	my $prime_factors_lo = $prime_factors_s[$#prime_factors_s];
	my $prime_factors_num = scalar @prime_factors;
	$f_eg->{$prime_factors_num} = sprintf qq[%d = %s], $prime_candidate, $prime_factors_s_x;
	$p_f->{$prime_factors_lo}{$prime_factors_num} ++;
	my $is_prime;
	my $via_next;
	if(exists $h->{$prime_candidate}){
		# come here if prime_candidate is NOT prime
		$is_prime = "IS NOT";
		$np[$npi] = $prime_candidate;
		$npi ++;
		my $_pi = $p2pi->{$prime_factors_hi};
		my $next_non_prime = $p[$_pi] * $prime_candidate;
		die sprintf qq[ERROR: next_non_prime=%d but prime_candidate_last=%d\n], $next_non_prime, $prime_candidate_last if($next_non_prime <= $prime_candidate_last);
		$via_next = sprintf qq[(p[%d]=%d) x (np[%d]=%d)], $_pi, $p[$_pi], $npi - 1, $prime_candidate;
		die sprintf qq[ERROR: next_non_prime=%s already exists for via_next=%s\n], $next_non_prime, $via_next if(exists $h->{$next_non_prime});
		$h->{$next_non_prime} = $via_next;
	}
	else{
		# come here if prime_candidate is prime
		$is_prime = "IS    ";
		$p[$pi] = $prime_candidate;
		$p2pi->{$prime_candidate} = $pi;
		my $next_non_prime = $p[$pi] * $prime_candidate;
		die sprintf qq[ERROR: next_non_prime=%d but prime_candidate_last=%d\n], $next_non_prime, $prime_candidate_last if($next_non_prime <= $prime_candidate_last);
		$via_next = sprintf qq[(p[%d]=%d) x (p[%d]=%d)], $pi, $p[$pi], $pi, $prime_candidate;
		die sprintf qq[ERROR: $next_non_prime=%s already exists for via_next=%s\n], $next_non_prime, $via_next if(exists $h->{$next_non_prime});
		$h->{$next_non_prime} = $via_next;
		$pi ++;
	}
	my $prime_candidate_next = $prime_factors_hi * $prime_candidate;
	my $prime_number = ($is_prime eq "IS NOT") ? sprintf qq[np[%d]], $npi - 1 : sprintf qq[p[%d]], $pi - 1;
	printf qq[- %9d*6%+d = %9d %s prime %12s; %9d=hi of %d factor(s) [1]: %14d=hi*[1] = %s],
		$n, $pom, $prime_candidate, $is_prime, $prime_number, $prime_factors_hi, scalar @prime_factors, $prime_candidate_next, $via_next;
	if($is_prime eq "IS NOT"){
		if(exists $h->{$prime_candidate}){
			my $via = $h->{$prime_candidate}; # e.g. (p[0]=5) x (p[0]=5)
			if($via =~ m~^\(p\[(\d+)\]=\d+\) x \((np|p)\[(\d+)\]=(\d+)\)$~){}else{ printf qq[\nERROR: cannot regex for: %s\n], $via; exit; }
			my ($_pi, $pnp, $_npi, $pf) = ($1, $2, $3, $4);
			$_pi ++;
			my $next_non_prime = $p[$_pi] * $pf;
			my $via_next_next = sprintf qq[(p[%d]=%d) x (%s[%d]=%d)], $_pi, $p[$_pi], $pnp, $_npi, $pf;
			die sprintf qq[ERROR: next_non_prime=%s already exists for via_next=%s\n], $next_non_prime, $via_next if(exists $h->{$next_non_prime});
			$h->{$next_non_prime} = $via_next_next;
#			printf qq[ via %s -> %d = %s], $via, $next_non_prime, $via_next_next;
			printf qq[ via %s], $via;
		}
		else{
			printf qq[\nERROR: no via!\n];
			exit;
		}
	}
	printf qq[; [1] %s], $prime_factors_s_x;
	printf qq[\n];

	if($double_check_primes){
		if(($is_prime eq "IS NOT") && ($prime_candidate != $a[$ai])){
		}
		elsif(($is_prime eq "IS    ") && ($prime_candidate == $a[$ai])){
			$ai ++;
		}
		else{
			printf qq[ERROR: double checking against primes in Math::Prime::Util failed!\n];
			exit;
		}
	}

	$prime_candidate_last = $prime_candidate;
}
