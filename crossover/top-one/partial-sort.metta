; ! (register-module! ../../experimental)
; ! (import! &self experimental:merge-deme:sort-demes:sort_demes)
; ! (import! &self experimental:list:type)
; ! (import! &self experimental:crossover:helpers)

;; checking for the above import statement
; ! (get-type (mkInst (Cons 1 Nil)))

;; List.partialSort -- Partially sorts list of numbers upto and leaves the rest unSorted
;; takes a comparator function

(: List.partialSort (-> (-> $a $a Bool) (List $a) Number (List $a) (List $a)))
; (= (List.partialSort (Cons $x $xs) $n $acc)
;     (let* (($max (List.max (Cons $x $xs)))
;             ($unsortedList (List.delete $max (Cons $x $xs)))
;             ($sortedList (List.append $max $acc)))
                
;                 (if (== (- $n 1) 0)
;                     (List.appendList $unsortedList $sortedList)
;                     (List.partialSort $unsortedList (- $n 1) $sortedList))))

(= (List.partialSort $comparator (Cons $x $xs) $n $acc)
    (let* (($max (List.max $comparator (Cons $x $xs)))
            ($unsortedList (List.delete $max (Cons $x $xs)))
            ($sortedList (List.append $max $acc)))
                
                (if (== (- $n 1) 0)
                    (List.appendList $unsortedList $sortedList)
                    (List.partialSort $comparator $unsortedList (- $n 1) $sortedList))))

; ! (List.partialSort (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 7 (Cons 5 Nil)))))) 2 Nil)

; ! (get-type (mkSInstSet (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) Nil)))
; ! (get-type (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5)))

;; PartialSort for Scored Instance set

;; But first a greater than or equal comparison operator for composite score
(: cScore>= (-> Cscore Cscore Bool)) 
(= (cScore>= $cs1 $cs2)
    (let ($pl $pr $cl $cr) ((getPenScore $cs1) (getPenScore $cs2) (getComp $cs1) (getComp $cs2))
        (if (type-cast (isnan-math $pl) Bool &self)
            False
            (or (> $pl $pr) (and (== $pl $pr) (< $cl $cr))))))

; ! (bind! nan (py-atom "float('nan')"))            
; ! (cScore>= (mkCscore 1 2 3 4 nan) (mkCscore 0.5 2 3 4 2))   

; ;; defining List.max function with a comparator that compares non-numerical type values
; (: List.max (-> (-> $a $a Bool) (List $a) $a))
; (= (List.max $comparator Nil) Nil)
; (= (List.max $comparator (Cons $x $xs))
;     (if (== $xs Nil)
;         $x
;          (let (Cons $t $u) $xs
;             (if ($comparator $x $t)
;                 (List.max $comparator (Cons $x $u))
;                 (List.max $comparator $xs)))))

; ;; Overloading the above List.max with the built in >= comparison operator for operation on List of numbers
; (: List.max (-> (List $a) $a))
; (= (List.max (Cons $x $xs)) (List.max >= (Cons $x $xs)))

;; finding max in scored instance set
; (: List.max (-> (-> (ScoredInstance $score) (ScoredInstance $score) Bool) (List (ScoredInstance $score)) (ScoredInstance $score)))
; (= (List.max $comparator (Cons $x $xs))
;     (if (== $xs Nil)
;       $x
;       (let (Cons $t $u) $xs
;           (if ($comparator $score1 $score2)
;               (List.max $comparator (Cons $x $u))
;               (List.max $comparator $xs)))))

;; Instance comparator
(: instance>= (-> (ScoredInstance $score) (ScoredInstance $score) Bool))
(= (instance>= (mkSInst (mkPair $inst1 $score1)) (mkSInst (mkPair $inst2 $score2)))
    (cScore>= $score1 $score2))

; ! (instance>= (mkSInst (mkPair (mkInst Nil) (mkCscore 1 2 3 4 0.05))) (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 0.5))))
; ! (get-type (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore 1 2 3 4 5))) Nil))     

; ! (List.max instance>= (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore 1 2 3 4 5))) 
;       (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 0.5))) (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 15))) Nil))))

; ! (List.partialSort instance>= (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore 1 2 3 4 5))) 
;       (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 0.5))) 
;         (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 15))) Nil))) 3 Nil)

; ! (List.partialSort instance>= (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore 1 2 3 4 0.5))) 
;     (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) 
;       (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 15))) Nil))) 1 Nil)

; ! (let $a (List.listToExpr (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore 1 2 3 4 0.5))) 
;     (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) 
;       (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 15))) Nil))))
;   (get-type $a))


; ! (assertEqual (List.partialSort instance>=
;                                 (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -3.0 2 1.0 0.5 -4.5)))
;                                     (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -1.0 3 1.0 0.5 -2.5)))
;                                         (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -2.0 1 1.0 0.5 -3.5))) 
;                                             (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -2.0 1 1.0 0.5 -5))) Nil)))) 2 Nil)
;             (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -1.0 3 1.0 0.5 -2.5)))
;                 (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -2.0 1 1.0 0.5 -3.5)))
;                     (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -3.0 2 1.0 0.5 -4.5))) 
;                       (Cons (mkSInst (mkPair (mkInst Nil) (mkCscore -2.0 1 1.0 0.5 -5))) Nil)))))   

; ! (List.partialSort instance>= (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) (Cons (mkSInst (mkPair (mkInst (Cons 3 Nil)) (mkCscore 1 2 3 4 3))) (Cons (mkSInst (mkPair (mkInst (Cons 2 Nil)) (mkCscore 1 2 3 4 4))) (Cons (mkSInst (mkPair (mkInst (Cons 4 Nil)) (mkCscore 1 2 3 4 2))) (Cons (mkSInst (mkPair (mkInst (Cons 5 Nil)) (mkCscore 1 2 3 4 1))) Nil))))) 3 Nil)