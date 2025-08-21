!(register-module! ../../../experimental)
!(import! &self experimental:representation:representation)
!(import! &self experimental:deme:expand-deme)
!(import! &self experimental:feature-selection:feature-selection-main)
!(import! &self experimental:feature-selection:simple-feature-selector-helpers)
; !(import! &self experimental:list:list-methods-dev)

;; testing imports
! (exemplarFtsIndices (mkTree (mkNode A) Nil) (Cons A Nil))
! (exemplarFtsIndices (mkTree (mkNode AND) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode A) Nil) Nil))) (Cons A (Cons B Nil)))
! (exemplarFtsIndices (mkTree (mkNode AND) (Cons (mkTree (mkNode B) Nil) Nil)) (Cons A (Cons B Nil)))

! (extractArgs (mkTree (mkNode AND) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode A) Nil) Nil))))