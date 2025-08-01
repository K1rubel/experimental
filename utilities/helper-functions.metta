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
;; if there are multiple items in $expr make sure to use sth that takes care of that -- like the subtractionAtom function below
                        (shuffle $rem $new-acc))))))))

(: removeAtom (-> Atom Expression Expression))                                
(= (removeAtom $atom $expr)
    (function 
        (eval (if-decons-expr $expr $head $tail
            (eval (if-equal $head $atom
                (return $tail)  ; Stop at first match
                (chain (removeAtom $atom $tail) $rest
                    (return (cons-atom $head $rest)))))
        ()))))

;; replicated the behaviour of subtraction-atom in MeTTa 
(: subtractionAtom (-> Expression Expression Expression))
(= (subtractionAtom $expr $b)
    (if-decons-expr $b $head $tail
        (chain (removeAtom $head $expr) $newexpr
            (subtractionAtom $newexpr $tail))
        $expr))


