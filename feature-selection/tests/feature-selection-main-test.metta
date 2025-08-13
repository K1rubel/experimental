!(register-module! ../../../experimental)
!(import! &self experimental:feature-selection:feature-selection-main)
!(import! &self experimental:feature-selection:simple-feature-selector-helpers)
; !(import! &self experimental:list:list-methods-dev)
;; the table
! (bind! ttable1 (mkITable
                         (Cons (Cons False (Cons False (Cons False Nil))) 
                         (Cons (Cons True (Cons False (Cons False Nil))) 
                         (Cons (Cons False (Cons True (Cons False Nil)))
                         (Cons (Cons True (Cons True (Cons True Nil))) Nil))))
                         (Cons A (Cons B (Cons O Nil)))))

! (bind! dataRows 
                (Cons (Cons False (Cons False (Cons False Nil))) 
                (Cons (Cons True (Cons False (Cons False Nil))) 
                (Cons (Cons False (Cons True (Cons False Nil)))
                (Cons (Cons True (Cons True (Cons True Nil))) Nil)))))

;; checking the subsample function
!(subsampleTable 2 dataRows)  ;; sample output
                               ;;(Cons (Cons True (Cons False (Cons False Nil))) 
                               ;;(Cons (Cons False (Cons True (Cons False Nil))) Nil))
!(List.pop 1 (Cons A (Cons B Nil))) ;; (Cons A Nil)

