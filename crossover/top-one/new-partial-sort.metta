! (register-module! ../../experimental)
; ! (import! &self experimental:merge-deme:sort-demes:sort_demes)
! (import! &self experimental:list:type)
! (import! &self experimental:crossover:helpers)
;; Helper for partial sort: selects top 'n' max elements from list, accumulates into 'acc'
(: partialSortHelper (-> (List Number) Number (List Number) (List Number)))
(= (partialSortHelper Nil $_ $acc) $acc)
; (= (partialSortHelper $lst 0 $acc) $acc)
(= (partialSortHelper $lst $n $acc)
    (chain (List.max $lst) $maxVal
        (chain (List.delete $maxVal $lst) $rest
            (partialSortHelper $rest (- $n 1) (List.append $maxVal $acc)))))
    ; (let* (($maxVal (List.max $lst))
    ;        ($rest (List.delete $maxVal $lst)))
    ;   (partialSortHelper $rest (- $n 1) (List.append $maxVal $acc))))

;; Partially sorts a list of numbers by selecting top 'n' largest elements
(: List.partialSort (-> (List Number) Number (List Number)))
(= (List.partialSort $xs $n)
    (if (>= $n 0)
        (partialSortHelper $xs $n Nil)
        (Error Nil "Invalid argument: n must be >= 0")))
        
! (List.partialSort (Cons 5 (Cons 1 (Cons 8 (Cons 3 Nil)))) 2)
! (List.partialSort (Cons 5 (Cons 1 (Cons 8 (Cons 3 (Cons 4 Nil))))) 2)
;; => Cons 8 (Cons 5 Nil)