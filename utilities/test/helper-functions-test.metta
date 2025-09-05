! (register-module! ../../../../experiments)
! (import! &self experiments:experimental:utilities:helper-functions)

;; assuming metta's union-atom behavior
! (assertEqual (reverse ()) ())
! (assertEqual (reverse (1 2)) (2 1))
! (assertEqual (reverse (1 2 3)) (3 2 1))
! (assertEqual (reverse (1 2 3 2)) (2 3 2 1))

;; 