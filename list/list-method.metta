(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

(: List.takeN (-> Number (List $a) (List $a)))
(= (List.takeN $n Nil) Nil)
(= (List.takeN $n (Cons $x $xs)) 
    (if (== $n 0)
        Nil
        (let $t (List.takeN (- $n 1) $xs) (Cons $x $t))))

;; List.takeNFrom -- takes N members starting from position S
(: List.takeNFrom (-> Number Number (List $a) (List $a)))
(= (List.takeNFrom $start $n Nil) Nil)
(= (List.takeNFrom $start $n (Cons $x $xs))
    (if (== $n 0)
        Nil
        (if (== $start 0)
            (List.takeN $n (Cons $x $xs))
            (List.takeNFrom (- $start 1) $n $xs))))

        ; (let $t (List.takeNFrom $start (- $n 1) $xs)
        ;   (Cons $x $t))))

;; Recursive case: still moving toward the start index
(= (List.takeNFrom $start $n (Cons _ $xs))
    (if (== $start 0)
        (List.takeNFrom 0 $n (Cons _ $xs)) ; Shouldn't happen, but safe fallback
        (List.takeNFrom (- $start 1) $n $xs)))  

; List.takeNFrom test cases
! (assertEqual (List.takeNFrom 2 3 (Cons 0 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 5 Nil)))))))
               (Cons 2 (Cons 3 (Cons 4 Nil))))
! (assertEqual (List.takeNFrom 0 3 (Cons 0 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 5 Nil)))))))
               (Cons 0 (Cons 1 (Cons 2 Nil))))
! (assertEqual (List.takeNFrom 3 2 (Cons 0 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil))))))
               (Cons 3 (Cons 4 Nil)))
! (assertEqual (List.takeNFrom 4 3 (Cons 0 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil))))))
               (Cons 4 Nil))
! (assertEqual (List.takeNFrom 10 2 (Cons 0 (Cons 1 (Cons 2 (Cons 3 Nil)))))
               Nil)
! (assertEqual (List.takeNFrom 2 0 (Cons 0 (Cons 1 (Cons 2 (Cons 3 Nil)))))
               Nil)
! (assertEqual (List.takeNFrom 0 2 Nil)
               Nil)
! (assertEqual (List.takeNFrom 4 1 (Cons 0 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil))))))
               (Cons 4 Nil))
! (assertEqual (List.takeNFrom 2 10 (Cons 0 (Cons 1 (Cons 2 (Cons 3 Nil)))))
               (Cons 2 (Cons 3 Nil)))
! (assertEqual (List.takeNFrom 2 10 (Cons 0 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil))))))
               (Cons 2 (Cons 3 (Cons 4 Nil))))

