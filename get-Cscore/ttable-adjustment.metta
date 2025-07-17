
! (bind! ttable (mkITable  (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
            (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil))))
            (Cons A (Cons B (Cons C (Cons D (Cons Output Nil)))))))
 (= (adjustTruthTable $candidateArgs (mkITable $dataRows $labels))
    (chain (argsFromTableHeader $labels) $totalArgs
        (chain (subtraction-atom $totalArgs $candidateArgs) $diff
            (chain (getIndicesOfDiffArgs $totalArgs ))           
; ;; filter truth table based on the arguments in the tree
; ;; call getArgument function
; ! (let (mkITable $data $labels) ttable  ;; deconstruct the truth table into data and labels
;     (chain (argsFromTableHeader $labels) $args
;         (chain (argsFromTree $tree) $treeArgs      ;; get args from the tree
;             (chain (subtraction-atom $args $treeArgs) $diff $diff)))) ;; to measure the perfomance of the boolean expression you will have to remove entries associated with $diff args

;; the output lable is the last one, so collect everyting except the last label
(: argsFromTableHeader (-> (List $a) Expression))
(= (argsFromTableHeader (Cons $x $xs))
    (unify $xs Nil () ;; means we have reached the end of the list including the output label
            (chain (argsFromTableHeader $xs) $res ;; else keep on collecting args from the list and append them
                (cons-atom $x $res))))

! (argsFromTableHeader (Cons B Nil)) ;; ()
! (argsFromTableHeader (Cons A (Cons B Nil))) ;; (A)
! (argsFromTableHeader (Cons A (Cons B (Cons C (Cons D (Cons Output Nil)))))) ;; (A B C D)

! (subtraction-atom (A B C D) (D A)) ;; (B C)

(: getIndexOfDiffArg (-> Expression (List $a) Expression))
(= (getIndexOfDiffArg $diff $labels) ;; get indices of those features in the truth table but not in the tree
    (if-decons-expr $diff $h $t
        (chain (getIndexOfDiffArg $t $labels) $res
            (chain (List.getIndexOf $h $labels) $h-mapped
                (if-error $h-mapped $h-mapped 
                    (cons-atom $h-mapped $res))))
                ()))

;; return the index of a symbol in the list        
(: List.getIndexOf (-> $a (List $a) Number))        
(= (List.getIndexOf $el $list)
    (unify $list Nil
        (Error $el "Not found in label list/Empty list")
        (unify $list (Cons $x $xs)
            (if (== $x $el)
                0
                (chain (List.getIndexOf $el $xs) $res 
                    (if-error $res $res (+ 1 $res))))
            (Empty))))

;; apply the above List.getIndexOf to an expression of labels          
(= (map-get-index $f $expr $arg)
    (if-decons-expr $expr $head $tail
        (chain (map-get-index $f $tail $arg) $res
            (chain ($f $head $arg) $head-mapped
            (cons-atom $head-mapped $res)))
        ()))
   

;; once we have indices of those labels that are not incuded in the tree just remove those indices from the list
(= (List.dropAt $pos $list)
    (unify $list Nil
        (Error $list "Empty list -- nothing to drop")
            (unify $list (Cons $x $xs)
                (if (== $pos 0)
                    $xs
                    (chain (List.dropAt (- $pos 1) $xs) $res
                        (if-error $res $res (Cons $x $res))))
                ())))

;; map this with the list of lists that is the truth table rows
;; to remove all the corresponding entries from the rows as well as labels
(: map-dropAt (-> (List (List $a)) Number (List (List $a))))
(= (map-dropAt $dataRows $index)
   (unify $dataRows Nil
        Nil
        (unify $dataRows (Cons $x $xs)
            (chain (List.dropAt $index $x) $label-dropped-from-first
                (chain (map-dropAt $xs $index) $rest-adjusted 
                    (Cons $label-dropped-from-first $rest-adjusted)))
                ())))

! (bind! dataRows 
            (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
            (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil)))))                

(: mapp-dropAt (-> (List (List $a)) Expression (List (List $a))))
(= (mapp-dropAt $dataRows $indices)
    (if-decons-expr $indices $h $t
        (chain (map-dropAt $dataRows $h) $first-index-used
            (chain (map dec $t) $newIndices ;; every other index has to be decremented by one after the first removal as the length of the list is one less from when the thing started
               (mapp-dropAt $first-index-used $newIndices)))
     $dataRows))   

(: map (-> (-> $a $a) Expression Expression))     
(= (map $f $expr)
    (if-decons-expr $expr $h $t
        (chain ($f $h) $h-mapped
            (chain (map $f $t) $t-mapped
                (cons-atom $h-mapped $t-mapped)))
            ()))


;; decrement operator
(: dec (-> Number Number))            
(= (dec $n) (- $n 1))

; ! (List.getIndexOf A Nil) ;; (Error Nil "Empty List")
; ! (List.getIndexOf A (Cons A (Cons B (Cons C Nil)))) ;; 0
; ! (List.getIndexOf C (Cons A (Cons B (Cons C Nil)))) ;; 2
; ! (List.getIndexOf D (Cons A (Cons B (Cons C Nil)))) ;; 
; ! (List.getIndexOf D (Cons A (Cons B (Cons C (Cons D Nil))))) ;; 

; ! (map-get-index List.getIndexOf (B C) (Cons A (Cons B (Cons C (Cons D Nil))))) ;; (1 2)
; ! (map-get-index List.getIndexOf (A C) (Cons A (Cons B (Cons C (Cons D Nil))))) ;; (0 2)
; ! (map-get-index List.getIndexOf (C D) (Cons A (Cons B (Cons C (Cons D Nil))))) ;; (2 3) 

; ! (getIndexOfDiffArg (A B) (Cons A (Cons B (Cons C Nil))))

; ! (List.dropAt 0 Nil)  ;; (Error Nil "Empty list -- nothing to drop")
; ! (List.dropAt 0 (Cons A Nil)) ;; Nil
; ! (List.dropAt 0 (Cons A (Cons B Nil))) ;; (Cons B Nil)
; ! (List.dropAt 1 (Cons A (Cons B Nil))) ;; (Cons A Nil)
; ! (List.dropAt 1 (Cons A (Cons B (Cons C Nil)))) ;; (Cons A (Cons C Nil))
; ! (List.dropAt 2 (Cons A (Cons B (Cons C (Cons D Nil))))) ;; (Cons A (Cons B (Cons D Nil)))
; ! (map-dropAt dataRows 0)

    ; (Cons (Cons True (Cons False (Cons True (Cons True Nil)))) 
    ; (Cons (Cons False (Cons False (Cons True (Cons True Nil)))) 
    ; (Cons (Cons True (Cons False (Cons True (Cons False Nil)))) 
    ; (Cons (Cons False (Cons False (Cons True (Cons False Nil)))) Nil))))


; ! (map-dropAt dataRows 1)   
    ; (Cons (Cons True (Cons False (Cons True (Cons True Nil)))) 
    ; (Cons (Cons True (Cons False (Cons True (Cons True Nil)))) 
    ; (Cons (Cons False (Cons False (Cons True (Cons False Nil)))) 
    ; (Cons (Cons False (Cons False (Cons True (Cons False Nil)))) Nil))))

; ! (map-dropAt dataRows 4)   

; (Cons (Cons True (Cons True (Cons False (Cons True Nil)))) 
; (Cons (Cons True (Cons False (Cons False (Cons True Nil)))) 
; (Cons (Cons False (Cons True (Cons False (Cons True Nil)))) 
; (Cons (Cons False (Cons False (Cons False (Cons True Nil)))) Nil))))

; ! (mapp-dropAt dataRows ())
    ; (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil))))) 
    ; (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil))))) 
    ; (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil))))) 
    ; (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil))))


