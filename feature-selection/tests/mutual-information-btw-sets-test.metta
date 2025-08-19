! (register-module! ../../../experimental)
! (import! &self experimental:feature-selection:select-top-features)
! (import! &self experimental:feature-selection:simple-feature-selector-helpers)
! (import! &self experimental:feature-selection:simple-feature-selector)
! (import! &self experimental:feature-selection:cScore)
! (import! &self experimental:deme:expand-deme)

; ! (List.uniqueValuesCount (Cons 1 (Cons 2 (Cons 1 Nil))) ());; working
! (bind! round (py-atom round))
! (round 3.434213 2)
! (let $a (List.uniqueValuesCount (Cons 1 (Cons 2 (Cons 1 (Cons 2 Nil)))) ())
    (entropy $a 4 0)) ;; working
    

