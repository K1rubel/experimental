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
                    (if (== $h-s $h)
                        (Empty)
                        $h-s))) (unyque $rest $carry)))
        $acc))             

! (unyque (1 2 3 1 1 2 3 4 5) ())     

;; expression equality 