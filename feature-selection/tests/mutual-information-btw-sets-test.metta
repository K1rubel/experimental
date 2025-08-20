! (register-module! ../../../experimental)
! (import! &self experimental:feature-selection:select-top-features)
! (import! &self experimental:feature-selection:simple-feature-selector-helpers)
! (import! &self experimental:feature-selection:simple-feature-selector)
! (import! &self experimental:feature-selection:incremental-helpers)
! (import! &self experimental:feature-selection:mutual-information-btw-sets)
! (import! &self experimental:feature-selection:smd)
! (import! &self experimental:feature-selection:cScore)
! (import! &self experimental:deme:expand-deme)

!(bind! complexTable 
    (mkITable 
        (Cons (Cons False (Cons False (Cons True (Cons True (Cons True Nil)))))
        (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
        (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
        (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil))))
        (Cons A (Cons B (Cons C (Cons D (Cons Output Nil)))))))

! (bind! data (Cons (Cons False (Cons False (Cons True (Cons True (Cons True Nil)))))
        (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
        (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
        (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil)))))        
; ! (List.uniqueValuesCount (Cons 1 (Cons 2 (Cons 1 Nil))) ());; working
! (bind! round (py-atom round))
; ; ! (round 3.434213 2)
; ! (let $a (List.uniqueValuesCount (Cons 1 (Cons 2 (Cons 1 (Cons 2 Nil)))) ())
;     (entropy $a 4 0)) ;; working 1
; ! (let $a (List.uniqueValuesCount Nil ())
;     (entropy $a 4 0)) ;; working 0

; ! (zipColumn (1) data)    
; ! (zipColumn () data)    
; ; ! (powerset (0 1 2) 2 False)
; ! (List.uniqueValuesCount Nil ())
; ! (mutualInformationBtwSets (1) (1) complexTable)
; ! (mi (1) (1) -1 complexTable) ;; 
; ! (mi (1) (1) 0 complexTable) ;; 
; ! (mi (1) (0) 0 complexTable) ;; 
; ; ! (mi (1) (2) 0 complexTable) ;; 
; ! (mi (1 2) (2 1) 0 complexTable) ;; 
; ! (mi (1 2) (0 3) 0 complexTable) ;; 
! (mi (1) (0 3) 0 complexTable) ;; 

; ! (map-atom (1 2 3) $a (map-atom (1 2 3 4) $b (+ $a $b)))