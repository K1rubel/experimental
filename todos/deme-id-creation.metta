; ! (register-module! ../../../experiments)
; ; ! (import! &self experiments:experimental:list-related)
; ! (import! &self experiments:experimental:tree-type)

;; unless dynamic feature selection is enabled only one deme is created
;; feature selection is not used so just one deme will be created in our case
;; n_demes of the feature selector params is set to 1 by default
;; the number of expansion is set to zero (0) in moses_params.h in the moses_statistics struct

;; type definition -- deme IDs
(: DemeId Type)
(: mkDemeId (-> Number DemeId))
(: mkDemeId (-> (Number Number) DemeId))

(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; createDemeIDs -- creates demeIDs for deme expansion
;;          $nExpansion -- total number of deme expansions (generations) set to 0 -- a constant number or a generation demes
;;          $nDemes     -- Number of feature sets to select out of feature selection and demes to spawn
;;          $demeList   -- list container for demes

! (bind! n_expansion 0) ;; this better be in a space for updating multiple generations are allowed
(: createDemeIds (-> Number Number (List DemeId)))
(= (createDemeIds $nExpansion $nDemes)
    (if (> $nDemes 1)
        (let $start 0 (createDemeList $start $nDemes)) 
        (Cons (mkDemeId (+ $nExpansion 1)) Nil)))

;; create the demeId list using sequentially
;;      -- $n start 0
;;      -- $nDemes number of deme to spawn in a generation

(: createDemeList (-> Number Number (List $a)))
(= (createDemeList $n $nDemes)
        (if (== $n $nDemes)
            Nil
            (let $c (createDemeList (+ $n 1) $nDemes)
                    (Cons (mkDemeId ((+ 1 n_expansion) $n)) $c))))

; ! (mkDemeId 5)
; ! (mkDemeId (1, 5))

; ! (get-type (mkDemeId 5))
; ! (get-type (mkDemeId (1 5)))
; ! (createDemeList 0 1)
! (createDemeIds 0 2)
; ! (get-type (Cons (mkDemeId (1 0)) (Cons (mkDemeId (1 1)) (Cons (mkDemeId (1 2)) (Cons (mkDemeId (1 3)) (Cons (mkDemeId (1 4)) Nil))))))
! (get-type (Cons (mkDemeId 1) Nil))