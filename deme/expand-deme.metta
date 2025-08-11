;; python binding for ceiling functionality
;; this dont appear to work while importing to the another file
! (bind! ceil (py-atom math.ceil))
;;! (bind! rand (py-atom random.randint))
;; integer indices to feature names
(= (fsToNames $labels $ft-indices)
	(collapse (chain (superpose $ft-indices) $ft 
		(List.at $ft $labels))))
		
;; something weird going on here
!(bind! a (2 3))
!(bind! Da 3)

;; subsample by row
;; result -- depending on the number of subsampling demes, a set of rows to be ignored during optimization by each deme

(= (ssByRow (mkITable $table $lables) $nSubSample)
	(chain (List.length $table) $row-count
		(chain (range 0 1 $row-count) $r-indices 
		(chain (shuffle $r-indices ()) $shuffled-indices
			(chain (ceil (/ $row-count $nSubSample)) $to-ignore-count 
					(ssIterator $shuffled-indices $to-ignore-count ()))))))		
(= (ssIterator $shuffled-indices $rowCount $acc)
	(if (== $shuffled-indices ())
		$acc
		(let* (($sampled-r (takeN $rowCount $shuffled-indices))
			   ($rem-indices (subtraction-atom $shuffled-indices $sampled-r))
			   ($new-acc (cons-atom $sampled-r $acc)))
				
				(ssIterator $rem-indices $rowCount $new-acc))))
	