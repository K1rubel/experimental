;; ! mettalog tested
(= (range $l $step $u) ;; generate from $l to $u (excluding) in $step steps 
    (if (== $step 0)
        (Error $step "Step value of 0 not allowed!!")
        (if (=> $l $u)
            ()
            (chain (range (+ $l $step) $step $u) $res
                (cons-atom $l $res)))))
;; ! mettlog tested
(= (shuffle $expr $acc)
    (if (== $expr ())
        $acc
        (chain (size-atom $expr) $len
            (chain (random-int 0 $len) $rnd-index
                (chain (index-atom $expr $rnd-index) $val
                (chain (cons-atom $val $acc) $new-acc
                    (chain (subtraction-atom $expr ($val)) $rem ;; if we are certain that a pattern is never repeated in the original expression
                        (shuffle $rem $new-acc))))))))

