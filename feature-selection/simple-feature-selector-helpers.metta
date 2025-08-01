;; INFO: Uncomment for the use of MeTTaLog.
(: >= (-> Number Number Bool))
(= (>= $a $b) (not (< $a $b)))

;; random float [0 1] not [0 1)
! (bind! maxInt (pow-math 2 64))

(= (rndFloat) (/ (random-int 0 (+ maxInt 1)) maxInt))        
;; XXX the + 1 is to make sure that also can be produced
;; List.length
(: List.length (-> (List $a) Number))
(= (List.length $list)
    (unify $list Nil 0
        (unify $list (Cons $x $xs)
            (chain (List.length $xs) $res (+ 1 $res))
            (Error $list "UnknownError"))))

;; get index of a feature name from list of features
(= (List.getIndex $el $list)
    (unify $list Nil (Error $el "Not found in list")
        (unify $list (Cons $f $fs)
            (if (== $el $f) 0 (+ 1 (List.getIndex $el $fs))) ())))  ;; XXX what to do inplace of () for unify ????      

(= (List.at $i $list)
    (unify $list Nil (Error $list "Empty list")
        (unify $list (Cons $el $els) 
            (if (== $i 0) $el (List.at (- $i 1) $els)))))
;;             
;; return tuple of unique values and their count
;; this one is assuming the list of values have been returned contains the row information. 
(= (List.uniqueValuesCount $list $acc)
    (unify $list Nil $acc
        (unify $list (Cons $x $xs)
            (if (patternExists ($x $c) $acc)
                (chain (updateCount $x $acc) $count-updated
                    (List.uniqueValuesCount $xs $count-updated))
                (chain (union-atom $acc (($x 1))) $new-tuple-added
                    (List.uniqueValuesCount $xs $new-tuple-added))))))

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
;; Table.pop        -- gets and removes a column from the current ttable structure
;;                  -- returns the remaining table and the culumn asked for
; (= (Table.pop $i $rows)
;     (unify $rows Nil Nil
;         (unify $rows (Cons (Cons $d $ds) $rest)  ;; $d and $ds for data and rest of data
;             (if (== $i 0)
;                 (Cons $ds (Table.pop $i $rest))
;                 (Cons (Cons $d (List.pop $i $ds)) (Table.pop (- $i 1) $rest)))))))

;; removes the first column from table
(: Table.pop (-> (List (List $a)) (List (List $a))))
(= (Table.pop $rows)
    (unify $rows Nil Nil
        (unify $rows (Cons (Cons $d $ds) $rest)
            (Cons $ds (Table.pop $rest)))))


(= (List.pop $i $list)
    (unify $list Nil Nil
        (unify $list (Cons $x $xs)
            (if (== $i 0)
                $xs
                (Cons $x (List.pop (- $i 1) $xs)))))) 
                
; ;; Testing List.pop
; ! (List.pop 0 (Cons 0 (Cons 1 (Cons 2 Nil))))   ;; (Cons 1 (Cons 2 Nil))]
; ! (List.pop 1 (Cons 0 (Cons 1 (Cons 2 Nil))))   ;; (Cons 0 (Cons 2 Nil))]

;;;;;;;;;;;;;;
;; Transpose;;
;;;;;;;;;;;;;;
(: Table._transposeHelper (-> (List Number) (List (List $a)) (List (List $a))))
(= (Table._transposeHelper $indices $table)
    (unify $indices 
        Nil Nil
        (unify $indices (Cons $i $rest)
            (Cons (Table.getColumn $i $table)
                  (Table._transposeHelper $rest $table)) ())))

(: Table.transpose (-> (List (List $a)) (List (List $a))))
(= (Table.transpose $table)
    (let $numCols (List.length (List.head $table))
        (let $indices (List.range 0 $numCols)
            (Table._transposeHelper $indices $table))))
;;;;;;;;;;;;;;
;; Transpose;;
;;;;;;;;;;;;;;

(: List.head (-> (List $a) $a))
(= (List.head $list)
    (unify $list 
        Nil (Error "Empty list has no head")
        (unify $list (Cons $h $t) $h ())))

; ! (List.head (Cons 1 (Cons 2 Nil)))   ;; 1      
            
; (: List.range (-> Number Number (List Number))) ;; inclusive start, exclusive end
(= (List.range $start $end)
    (if (>= $start $end)
        Nil
        (chain (List.range (+ 1 $start) $end) $res (Cons $start $res))))

; ! (List.range 0 10) ;; 
;; check for a pattern in tuple of tuples                
(= (patternExists $pat $collection)
    (let $a (collapse (chain (superpose $collection) $s
        (unify $s $pat True False))) (foldl-atom $a False $acc $i (or $i $acc))))        

;; replace value and count pair in collection with one higher count pair        
(= (updateCount $val $collection)
    (collapse (chain (superpose $collection) $s 
                (unify $s ($val $count) ($val (+ 1 $count)) $s)))) 

