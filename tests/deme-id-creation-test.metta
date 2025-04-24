! (register-module! ../../../experiments)
! (import! &self experiments:experimental:list-related)
! (import! &self experiments:experimental:todos:deme-id-creation)

;; for import checking
; ! (List.prepend 0 Nil)

! (assertEqual (createDemeIds 0 1) (Cons (mkDemeId "1") Nil))
! (assertEqual (createDemeIds 0 2) (Cons (mkDemeId "1.0") (Cons (mkDemeId "1.1") Nil)))
! (assertEqual (createDemeIds 0 3) (Cons (mkDemeId "1.0") (Cons (mkDemeId "1.1") (Cons (mkDemeId "1.2") Nil))))
