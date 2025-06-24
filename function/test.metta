(@doc List.removeByIdx 
    (@desc "List.removeByIdx deletes an item in a list (second argument) using index (first argument) values ")
    (@params (
        (@param "$index:- index value")
        (@param "$list:- list data as (Cons $x $xs) format or Nil if empty")))
    (@return "List"))

(: List.removeByIdx (-> Number (List $a) (List $a)))
(= (List.removeByIdx $index $list)
    (function (eval (if-equal $list Nil
                        (return (Error $list EmptyList))
                        (unify $list (Cons $x $xs)
                            (eval (if-equal $index 0
                                (return $xs)
                                (chain (List.removeByIdx (- $index 1) $xs) $result
                                    (return (Cons $x $result)))))
                            (return (Error $list IncompatibleListType)))))))

;; alternative defintion of the same function

; (: List.removeByIdx (-> Number (List $a) (List $a)))
; (= (List.removeByIdx $index Nil) Nil)
; (= (List.removeByIdx $index (Cons $head $tail))
;    (if (< $index 0) (Cons $head $tail)
;        (if (== $index 0) $tail
;            (Cons $head (List.removeByIdx (- $index 1) $tail)))))

; ! (filter-atom (1 2 3 4 5 6) $x (eval (> $x 2)))
; ! (List.removeByIdx 0 Nil)
! (List.removeByIdx 0 (Cons 1 Nil))
! (List.removeByIdx 1 (Cons 1 (Cons 2 Nil)))
! (List.removeByIdx 2 (Cons 1 (Cons 2 (Cons 3 Nil))))
! (List.removeByIdx 3 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))
! (List.removeByIdx 20 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 5 (Cons 6 (Cons 7 (Cons 8 (Cons 9 (Cons 10 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 (Cons 2 (Cons 3 (Cons 4 Nil))))))))))))))))))))))))))))))))))))))))))))

;; to see the documentation of the functions
! (get-doc List.removeByIdx)