(@doc List.removeByIdx 
    (@desc "List.removeByIdx deletes an item in a list (second argument) using index (first argument) values ")
    (@params (
        (@param "$index:- index value")
        (@param "$list:- list data as (Cons $x $xs) format or Nil if empty")))
    (@return "List"))

; (: List.removeByIdx (-> Number (List $a) (List $a)))
; (= (List.removeByIdx $index $list)
;     (function (eval (if-equal $list Nil
;                         (return (Error $list EmptyList))
;                         (unify $list (Cons $x $xs)
;                             (eval (if-equal $index 0
;                                 (return $xs)
;                                 (chain (List.removeByIdx (- $index 1) $xs) $result
;                                     (return (Cons $x $result)))))
;                             (return (Error $list IncompatibleListType)))))))

;; alternative defintion of the same function

; (: List.removeByIdx (-> Number (List $a) (List $a)))
; (= (List.removeByIdx $index Nil) Nil)
; (= (List.removeByIdx $index (Cons $head $tail))
;    (if (< $index 0) (Cons $head $tail)
;        (if (== $index 0) $tail
;            (Cons $head (List.removeByIdx (- $index 1) $tail)))))

; ! (filter-atom (1 2 3 4 5 6) $x (eval (> $x 2)))
; ! (List.removeByIdx 0 Nil)
; ! (List.removeByIdx 0 (Cons 1 Nil))
; ! (List.removeByIdx 1 (Cons 1 (Cons 2 Nil)))
; ! (List.removeByIdx 2 (Cons 1 (Cons 2 (Cons 3 Nil))))
; ! (List.removeByIdx 3 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))
; ! (List.removeByIdx 20 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 5 (Cons 6 (Cons 7 (Cons 8 (Cons 9 (Cons 10 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 Nil))))))))))))))))))))))))))))))))))))))))))))

;; to see the documentation of the functions
; ! (get-doc List.removeByIdx)

;; checking the if-decons-expr stdlib function
; ! (if-decons-expr (1) $h $t $t Emmpty)

(: foldl (-> Expression Atom (-> $a $a $a) Atom))
(= (foldl $expr $i $op)
    (if-decons-expr $expr $h $t 
        (chain ($op $i $h) $c
            (foldl $t $c $op))
        $i))


; (: foldl (-> (-> $a $b $d) $b $c $d))
; (= (foldl $f $acc $tuple)
;    (if (== $tuple ())
;        $acc
;        (let ($next $t) ((car-atom $tuple) (cdr-atom $tuple)) (foldl $f ($f $next $acc) $t))))

; ! (foldl (1 2 3 4 5 6 7 8 9 10 11 12) 0 +)
; ! (foldl + 0 (1 2 3 4 5 6 7 8 9 10 11 12))
; ! (foldl-atom (1 2 3 4 5 6 7 8 9 10 11 12) 0 $a $b (+ $a $b))

(: foldr (-> Expression Atom (-> $a $a $a) Atom))
(= (foldr $expr $i $op)
    (if-decons-expr $expr $h $t
        (chain (foldr $t $i $op) $c
            ($op $h $c))
        $i))
(: foldr (-> (-> $a $b $b) $b $c $d))
(= (foldr $f $i $xs)
   (if (== $xs ())
       $i
       (let* (($h (car-atom $xs))
              ($t (cdr-atom $xs))
              ($ft (foldr $f $i $t)))
         ($f $h $ft))))

! (foldr (1 2 3 4 5 6 7 8 9 10 11 12) 0 +)
; ! (foldr + 0 (1 2 3 4 5 6 7 8 9 10 11 12))

;; an alternative implementation of map
(: map (-> Expression (-> $a $b) Expression))
; (= (map $expr $f)
;     (if-decons-expr $expr $h $t
;         (chain ($f $h) $h-mapped
;             (chain (map $t $f) $t-mapped
;                 (chain (cons- atom $h-mapped $t-mapped) $r $r)))
;         ()))

(= (map $expr $f)
    (function 
        (eval (if-decons-expr $expr $h $t
                (chain ($f $h) $h-mapped
                    (chain (map $t $f) $t-mapped
                        (chain (cons- atom $h-mapped $t-mapped) $result ;; to be fixed
                            (return $result))))
                (return ())))))

    ; (if-decons-expr $expr $h $t
    ;     (chain ($f $h) $h-mapped
    ;         (chain (map $t $f) $t-mapped
    ;             (cons- atom $h-mapped $t-mapped)))
    ;             ()))
        
;; Testing map
(= (add1 $x) (+ 1 $x))
! (map (1 2 3 4) add1)        
! (map (1) add1)        