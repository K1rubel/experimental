!(register-module! ../../../experimental)
!(import! &self experimental:deme:expand-deme)
!(import! &self experimental:feature-selection:simple-feature-selector-helpers)
;;! (List.at 1 (Cons 1 (Cons 2 Nil))) 

;; Testing fsToNames
! (fsToNames (Cons A (Cons B (Cons C (Cons D Nil)))) (0 1)) ;; (A B)
! (fsToNames (Cons A (Cons B (Cons C (Cons D Nil)))) (0 2)) ;; (A C)
! (fsToNames (Cons A (Cons B (Cons C (Cons D Nil)))) (1 2)) ;; (B C)

