(: Node (-> $a Type))
(: mkNode (-> $a (Node $a)))

(: List (-> $a Type))
(: Nil (List $a))

(: Cons (-> $a (List $a) (List $a)))

(: Tree (-> $a Tree))
(: mkTree (-> (Node $a) (List (Tree $a)) (Tree $a)))

(: A Bool)

! (get-type (mkTree (mkNode A) Nil)) ;; A

! (get-type (mkTree (mkNode AND) Nil)) ;; AND -- not type information

! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil))) ;; (AND A)

! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil)))) ;; (AND A B)

! (get-type (mkTree (mkNode AND) 
        (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) 
            (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))))) ;; (AND A B (OR B C))
            
! (get-type (mkTree (mkNode AND) 
        (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) (Cons (mkTree (mkNode C) Nil) Nil)) 
            (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))))) ;; (AND A B (OR B C))

! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))))
! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))))
