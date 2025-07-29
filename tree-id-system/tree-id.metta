; ! (register-module! ../../experimental)
; ! (import! &self experimental:tree-type)

; ! (get-type (mkTree (mkNode A) Nil))


! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))))         

(: getNodeById (-> (Tree $a) (List Number) (Node $a)))
;; Base case: empty path means get the current node
(= (getNodeById (mkTree (mkNode $r) $children) Nil)
   (mkNode $r)
)

;; Recursive case: get child at head of path, then recurse
(= (getNodeById (mkTree (mkNode $r) $children) (Cons $idx $rest))
   (getNodeById (List.nth $children $idx) $rest))

;; Base case: index = 0 → return head of list
(: List.nth (-> (List $a) Number $a))

;; Recursive case: decrement index, recurse on tail
(= (List.nth (Cons $x $xs) $n)
    (if (== $n 0)
        $x
        (List.nth $xs (- $n 1))))

! (bind! tree1 (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))))  
! (getNodeById tree1 Nil)         ;; => (mkNode AND)
! (getNodeById tree1 (Cons 0 Nil)) ;; => (mkNode A)
! (getNodeById tree1 (Cons 1 (Cons 0 Nil))) ;; => (mkNode B)

