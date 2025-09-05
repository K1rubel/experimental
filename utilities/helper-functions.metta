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

;; check for equality of expressions -- to make up for ordering issues     
;; this means (A B) and (A B) are equal -- doesn't work for nested tuples
(= (isEqual $a $b)
    (chain (subtraction-atom $a $b) $a-diff 
        (chain (subtraction-atom $b $a) $b-diff (and (== (size-atom $a) (size-atom $b)) (== $a-diff $b-diff)))))

;; sorting tuple of pairs in the form of (item numVal) 
(= (sortPairs $op $pairTuple $count $acc)
    (if (or (<= $count 0) (== $pairTuple ()))
        (union-atom $acc $pairTuple)
        ;; find max pair from the tuple of pairs    
        ;; use of union assumes the pairs are non repeating -- same score is possible but always different label
        (chain (foldl-atom $pairTuple ((A B) -inf) $ac $pair ($op $ac $pair)) $max-pair
        (chain (union-atom $acc ($max-pair)) $new-acc
        (chain (collapse (chain (superpose $pairTuple) $el (if (== $el $max-pair) (Empty) $el))) $rest
        (sortPairs $op $rest (- $count 1) $new-acc))))))  ;; recursive call

;; binding inf value in mettalog for pair comparison
; ! (bind! -inf (py-atom ("float('-inf')")))
(= (pairMax ($item1 $val1) ($item2 $val2)) (if (=> $val1 $val2) ($item1 $val1) ($item2 $val2)))

; ! (pairMax (A 2) (B 3))
;; Testing the above function
; ! (sortPairs pairMax ((A 2) (B 3) (C 2.3) (D 4) (D 7)) 3 ())

;; foldl function

(= (foldl $expr $f $seed)
    (if-decons-expr $expr $h $t
        (chain ($f $seed $h) $new-seed 
            (foldl $t $f $new-seed))
        $seed))

;; implementation of natural log based on series definition for ln(x) = 2 ⨊ 1⁄(2n+1)*((x-1)/ (x+1))˄ (2n+1)
(= (ln $x) 
    (if (< $x 2)
        (chain (/ (- $x 1) (+ $x 1)) $const
            (ln-helper $x $const 0 0))
        (chain (/ $x 1.9999) $rem
            (chain (ln 1.9999) $base (+ $base (ln $rem)))))) ;; applying ln ab = ln a + ln b

;; helper function for ln -- do the sum            
(= (ln-helper $x $const $n $acc)
    (chain (+ (* 2 $n) 1) $factor                    ;;  (2n + 1)
        (chain (* (/ (pow-math $const $factor) $factor) 2) $current-term
            (if (> (abs-math $current-term) 0.0000001)
                (ln-helper $x $const (+ $n 1) (+ $acc $current-term))
                $acc)))) 

(= (randomChoice $tuple)
    (chain (size-atom $tuple) $size-atom
        (chain (random-int 0 $size-atom) $int (index-atom $tuple $int))))
        
 
; a reverse functionality without accumulator 
; this one is done with metta -- not mettalog -- most, if not all, of the above have been written for mettalog 
(= (reverse $expr)
    (if-decons-expr $expr $h $t
        (let $rest (reverse $t)
            (union-atom $rest ($h)))
        ()))


; ;; the problem with the above implementation is that -- in mettalog union-atom removes redundant atoms while that is not the pupose of reverse here
; ;; reimplement uninon-atom
; ; (= (uninonAtom $x $y)
; ;     (if-decons-expr $x $h $t
; ;         (let $next (cons-atom $))
; ;     $y))
; (= (reverse $expr)
;     (if-decons-expr $expr $h $t
;         (if (== $t ())
;             (cons-atom $h $t)
;             ())
;         ()))
