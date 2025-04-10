! (register-module! ../../experimental)
! (import! &self experimental:list-related)

! (takeN 5 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))


! (List.max Nil) ;; Nil
! (List.max (Cons 1 (Cons 2 Nil))) ;; 2
! (List.max (Cons 7 (Cons 1 (Cons 2 Nil)))) ;; 7
! (List.max (Cons 7 (Cons 9 (Cons 1 (Cons 2 Nil))))) ;; 9


;; type definition for test
(: Size Type)
(: mkSize (-> Number Size))

! (List.max >>= Nil)
! (List.max >>= (Cons (mkSize 1) Nil))
! (List.max >>= (Cons (mkSize 4) (Cons (mkSize 7) (Cons (mkSize 1) Nil))))

! (List.sum (Cons 1 Nil)) ;; 1       
! (List.sum (Cons 1 (Cons 2 Nil))) ;; 3      
! (List.sum (Cons 1 (Cons 2 (Cons 3 Nil)))) ;; 6 
! (List.sum (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil))))) ;; 6 


! (plus (mkSize 3) (mkSize 2)) ;; (mkSize 5)

! (List.sum plus (Cons (mkSize 1) Nil));; (mkSize 1)
! (List.sum plus (Cons (mkSize 1) (Cons (mkSize 2) Nil)));; (mkSize 3)
! (List.sum plus (Cons (mkSize 1) (Cons (mkSize 2) (Cons (mkSize 4) Nil))));; (mkSize 7)


! (List.sum` half (Cons 2 (Cons 4 (Cons 6 Nil)))) ;; 6
! (List.sum` half (Cons 2 (Cons 4 (Cons 6 (Cons 7.0 Nil))))) ;; 9.5

! (List.sum` half plus (Cons (mkSize 2) (Cons (mkSize 4) (Cons (mkSize 6) Nil)))) ;; 6
! (List.sum` half plus (Cons (mkSize 2) (Cons (mkSize 4) (Cons (mkSize 6) (Cons (mkSize 7.0) Nil))))) ;; 9.5

! (boltzNomralizer (mkSize 25) (mkSize 0.7) (mkSize 0.3))

! (normalizeProbs (mkScoreT 25) (mkScoreT 0.7) (Cons (mkScoreT 0.4) (Cons (mkScoreT 0.1) (Cons (mkScoreT 0.9) Nil))))
