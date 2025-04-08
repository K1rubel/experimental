! (takeN 5 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))


! (listMax Nil) ;; Nil
! (listMax (Cons 1 (Cons 2 Nil))) ;; 2
! (listMax (Cons 7 (Cons 1 (Cons 2 Nil)))) ;; 7
! (listMax (Cons 7 (Cons 9 (Cons 1 (Cons 2 Nil))))) ;; 9


;; type definition for test
(: Size Type)
(: mkSize (-> Number Size))

! (listMax >>= Nil)
! (listMax >>= (Cons (mkSize 1) Nil))
! (listMax >>= (Cons (mkSize 4) (Cons (mkSize 7) (Cons (mkSize 1) Nil))))