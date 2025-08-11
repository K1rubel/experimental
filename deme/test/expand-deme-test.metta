!(register-module! ../../../experimental)
!(import! &self experimental:deme:expand-deme)
!(import! &self experimental:feature-selection:simple-feature-selector-helpers)
;;! (List.at 1 (Cons 1 (Cons 2 Nil))) 

;; Testing fsToNames
! (fsToNames (Cons A (Cons B (Cons C (Cons D Nil)))) (0 1)) ;; (A B)
! (fsToNames (Cons A (Cons B (Cons C (Cons D Nil)))) (0 2)) ;; (A C)
! (fsToNames (Cons A (Cons B (Cons C (Cons D Nil)))) (1 2)) ;; (B C)

 ! (bind! ceil (py-atom math.ceil)) 


! (ceil 3.21)
! (rand 2 56)

! (bind! ttable (mkITable  
            (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
            (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil))))
            
            (Cons A (Cons B (Cons C (Cons D (Cons Output Nil)))))))

! (ssByRow ttable 2)
