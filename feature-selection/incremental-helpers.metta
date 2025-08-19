    ;; $k -- number of interactions
    (= (combinator $list $k)
        (if (== $k 1)
            (collapse (let $el (superpose $list) ($el)))
            (collapse (let $el (superpose $list) 
                (let $prev (combinator $list (- $k 1)) 
                    (let $p (superpose $prev) (union-atom $p ($el))))))))

; ! (combinator (0 1 2 3) 1)
; ! (combinator (0 1 2 3) 2)
; ! (combinator (0 1 2 3) 3)

; ;; unique redefined using custom functions
; (= (unyque $expr $acc)
;      (if (== $expr ())
;          $acc
;          (let* (
;              ($head (car-atom $expr))
;              ($tail (cdr-atom $expr))
;              ;($carry (cons-atom $head $acc))
;              ($carry (collapse (union (superpose $acc) $head)))
;              )
;              (if (== $tail ())
;                  $carry
;                  (let $tailWithoutHead (collapse
;                          (let $x (superpose $tail)
;                                  (if (== $head $x)
;                                      (empty)
;                                      $x
;                                  )
;                          ))
;                  (unyque $tailWithoutHead $carry )
;              )))))  
             
(= (unyque $expr $acc)
    (if-decons-expr $expr $h $t
        (let $carry (union-atom $acc ($h))
            (let $rest (collapse 
                (let $h-s (superpose $t)
                    (if (isExpEqual $h-s $h)
                        (Empty)
                        $h-s))) (unyque $rest $carry)))
        $acc))             

; ! (unyque (1 2 3 1 1 2 3 4 5) ())     

;; expression equality 
(= (isExpEqual $exp1 $exp2)
    (let $f (map-atom $exp2 $x (map-atom $exp1 $y (== $x $y)))
        (let $s (map-atom $exp1 $x (map-atom $exp2 $y (== $x $y))) (== $f $s))))
; ! (isExpEqual (0) (1)) ;; True -- not the result I am expecting
; ! (isExpEqual (0 1) (1 0))         
; ! (isExpEqual (1 2) (2 1))         
; ! (isExpEqual (1 2 3) (3 2 1))         
; ! (isExpEqual (1 2 1) (3 2 1))         
; !(=alpha ($e $x) ($f $y))
;; testing combinator and unique with isExpEqual
; ! (let $comb (combinator (0 1 2 3) 3)
;     (unyque $comb ()))

! (map-atom (1) $x (map-atom (0) $y (== $x $y)))                ;;  ((False))
! (map-atom (1 0) $x (map-atom (0 1) $y (== $x $y)))            ;;  ((False True) (True False))
! (map-atom (0 1) $x (map-atom (1 0) $y (== $x $y)))            ;;  ((False True) (True False))
! (map-atom (0 1 2) $x (map-atom (1 0 2) $y (== $x $y)))        ;;  ((False True False) (True False False) (False False True))
! (map-atom (0 2 1) $x (map-atom (1 0 2) $y (== $x $y)))        ;;  ((False True False) (False False True) (True False False))
! (map-atom (0 2 1) $x (map-atom (1 0 3) $y (== $x $y)))        ;;  ((False True False) (False False False) (True False False))

;; the next issue how to fold these tuple in an element by element basis