! (bind! ttable (mkITable  
            (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
            (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil))))
            
            (Cons A (Cons B (Cons C (Cons D (Cons Output Nil)))))))

! (bind! dataRows 
            (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
            (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil))))
)            
;; this is implementation of stochastic max dependency feature selection algorithm
;; How it works
;  0 --> vector<feature_set> tops = empty set
;  1 --> For each feature_set fs in tops:
;  2 -->     Add one feature, compute new score. Repeat 1
;  3 --> Discard all but top_size of highest scorers
;  4 --> tops = the highest scorers.
;  5 --> If score hasn't improved by threshold,
;    --> then skip next step.
;  6 --> Repeat, until tops holds feature_sets of at most
;    --> 'num_features' features.
;  7 --> return highest scorer from tops.
;; it appears as though this is built on top of the simple algorithm? .... doesnt it? 

;;  Prametres           
;;                  --   $th    minimum values improvement (in this case MI)                                                  
;;                  --   $numFeatures    desired number of features in the featuresets                                             
;;                  --   $scorer    scorer of importance, MI, Correlation ...?                                            
;;                  --   $acc    an accumulator for feature sets                                          
;; Steps
;;  get set of labels, or indices
;;  start from an empty feature set ()
;;  score each feature using mutual information and add them to the accumulator as ($score $feature)
;;  keep only features that score above a certain threshold -- can be done non-deterministicly
;;  keep the feature set shuffled -- or pick from the labels with randomness -- a concern here -- picking at random could cause the features sets to be redundant - i guess a simple check could avoid that from happening
;;  label indices will be used to form the set of features ... the final output will be tuple of tuples containing indices of columns selected

(= (stochasticMaxDependency $th $numFeatures $topsCount (mkITable $table $labels) $scorer $acc)
    (chain (List.length $labels) $len
    (chain (Table.getColumn (- $len 1) $table ) $oc ;; output column
    (chain (range 0 1 (- $len 1)) $indices          ;; input feature indices    
    (if (== $acc ())
        (chain 
            (collapse 
                (chain (superpose $indices) $i
                (chain (mutualInformation (Table.getColumn $i $table) $oc) $mi 
                    (if (>= $mi $th)
                        (($i) $mi)
                        (Empty))))) $index-mi-pair
                        ;; get each feature and and calculate MI agains out put feature
                        (chain (sortPairs pairMax $index-mi-pair $topsCount ()) $topNSeed (stochasticMaxDependency $th $numFeatures $topsCount (mkITable $table $labels) $scorer $topNSeed)))
        (chain (first (car-atom $acc)) $sample-tuple
            (if (== (size-atom $sample-tuple) $numFeatures)
                $acc
                (chain (second (car-atom $acc)) $prev-highest-score
                (trace! $res (chain 
                    ; (collapse 
                    ; (chain 
                    ; (superpose $acc) $pair
                    ; (chain (first $pair) $used-indices
                    ; (chain (second $pair) $probs
                    ; (chain (random-int 0 $len) $next-index                                              ;; choose at random the next index to append to the or has every possible combination be explored 
                    ;     ; ($next-index (isMember $next-index $used-indices))
                    ; (chain (subtraction-atom $indices $used-indices) $candidate-indices                 ;; removed used indices from index list
                    ;     (chain (union-atom $used-indices ((superpose $candidate-indices))) $new-indices ;; form a union of used indices tuple and one unused index for each such an index
                    ;         (chain (ListZip $new-indices $table) $zipped-input-feature                  ;; form a zipped pair, triplet .. of input feature values from the table
                    ;             ($new-indices (mutualInformation $zipped-input-feature $oc))))) 
                    ; )))
                    ; ))
                    ;; replace the above with one helper function call -- experimenting with the issue in foldl operation 
                    (inputPairMiCalculator $table $oc $indices $acc)
                $res                                                                    ;; collapsed result of pairing scoring
                    ; (foldl-atom $res ((1 2) -inf) $starter $val (pairMax $starter $val))   
                    (chain (shuffle $res ()) $shuffled-pairs 
                    (chain (sortPairs pairMax $shuffled-pairs $topsCount ()) $topN
                    (chain (second (car-atom $topN)) $topScore  ;; $topScore                  ;; shuffling to give pairs with equal scores better chance of being selected for variety
                    ;; terminate the loop if there is no significant improvement
                    (if (< (- $topScore $prev-highest-score) $th)
                        $acc
                        (stochasticMaxDependency $th $numFeatures $topsCount (mkITable $table $labels) $scorer $topN))
                        ; (foldl-atom $shuffled-pairs (() -inf) $seed $pair (pairMax $seed $pair) )                                    ;; using custom foldl functiton to compute maximum from the above result
                        ; (sortPairs pairMax $shuffled-pairs $topsCount ()) 
                        ; $shuffled-pairs 
                        ; (car-atom $shuffled-pairs) 
                        ;; the next step is to find the max value -- possibly after sorting
                        ;; find the difference between the previous highest scorer and the newone
                        ;; if difference is lower than the threshold value stop the loop and return the current top candidate features
                        ;; else continue the loop with the updated candidate list
                        ;; I couldnt proceed from this point -- for reason not clear for me the fold operation doesnt reduce the returned tuple of tuples

                    )))))))))))))