(= (appendTuple $acc $t)
    (if (== $acc ())
        (($t))
        (union-atom $acc ($t))))                
; ! (updateCount True ((True 1) (False 3) (Nothing 2) (Sth 5))) ;; ((True 2) (False 3) (Nothing 2) (Sth 5))
; ! (updateCount False ((True 1) (False 3) (Nothing 2) (Sth 5))) ;; ((True 1) (False 4) (Nothing 2) (Sth 5))
; ! (updateCount Nothing ((True 1) (False 3) (Nothing 2) (Sth 5))) ;; ((True 1) (False 3) (Nothing 3) (Sth 5))
; ! (updateCount Sth ((True 1) (False 3) (Nothing 2) (Sth 5))) ;; ((True 1) (False 3) (Nothing 2) (Sth 6))


;; Testing List.uniqueValuesCount
; ! (List.uniqueValuesCount Nil ()) ;; ()
; ! (List.uniqueValuesCount (Cons True Nil) ()) ;; (True 1)
; ! (List.uniqueValuesCount (Cons True (Cons False Nil)) ()) ;; ((True 1) (False 1))
; ! (List.uniqueValuesCount (Cons True (Cons False (Cons True Nil))) ()) ;; ((True 2) (False 1))
; ! (List.uniqueValuesCount (Cons True (Cons False (Cons True (Cons True (Cons True Nil))))) ()) ;; ((True 4) (False 1))
; ! (List.uniqueValuesCount (Cons True (Cons False (Cons True (Cons True (Cons True (Cons False Nil)))))) ()) ;; ((True 4) (False 2))


; ! (List.uniqueValuesCount (Cons True (Cons True)))
; ! (let $acc ((True 1) ) (let $s (superpose $acc) (unify (True $x) $s True False)))        
; ! (let $acc ((True 1) (False 2)) (let $s (superpose $acc) (unify (True $x) $s True False)))   
; ! (patternExists (True $a) ())     
; ! (union-atom (1 2) (3))    
;; custom log function log'

(= (sum $numTuple)
    (if-decons-expr $numTuple $h $t
        (+ $h (sum $t))
        0))

;; python binding for rounding
; ! (bind! round (py-atom round))
; ! (round 4.423564 3)   
; ! (sum ())
; ! (sum (1))
; ! (sum (1 2 3)) ;; 6
; ! (sum (1 2 3 4)) ;; 10
; ! (sum (1 2 3 4 5)) ;; 15
; ! (sum (1 2 3 4 5 6)) ;; 21

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

()                
;; unique values of any feature in a table
;; a preceding procedure is assumed to provide the row take from the ttable
;; the current behaviour of union-atom in mettalog can be directly used to extract unique items from list 
;; XXX meaning if the behaviour changes in next iterations of mettalog -- code fails
(= (uniqueValues $row)
    (unify $row Nil ()
        (unify $row (Cons $d $ds) 
            (chain (uniqueValues $ds) $res
                (union-atom ($d) $res)) ())))


;; sorting pairs 
;; $op -- comparator $pairTuple -- tuple of pairs
;; $count -- sort count -- partial sort
;; $acc -- the accumulator
(= (sortPairs $op $pairTuple $count $acc)
    (if (or (<= $count 0) (== $pairTuple ()))
        (union-atom $acc $pairTuple)
        ;; find max pair from the tuple of pairs
        ;; use of union assumes the pairs are non repeating -- same score is possible but always different label
        (chain (foldl-atom $pairTuple (-inf $label) $ac $pair ($op $ac $pair)) $max-pair
        (chain (union-atom $acc ($max-pair)) $new-acc
        (chain (collapse (chain (superpose $pairTuple) $el (if (== $el $max-pair) (Empty) $el))) $rest
        (sortPairs $op $rest (- $count 1) $new-acc))))))  ;; recursive call

; ! (union-atom ((2 B) (1 A)) ((0.5 C) (0.25 D)))
; ! (union-atom () ((1 2) (2 1)))
; ! (> "B" "A") ;; works in mettalog
; ! (>= "B" "C") ;; works in mettalog
;; insertPair 
;; ($iv $new-i) -- piar of score value and feature index  
;; $op -- comparison operator
;; $list -- tuple of item value-label pairs 
;; XXX : make sure to use strict comparators > as the comparator
(= (insertPair $op ($mi $new-i) $list)
    (if-decons-expr $list $h $t
        (unify ($mi-old $i) $h
            (if ($op $mi $mi-old)
                (cons-atom ($mi $new-i) $list)
                (if (== $mi $mi-old)
                    (if (<= $new-i $i) ;; since we are 
                        (cons-atom ($mi $new-i) $list)
                        (chain (insertPair $op ($mi $new-i) $t) $res (cons-atom $h $res)))
                    (chain (insertPair $op ($mi $new-i) $t) $res (cons-atom $h $res))))
        ())
    (($mi $new-i))))

