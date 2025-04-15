; ;; from a list take the first N values
; ;; Commented out to avoid collision of imported definitions
; (: List (-> $a Type))
; (: Nil (List $a))
; (: Cons (-> $a (List $a) (List $a)))

(: takeN (-> Number (List $a) (List $a)))
(= (takeN $n Nil) Nil)
(= (takeN $n (Cons $x $xs)) 
    (if (== $n 0)
        Nil
        (let $t (takeN (- $n 1) $xs) (Cons $x $t))))

;; defining List.max function with a comparator that compares non-numerical type values
(: List.max (-> (-> $a $a Bool) (List $a) $a))
(= (List.max $comparator Nil) Nil)
(= (List.max $comparator (Cons $x $xs))
    (if (== $xs Nil)
        $x
         (let (Cons $t $u) $xs
            (if ($comparator $x $t)
                (List.max $comparator (Cons $x $u))
                (List.max $comparator $xs)))))

;; Overloading the above List.max with the built in >= comparison operator
(: List.max (-> (List $a) $a))
; (= (List.max Nil) Nil)
(= (List.max (Cons $x $xs)) (List.max >= (Cons $x $xs)))

;; an equal to or grearter than comparator that is resopnsible for deconstructing numerical values from the type constructor and compare them 
;; ($ctor $x) ($ctor $y) -- (constructor value) pair                
(: >>= (-> $a $a Bool))
(= (>>= ($ctor $x) ($ctor $y))(>= $x $y))

;; testing List.max
; ! (List.max (Cons 1 (Cons 2 (Cons 5 (Cons 3 Nil)))))
; ! (List.max >>= (Cons (mkSize 1) (Cons (mkSize 10) (Cons (mkSize 2) (Cons (mkSize 3) Nil)))))

;; Sum of list elements
;;      1st for (List Number) -- followed by 
(: List.sum (-> (List Number) Number))
(= (List.sum Nil) Nil)
(= (List.sum (Cons $x $xs))
    (if (== $xs Nil)
        $x
        (let $c (List.sum $xs)
            (+ $x $c))))

;; List.sum function -- adds elements of a list of non-numeric type
(: List.sum (-> (-> $a $a $a) (List $a) $a))
(= (List.sum $adder Nil) Nil)
(= (List.sum $adder (Cons $x $xs))
    (if (== $xs Nil)
        $x
        (let $c (List.sum $adder $xs)
            ($adder $x $c))))

;; overloading the above function to work with list of numbers
(: List.sum (-> (List Number) Number))
(= (List.sum $list) (List.sum + $list))

! (List.sum (Cons 1 (Cons 2 Nil)))
;; defining addition operator for non-numerical types
;; adder
(: adder (-> $a $a $a))
(= (adder ($ctor $x) ($ctor $y)) ($ctor (+ $x $y)))

(: goal Type)
(: mkGoal (-> $a goal))

! (adder (mkGoal 4) (mkGoal 3))

! (+ 3 5)
! (get-type +)
; ! (+ (mkGoal 4) (mkGoal 3))

; ! (List.sum Nil)
; ! (List.sum (Cons 1 Nil))
; ! (List.sum (Cons 1 (Cons 3 Nil)))
; ! (List.sum adder (Cons (mkSize 1) (Cons (mkSize 3) Nil)))

;; map on lists 
;; commented out to avoid collision with  map definitions in other files
; (: map (-> (-> $a $b) (List $a) (List $b)))
; (= (map $f Nil) Nil)
; (= (map $f (Cons $x $xs)) (Cons ($f $x) (map $f $xs)))


;; List.sum` with some transfomration function
;; on list of numbers
(List.sum` (-> (-> Number Number) (List Number) Number))
(= (List.sum` $transformer Nil) Nil)
(= (List.sum` $transformer (Cons $x $xs))
    (if (== $xs Nil)
        ($transformer $x)
        (let $c (List.sum` $transformer $xs)
          
          (+ ($transformer $x) $c))))

;; on list of other types
(: List.sum` (-> $a $a) (-> $b $b $b) (List $a) $a)
(= (List.sum` $transformer $adder Nil) Nil)
(= (List.sum` $transformer $adder (Cons $x $xs))
    (if (== $xs Nil)
        ($transformer $x)
        (let $c (List.sum` $transformer $adder $xs)
            ($adder ($transformer $x) $c))))

;; tests
(: half (-> Number Number))
(= (half $x) (/ $x 2))

;; defining half for other types
(: half (-> $a $a))
(= (half ($ctor $val)) ($ctor (/ $val 2)))

;; test List.sum` on other types
(: Size Type)
(: mkSize (-> Number Size))

;; tranformations
(: identity (-> $a $a))
(= (identity $x) $x)


! (bind! COMPXY_TEMP 4)
! (bind! INV_TEMP (/ 100.0 COMPXY_TEMP))
;; wrapping the built-in ininf-math with custom function because the return type is not bool, it is number
;; using the type-cast function
(: isInf (-> Number Bool))
(= (isInf $x) (type-cast (isinf-math $x) Bool &self))

;;  a function to normalize the ScoreT values into normalized scores of Boltzman distribution

(: normalizeProbs (-> $a $a (List $a) (List $a)))

(= (normalizeProbs (mkScoreT $invTemp) (mkScoreT $best) Nil) Nil)
(= (normalizeProbs (mkScoreT $invTemp) (mkScoreT $best) (Cons (mkScoreT $x) $xs))
    (let*
        (
            ($new (if (isInf $x) (mkScoreT 0) 
                        (let $val (pow-math EXP (* (- $x $best) $invTemp)) (mkScoreT $val))))
            ($c (normalizeProbs (mkScoreT $invTemp) (mkScoreT $best) $xs))
        )
        (Cons $new $c)))

;; Insert by id
;; Using id strating at 0 
(: List.append (-> $a (List $a) (List $a)))
(= (List.append $a Nil) (Cons $a Nil))
(= (List.append $a (Cons $x $xs)) (if (== $xs Nil) (Cons $x (Cons $a $xs)) (Cons $x (List.append $a $xs))))

;; Get an element by index from a list
(: List.getByIdx (-> (List $a) Number $a))
(= (List.getByIdx Nil $idx) (Error (Index out of range)))
(= (List.getByIdx (Cons $head $tail) $idx) (if (== $idx 0 ) $head (List.getByIdx $tail (- $idx 1))) )