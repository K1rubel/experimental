! (register-module! ../../experimental)
! (import! &self experimental:exp-to-tree)

;; Test cases
! (assertEqual (exp2Tree A) (mkTree (mkNode A) Nil))
! (assertEqual (exp2Tree (AND A)) (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)))
! (assertEqual (exp2Tree (AND A (OR B C))) (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))))