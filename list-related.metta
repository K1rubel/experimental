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

! (takeN 5 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))