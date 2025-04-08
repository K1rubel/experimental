;; from a list take the first N values
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

(Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))) -> take the top 2 (Cons 1 (Cons 2 Nil))

(: takeN (-> Number (List $a) (List $a)))
(= (takeN $n Nil) Nil)
(= (takeN $n (Cons $x $xs)) 
    (if (== $n 0)
        Nil
        (let $t (takeN (- $n 1) $xs) (Cons $x $t))))

;; finding maximum from list numbers

(: listMax (-> (List $a) $a))
(= (listMax Nil) Nil)
(= (listMax (Cons $x $xs))
    (if (== $xs Nil)
        $x
        (let (Cons $t $u) $xs 
            (if (>= $x $t)
                (listMax (Cons $x $u))
                (listMax $xs)))))

;; overloading the above function with another type definition that compares other types 
(: listMax (-> (-> $a $a Bool) (List $a) $a))
(= (listMax $comparator Nil) Nil)
(= (listMax $comparator (Cons $x $xs))
    (if (== $xs Nil)
        $x
         (let (Cons $t $u) $xs
            (if ($comparator $x $t)
                (listMax $comparator (Cons $x $u))
                (listMax $comparator $xs)))))

;; an equal to or grearter than comparator that is resopnsible for deconstructing numerical values from the type constructor and compare them 
;; ($ctor $x) ($ctor $y) -- (constructor value) pair                
(: >>= (-> $a $a Bool))
(= (>>= ($ctor $x) ($ctor $y))(>= $x $y))
