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

;; Overloading the above List.max with the built in >= comparison operator for operation on List of numbers
(: List.max (-> (List $a) $a))
(= (List.max (Cons $x $xs)) (List.max >= (Cons $x $xs)))

;; List.prepend .. adds an element at the beginnig of a list
(: List.prepend (-> $a (List $a) (List $a)))
(= (List.prepend $a $list) (Cons $a $list))



(: List.append (-> $a (List $a) (List $a)))
(= (List.append $val Nil) (Cons $val Nil))
(= (List.append $val (Cons $head $tail)) (Cons $head (List.append $val $tail)))

;; deletes the first occurence of an item in the list
(: (List.delete (-> $a (List $a) (List $a))))
(= (List.delete $a Nil) (Error Nil "empty list"))
(= (List.delete $a (Cons $x $xs))
    (if (== $x $a)
        $xs
        (Cons $x (List.delete $a $xs))))

(: List.appendList (-> (List $a) (List $a) (List $a)))
(= (List.appendList $a (Cons $x $xs))
    (if (== $xs Nil)
        (Cons $x $a)
        (Cons $x (List.appendList $a $xs))))        

(= (List.length Nil) 0)
(= (List.length (Cons $x $xs)) (+ 1 (List.length $xs)))


;; Convert a list to an expression.
(: List.listToExpr (-> (List $a) Expression))
(= (List.listToExpr Nil) ())
(= (List.listToExpr (Cons $x $xs)) (let $t (List.listToExpr $xs) (cons-atom $x $t)))

;; List.takeN -- takes the first N members of a list 
(: List.takeN (-> Number (List $a) (List $a)))
(= (List.takeN $n Nil) Nil)
(= (List.takeN $n (Cons $x $xs)) 
    (if (== $n 0)
        Nil
        (let $t (List.takeN (- $n 1) $xs) (Cons $x $t))))

! (List.takeN 3 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))        

;; Convert an expression to a list   e.g (A B C) -> (Cons A (Cons B (Cons C Nil)))
(= (exprToList $expr)
    (if (== $expr ())
        Nil
        (let ($head $tail) (decons-atom $expr)  (Cons $head (exprToList $tail)))))

(= (worstCscore)
    (mkCscore (pow-math 10 -308)  0 0.0 0.0 (pow-math 10 -308)))            