; ! (if-decons-expr (0) $h $t 
;      (map-dropAt dataRows $h)
; ())
; (Cons (Cons True (Cons False (Cons True (Cons True Nil)))) 
; (Cons (Cons False (Cons False (Cons True (Cons True Nil)))) 
; (Cons (Cons True (Cons False (Cons True (Cons False Nil)))) 
; (Cons (Cons False (Cons False (Cons True (Cons False Nil)))) Nil))))

; ! (mapp-dropAt dataRows (0))
;      (Cons (Cons True (Cons False (Cons True (Cons True Nil)))) 
;      (Cons (Cons False (Cons False (Cons True (Cons True Nil)))) 
;      (Cons (Cons True (Cons False (Cons True (Cons False Nil)))) 
;      (Cons (Cons False (Cons False (Cons True (Cons False Nil)))) Nil))))

; ! (mapp-dropAt dataRows (0 1))
;         (Cons (Cons False (Cons True (Cons True Nil))) 
;         (Cons (Cons False (Cons True (Cons True Nil))) 
;         (Cons (Cons False (Cons True (Cons False Nil))) 
;         (Cons (Cons False (Cons True (Cons False Nil))) Nil))))

! (mapp-dropAt dataRows (0 2))
        (Cons (Cons True (Cons True (Cons True Nil))) 
        (Cons (Cons False (Cons True (Cons True Nil))) 
        (Cons (Cons True (Cons True (Cons False Nil))) 
        (Cons (Cons False (Cons True (Cons False Nil))) Nil))))

