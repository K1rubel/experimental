! (register-module! ../../../experimental)
! (import! &self experimental:feature-selection:select-top-features)
! (import! &self experimental:feature-selection:simple-feature-selector-helpers)
! (import! &self experimental:feature-selection:cScore)
! (import! &self experimental:deme:expand-deme)

! (first ( 1 2))
! (jaccardIndex (1 2 3) (3 4 1))
! (jaccardIndex (A) (A))
! (jaccardIndex (A) (B))
; ! (isnan-math 4) ;; dont work in mettalog
; ! (isnan 4) 

; ! (cScore> (mkCscore 1 2 3 4 5) (mkCscore 2 3 4 5 6))

; ! (getPenScore (mkCscore 1 2 3 4 5))
; ! (insertPair cScore>= ((mkCscore 2 3 4 5 7) C) (((mkCscore 2 3 4 5 6) B) ((mkCscore 1 2 3 4 5) A)))

! (rankIterator 2 False ja (((mkCscore 1 2 3 10 3) (A)) ((mkCscore 1 2 3 0.3 4) (B))) ())
; ! (min-atom (3 (size-atom (1 2 3 4)))) ;; doestn work -- min-atom expects grounded atoms -- reduced values not expressions