(= (inputPairMiCalculator $table $oc $indices $acc) ;; adds a feature to the previous pair thus grown the index size and calculates the mutual information for that pair, triplet ... of input features
    (collapse 
        (chain (superpose $acc) $pair
            (chain (first $pair) $used-indices
                (chain (second $pair) $probs $probs
                    (chain (subtraction-atom $indices $used-indices) $candidate-indices                   ;; removed used indices from index list
                        (chain (union-atom $used-indices ((superpose $candidate-indices))) $new-indices ;; form a union of used indices tuple and one unused index for each such an index
                            (chain (ListZip $new-indices $table) $zipped-input-feature                  ;; form a zipped pair, triplet .. of input feature values from the table
                                ($new-indices (mutualInformation $zipped-input-feature $oc))))))))))


(= (randomChoice $tuple)
    (chain (size-atom $tuple) $size-atom
        (chain (random-int 0 $size-atom) $int (index-atom $tuple $int))))
        
;; check for equality of expressions -- to make up for ordering issues     
(= (isEqual $a $b)
    (chain (subtraction-atom $a $b) $a-diff 
        (chain (subtraction-atom $b $a) $b-diff (and (== (size-atom $a) (size-atom $b)) (== $a-diff $b-diff)))))

;; ListZip
;; given indices of the table produce a list, as in (Cons ...) of tuple of corresponding values from the table rows
;; assuming the lists are of equal length

;; List.length
(: List.length (-> (List $a) Number))
(= (List.length $list)
    (unify $list Nil 0
        (unify $list (Cons $x $xs)
            (chain (List.length $xs) $res (+ 1 $res))
            (Error $list "UnknownError"))))

(= (ListZip $indices $datarows)
    (if (== $indices ())
        Nil
        (unify $datarows Nil Nil
            (unify $datarows (Cons $row $rows)
                (chain (collapse (let (superpose $indices) $i (List.at $i $row))) $dataTuple
                    (Cons $dataTuple (ListZip $indices $rows)))
                ()))))        


(: List.zip (-> (List $a) (List $b) (List ($a $b))))
(= (List.zip Nil Nil) Nil)
(= (List.zip Nil (Cons $y $ys)) Nil)
(= (List.zip (Cons $x $xs) Nil) Nil)
(= (List.zip (Cons $x $xs) (Cons $y $ys)) (Cons ($x $y) (List.zip $xs $ys)))                    


(: Table.getColumn (-> Number (List (List $a)) (List $a)))
(= (Table.getColumn $i $rows)
    (unify $rows Nil Nil
       (unify $rows (Cons $row $rest)
            (Cons (List.at $i $row) (Table.getColumn $i $rest)) ())))

(= (List.at $i $list)
    (unify $list Nil (Error $list "Empty list")
        (unify $list (Cons $el $els) 
            (if (== $i 0) $el (List.at (- $i 1) $els)))))

(= (List.uniqueValuesCount $list $acc)
    (unify $list Nil $acc
        (unify $list (Cons $x $xs)
            (if (patternExists ($x $c) $acc)
                (chain (updateCount $x $acc) $count-updated
                    (List.uniqueValuesCount $xs $count-updated))
                (chain (union-atom $acc (($x 1))) $new-tuple-added
                    (List.uniqueValuesCount $xs $new-tuple-added))))))
;; check for a pattern in tuple of tuples                
(= (patternExists $pat $collection)
    (let $a (collapse (chain (superpose $collection) $s
        (unify $s $pat True False))) (foldl-atom $a False $acc $i (or $i $acc))))        

(= (updateCount $val $collection)
    (collapse (chain (superpose $collection) $s 
                (unify $s ($val $count) ($val (+ 1 $count)) $s)))) 

