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

;; reverse a list

(= (List.reverse Nil $acc) Nil)
(= (List.reverse (Cons $x $xs) $acc)
    (if (== $xs Nil)
        (List.prepend $x $acc)
        (let $c (List.prepend $x $acc)
            (List.reverse $xs $c))))

; (= (List.prepend $x Nil) (Cons $x Nil))
(= (List.prepend $x $list) (Cons $x $list))

; ! (List.prepend 3 Nil)
! (List.reverse (Cons 1 (Cons 2 (Cons 3 (Cons 7 Nil)))) Nil)


(Cons 1 (Cons 2 (Cons 3 (Cons 7 Nil))))

(: List.append (-> $a (List $b) (List $b)))
; (: List.append (-> Expression (List Expression) (List Expression)))

(= (List.append $a Nil) (Cons $a Nil))
(= (List.append $a (Cons $x $xs))
    (if (== $xs Nil)
        (Cons $x (Cons $a $xs))
        (Cons $x (List.append $a $xs))))

! (List.append (1 0) Nil)
! (List.append (1 0) (Cons (3 4) (Cons (1 3) Nil)))
; ! (List.append 1 (Cons (3 4) (Cons (1 3) Nil)))


;; reimplementing partial sort 
;; staring with (List Number) type
;; first helper max function
; (= (List.max $op $list)
;     (unify $list Nil
;         Nil
;         (unify $list (Cons $x $xs)
;             (if (== $xs Nil)
;                 $x
;                 (unify $xs (Cons $t $u)
;                     (if ($op $x $t)
;                         (List.max $op (Cons $x $u))
;                         (List.max $op $xs))
;                     ()))
;                 ())))
;; How can the above be more optimized
;; the implementation below appears to be a more optimized vesion of the above
(= (List.max $op $list)
    (unify $list Nil
        Nil
        (unify $list (Cons $x Nil)
            $x
            (unify $list (Cons $x (Cons $xs $xxs))
                (if ($op $x $xs)
                    (List.max $op (Cons $x $xxs))
                    (List.max $op (Cons $xs $xxs)))
                ()))))
;; INFO: Uncomment for the use of MeTTaLog.
(: >= (-> Number Number Bool))
(= (>= $a $b) (or (== $a $b) (> $a $b)))

; ;; Testing List.max
; ! (List.max >= Nil)  ;; Nil
; ! (List.max >= (Cons 1 Nil))  ;; 1
; ! (List.max >= (Cons 1 (Cons 3 Nil)))  ;; 3

; ! (List.max >= (Cons 1 (Cons 3 (Cons 40 (Cons -10 Nil)))))  ;; 40
; ! (List.max >= (Cons -10 (Cons -3 (Cons -40 (Cons -10 Nil)))))  ;; 40
; ! (List.max >= (Cons -10 (Cons -3 (Cons -40 (Cons -10 (Cons 2 (Cons 3 (Cons 4 Nil))))))))  ;; 4

(= (List.pSort $list $n)
    )
! (get-type A)    