; ! (insertPair > (2 0) ((4 0) (1 3)))

; (= (str>= $str1 $str2)
;     )
; ! (bind! str> (py-atom ">"))    
; ! (bind! split (py-atom list))
; ! (let $a (split "AB") (get-type $a))

; ! (insertPair > (1 A) ())     ;; (1 A)
; ! (insertPair > (2 C) ((2 B) (0 D)))     ;; ((2 B) (2 C) (0 D)) -- ordered lexicologically
; ! (insertPair > (1 B) ((2 D) (2 D) (1.5 A) (1 A) (1 C)))    ;; ((2 D) (2 D) (1.5 A) (1 A) (1 B) (1 C))

;; need to be corrected for calculating maximum

;; find maximum in list of pairs
;; compair pair
(: pairMax (-> (Number Symbol) (Number Symbol) (Number Symbol)))
;; XXX notice the use of => for comparison -- as per current mettlog interpreter implementation
(= (pairMax ($val1 $label1) ($val2 $label2)) (if (=> $val1 $val2) ($val1 $label1) ($val2 $label2)))
; ! (pairMax (1 A) (2 B)) ;; (2 B)
; ! (pairMax (3 A) (2 B)) ;; (3 A)

;; appy this with fold atom to find the max from tuple of pairs

! (bind! -inf (py-atom "float('-inf')"))
; ! -inf
; ! (=> -5 -inf)
;; eg run
; ! (foldl-atom ((1 A) (2 B) (3 C) (3 D) (4 D) (5 f) (6 h)) (-inf $label) $acc $pair (pairMax $acc $pair))
; ! (foldl-atom ((1 A)) (-inf $label) $acc $pair (pairMax $acc $pair))

;; the code below return superposed outputs when there are two values with different labels
; ! (chain ((1 A) (2 B) (3 C) (3 D) (4 D) (5 f) (5 h)) $pairTuple
;     (chain (collapse (chain (superpose $pairTuple) $el
;         (unify $el ($val $label)
;             $val
;             ()))) $tuple (chain (max-atom $tuple) $max 
;                             (chain (superpose $pairTuple) $el (unify $el ($max $label) $el (Empty))))))

; ! (let $pairTuple ((1 A) (2 B) (3 C) (3 D) (4 D) (5 f)) 
;     (let $tuple (collapse (let $el (superpose $pairTuple)
;         (unify $el ($val $lable)
;             $val
;             ()))) (max-atom $tuple)))

; ! (sortPairs pairMax () 2 ()) ;; ()
; ! (sortPairs pairMax ((2 A)) 2 ()) ;; ((2 A))
; ! (sortPairs pairMax ((2 A) (3 B)) 2 ()) ;; ((3 B) (2 A))
; ! (sortPairs pairMax ((2 A) (3 B) (4 C)) 2 ()) ;; ((4 C) (3 B) (2 A))
; ! (sortPairs pairMax ((2 A) (3 B) (4 C) (1.5 C) (1.2 C) (9 A)) 2 ()) ;; ((9 A) (4 C) (2 A) (3 B) (1.5 C) (1.2 C))
; ! (sortPairs pairMax ((2 A) (3 B) (4 C)) 3 ()) ;; ((4 C) (3 B) (2 A)) 
            
;; take N values from tuple
(: takeN (-> Number Expression Expression))
(= (takeN $n $expr) 
    (if (== $n 0)
        ()
        (if-decons-expr $expr $h $t
            (chain (takeN (- $n 1) $t) $res
                (cons-atom $h $res))
            ())))
;; testing takeN        

; ! (takeN 0 (1 2 3)) ;; ()
; ! (takeN 1 (1 2 3)) ;; (1)
; ! (takeN 2 (1 2 3)) ;; (1 2)

;; From a tuple (Pair) return the second element
(: second (-> ($a $b) $b))
(= (second ($a $b)) $b)
;; exponentialSelection 	    -- exponential selectio for simple feature selector
;;          $mean                   -- mean of num desired for the exponential dist
;;          $numDesired             -- number of features to be selected
;;          $scoreLableTuple        -- tuple of MI scores and corresponding labels -- this might change into index values
;;          $xn                     -- factor controlling what gets selected -- starts as 1
;;          $acc                    -- accumulator for selected features

(= (exponentialSelection $mean $numDesired $scoreLabelTuple $xn $acc)
    (if (== $numDesired 0)
        $acc
        (trace! ($rndFloat $xn) (if-decons-expr $scoreLabelTuple $h $t
            (chain (rndFloat) $rndFloat
            (if (< $rndFloat $xn)
                (chain (union-atom $acc ($h)) $new-acc
                    (exponentialSelection $mean (- $numDesired 1) $t (* $xn $mean) $new-acc))
                (exponentialSelection $mean $numDesired $t (* $xn $mean) $acc))) ;; some adjustment needed here to make sure numDesired amount is returned check if numDesired is equal to what is left. if so append all to the acc to make sure  
        $acc))))