;; mutualInformation -- better def maybe?
(= (mutualInformation $if $of)
    (chain (List.zip $if $of) $io-zip $io-zip
    (chain (List.uniqueValuesCount $io-zip ()) $io-c
    (chain (List.length $if) $rowNum
    (chain (List.uniqueValuesCount $if ()) $ic ;; input feature unique values count pairs
    (chain (List.uniqueValuesCount $of ()) $oc 
    (chain (marginalProbs $rowNum $ic) $ip      ;; input feature marginal prob
    (chain (marginalProbs $rowNum $of) $op      ;; target feature marginal probs
    (chain (marginalProbs $rowNum $io-c) $io-p  ;; input output mutual probs
    (chain (collapse (chain (superpose $io-p) $io-prob-pair ;; ((inout output)  prob) piar -- single -- superposed
        (unify $io-prob-pair ($pair $prob)
                (* $prob (lg 2 (/ $prob (* (/ (matchCount $ic (getInput $pair)) $rowNum) (/ (matchCount $oc (getOutput $pair)) $rowNum)))))))) ;; functions named "first" and "second" from `general helpers` could be used 
        $probTuple 
        (chain (foldl-atom $probTuple 0 $acc $x (+ $acc $x)) $final-result (round $final-result 3))))))))))))

;; return marginal probabilities as list (Cons ..) ... or is it better if it was like (p1 p2 ...)??????    
(= (marginalProbs $len $countTuple) ;; depending on how the above goes most of the code for calculating frequencies could be included in this function
    (collapse (chain (superpose $countTuple) $pair (unify $pair ($val $count) ($val (/ $count $len)) ())))) 

(= (getInput ($input $output)) $input)    
(= (getOutput ($input $output)) $output) 

(= (matchCount $tuples $cue)
    (chain (superpose $tuples) $pair 
        (unify $pair ($cue $prob) $prob (Empty))))


(: round (-> Number Number Number))
(= (round $x $precision)  
    (chain (pow-math 10 $precision) $multiplier    
    (chain (* $x $multiplier) $scaled      
    (chain (- $scaled (floor-math $x)) $decimal        
        (if (>= $decimal 0.5)            
        (/ (+ (floor-math $scaled) 1) $multiplier)        
        (/ (floor-math $scaled) $multiplier))))))        

(= (range $l $step $u) ;; generate from $l to $u (excluding) in $step steps 
    (if (== $step 0)
        (Error $step "Step value of 0 not allowed!!")
        (if (=> $l $u)
            ()
            (chain (range (+ $l $step) $step $u) $res
                (cons-atom $l $res)))))

;; From a tuple (Pair) return the first element
(: first (-> ($a $b) $a))
(= (first ($a $b)) $a)

;; From a tuple (Pair) return the second element
(: second (-> ($a $b) $b))   
(= (second ($a $b)) $b)

;; from general helpers
(: isMember (-> $a $aa Bool))
(= (isMember $x $list)
    (not (== (collapse (intersection (superpose ($x)) (superpose $list))) ()))
)

;; pair sorting function taken from mutual-info-helpers.metta
;; might need some tweaking to account for possibility of equal scores
;; sorting pairs 
;; $op -- comparator $pairTuple -- tuple of pairs
;; $count -- sort count -- partial sort
;; $acc -- the accumulator
; (= (sortPairs $op $pairTuple $count $acc)
;     (if (or (<= $count 0) (== $pairTuple ()))
;         (union-atom $acc $pairTuple)
;         ;; find max pair from the tuple of pairs    
;         ;; use of union assumes the pairs are non repeating -- same score is possible but always different label
;         (chain (foldl-atom $pairTuple ((A B) -inf) $ac $pair ($op $ac $pair)) $max-pair
;         (chain (union-atom $acc ($max-pair)) $new-acc
;         (chain (collapse (chain (superpose $pairTuple) $el (if (== $el $max-pair) (Empty) $el))) $rest
;         (sortPairs $op $rest (- $count 1) $new-acc))))))  ;; recursive call

; a slight tweak to the above sorting function with a tweak that removes duplicate expressions in the form of differently ordered item
(= (sortPairs $op $pairTuple $count $acc)
    (if (or (<= $count 0) (== $pairTuple ()))
        ; (union-atom $acc $pairTuple) ;; started as a partial sort
        $acc ;; just sort the top N and return that
        ;; find max pair from the tuple of pairs    
        ;; use of union assumes the pairs are non repeating -- same score is possible but always different label
        (chain (foldl-atom $pairTuple (() -inf) $ac $pair ($op $ac $pair)) $max-pair
        (chain (union-atom $acc ($max-pair)) $new-acc
        (chain (collapse (chain (superpose $pairTuple) $el (if (isPairEqual $el $max-pair) (Empty) $el))) $rest
        (sortPairs $op $rest (- $count 1) $new-acc))))))  ;; recursive call

(= (pairMax ($item1 $val1) ($item2 $val2)) (if (=> $val1 $val2) ($item1 $val1) ($item2 $val2)))        

