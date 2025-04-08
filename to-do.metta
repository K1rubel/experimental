(: Node (-> $a Type))
(: mkNode (-> $a (Node $a)))

(: List (-> $a Type))
(: Nil (List $a))

(: Cons (-> $a (List $a) (List $a)))

(: Tree (-> $a Type))

(: mkTree (-> (Node $a) (List (Tree $a)) (Tree $a)))

(: A Bool)

;; A as tree

! (get-type (mkTree (mkNode A) Nil))

;; (AND A )
! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)))

;; (AND A B)
! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))))

;; (AND A B (OR A))
! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) Nil)) Nil)))))

(1 2 3) - (Cons 1 (Cons 2 (Cons 3 Nil)))
(Cons 1 Nil) --> (1)

(: l2Ex (-> (List $a) Expression))

(= (l2Ex Nil) ())
(= (l2Ex (Cons $x $xs))
    (let $c (l2Ex $xs)
        (cons-atom $x $c)))

! (l2Ex (Cons 0 (Cons 1 (Cons 2 Nil))))

(: ex2L (-> Expression (List $a)))

(AND A B (OR C B))

(: map (-> (List $a) (-> $a $b) (List $c)))