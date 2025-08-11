;; integer indices to feature names
(= (fsToNames $labels $ft-indices)
	(collapse (chain (superpose $ft-indices) $ft 
		(List.at $ft $labels))))
		
;; something weird going on here
!(bind! a (2 3))
!(bind! Da 3)