(: >= (-> Number Number Bool))
(= (>= $a $b) (not (< $a $b)))
;; custom pair comparison fn -- whith bit of randomness for pairs that are equal in score and item content
(= (pairCompare ($item1 $score1) ($item2 $score2)) 
    (if (> $score1 $score2) 
        ($item1 $score1)
        ;; take care of pairs that could be equal by score as well as item content 
        ;; pick either one rather than favouring the first one as as in the case of ((A B) 0.9) and ((B A) 0.9)
        (if (and (== $score1 $score2) (isEqual $item1 $item2))
            (if (flip) ($item1 $score1) ($item2 $score2)) ;; making use of builtin (flip) function to toss the coin True or False
            ($item2 $score2))))      

;; check for equality of expressions -- to make up for ordering issues   
(= (isPairEqual ($item1 $val1) ($item2 $val2))
    (if (== $val1 $val2)
        (isEqual $item1 $item2)
        False))

(= (isEqual $a $b)
    (chain (subtraction-atom $a $b) $a-diff 
        (chain (subtraction-atom $b $a) $b-diff (and (== (size-atom $a) (size-atom $b)) (== $a-diff $b-diff)))))        

;; removeAtom -- removes a single atom (the first occurrunce) from a tuple  
(: removeAtom (-> Atom Expression Expression))                                
(= (removeAtom $atom $expr)
    (function 
        (eval (if-decons-expr $expr $head $tail
            (eval (if-equal $head $atom
                (return $tail)  ; Stop at first match
                (chain (removeAtom $atom $tail) $rest
                    (return (cons-atom $head $rest)))))
        ()))))

(: subtractionAtom (-> Expression Expression Expression))
(= (subtractionAtom $expr $b)
    (if-decons-expr $b $head $tail
        (chain (removeAtom $head $expr) $newexpr
            (subtractionAtom $newexpr $tail))
        $expr))

(= (shuffle $expr $acc)
    (if (== $expr ())
        $acc
        (chain (size-atom $expr) $len
            (chain (random-int 0 $len) $rnd-index
                (chain (index-atom $expr $rnd-index) $val
                (chain (cons-atom $val $acc) $new-acc
                    (chain (subtraction-atom $expr ($val)) $rem ;; if we are certain that a pattern is never repeated in the original expression
                        (shuffle $rem $new-acc))))))))


! (bind! -inf (py-atom ("float('-inf')")))
(= (foldl $expr $f $seed)
    (if-decons-expr $expr $h $t
        (let $new-seed ($f $seed $h)
            (foldl $t $f $new-seed))
        $seed))

! (bind! ε 0.000000000001)
(= (lg $x $y)
    (if (<= $y 0)
        (Error $y "Can't compute log of a -ve number")
        (let*
            (
                ($y-low -1000)
                ($y-high 1000)
                ($max-iter 1000)
                ($iter 0)
            )
            (log-loop $x $y $y-low $y-high ε $max-iter $iter)
        )
    )
)

(= (log-loop $x $y $y-low $y-high $epsilon $max-iter $iter)
    (if (or (> $iter $max-iter) (== $iter $max-iter))
        (/ (+ $y-low $y-high) 2)
        (let* 
            (
                ($y-mid (/ (+ $y-low $y-high) 2))
                ($e-mid (pow-math $x $y-mid))
                ($new-iter (+ 1 $iter))
            )
            (if (< (abs-math (- $e-mid $y)) $epsilon)
                $y-mid
                (if (> $e-mid $y)
                    (log-loop $x $y $y-low $y-mid $epsilon $max-iter $new-iter)
                    (log-loop $x $y $y-mid $y-high $epsilon $max-iter $new-iter)
                )))))
; ;; Testing pairMax
; ! (pairMax ((C D) 3) ((A B) 4))
; ! (pairMax ((C D) 3) ((A B) -inf))
      
;; Testing the foldl
; !(let $a (((3 2) 0) ((1 3) 0) ((0 2) 1) ((1 0) 1) ((0 1) 1) ((3 1) 0) ((0 3) 1) ((2 1) 0) ((2 3) 0) ((1 2) 0) ((2 0) 1) ((3 0) 1)) 
;         (foldl $a pairMax (() -inf)))  
        
; ;; built-in foldl-atom         
; !(let $a (((3 2) 0) ((1 3) 0) ((0 2) 1) ((1 0) 1) ((0 1) 1) ((3 1) 0) ((0 3) 1) ((2 1) 0) ((2 3) 0) ((1 2) 0) ((2 0) 1) ((3 0) 1)) 
;         (foldl-atom $a (() -inf) $acc $x (pairMax $acc $x)))

;; Testing the helper function

; ! (inputPairMiCalculator dataRows (Cons True (Cons True (Cons False (Cons False Nil)))) (0 1 2 3) (((0) 1) ((1) 0) ((2) 0) ((3) 0)))

! (stochasticMaxDependency 0 3 3 ttable mi ())

