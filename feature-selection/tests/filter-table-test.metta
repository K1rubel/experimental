!(register-module! ../../../experimental)
!(import! &self experimental:feature-selection:feature-selection-main)
!(import! &self experimental:feature-selection:filter-table)
!(import! &self experimental:feature-selection:simple-feature-selector-helpers)

! (bind! ttable1 (mkITable
                         (Cons (Cons False (Cons False (Cons False Nil))) 
                         (Cons (Cons True (Cons False (Cons False Nil))) 
                         (Cons (Cons False (Cons True (Cons False Nil)))
                         (Cons (Cons True (Cons True (Cons True Nil))) Nil))))
                         (Cons A (Cons B (Cons O Nil)))))

;; Test -- filter table
! (filterTable (0) ttable1)    
            (mkITable 
                    (Cons (Cons False (Cons False Nil)) 
                    (Cons (Cons False (Cons False Nil)) 
                    (Cons (Cons True (Cons False Nil)) 
                    (Cons (Cons True (Cons True Nil)) Nil)))) 
                    (Cons B (Cons O Nil)))

! (filterTable (1) ttable1)    
            ; (mkITable 
            ;         (Cons (Cons False (Cons False Nil)) 
            ;         (Cons (Cons True (Cons False Nil)) 
            ;         (Cons (Cons False (Cons False Nil)) 
            ;         (Cons (Cons True (Cons True Nil)) Nil)))) 
            ;         (Cons A (Cons O Nil)))