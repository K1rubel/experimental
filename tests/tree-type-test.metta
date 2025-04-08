! (register-module! ../../experimental)
! (import! &self experimental:tree-type)

;; no assertEqual's now
;; all the get-type statements are supposed to return (Tree Bool) as long as literal A is in the expressions

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
