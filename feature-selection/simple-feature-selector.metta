;; Compuatation of mutual information 
;; We have two competing table representations
;; The first where the table is represnted as concatenation of two lists
;;      the first -- list of lists for data only
;;      the second -- list of labels as table headers

! (bind! ttable (mkITable  
            (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
            (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil))))
            
            (Cons A (Cons B (Cons C (Cons D (Cons Output Nil)))))))
         
! (bind! dataRows 
            (Cons (Cons True (Cons True (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons True (Cons False (Cons False (Cons True (Cons True Nil)))))
            (Cons (Cons False (Cons True (Cons False (Cons True (Cons False Nil)))))
            (Cons (Cons False (Cons False (Cons False (Cons True (Cons False Nil))))) Nil)))))

;;  The second alternative -- list of columns where each column consists of as its first element, a header val, and list of values as data points
;; table formed as list of columns

; ! (bind! ttable1 (Cons (Cons A (Cons True (Cons False Nil)))
;                 (Cons (Cons B (Cons False (Cons False Nil))) 
;                 (Cons (Cons O (Cons True (Cons True Nil))) Nil))))

;; compute entropy
(= (entropy $countTuple $totalCount $sum)
    (if-decons-expr $countTuple $h $t
        (unify $h ($item $count)
            (chain (/ $count $totalCount) $p-i ;; need a condition to skip calculation of log of 0 values
                (chain (if (== $p-i 0) $p-i (round (lg 2 $p-i) 2)) $log-val  ;; might need to find new ways of calculating rounded values without python binding
                    (chain (* $p-i $log-val) $product
                        (entropy $t $totalCount (- $sum $product))))))
        $sum))

; ;; python evaluation im mettalog
; ! (py-eval "5 + 6")     
; ! (py-eval "random.seed()")   
; ! (py-eval "random.seed()")   
; ! (py-eval "radnom.randint()")
; ! (py-exec! "radnom.randint")
   

; (Cons (True True) (Cons (True False) (Cons (True False) Nil))) the output should be  ( ((True True) 1) ((True False) 2)) 

(: List.countOccurrences (-> $a (List $a) Number))
(= (List.countOccurrences $item $list)
    (unify $list Nil 0
        (unify $list (Cons $x $xs)
            (if (== $x $item)
                (+ 1 (List.countOccurrences $item $xs))
                (List.countOccurrences $item $xs))
            ())))

; ! (List.countOccurrences (True True) (Cons (True True) (Cons (True False) (Cons (True False) Nil))))     ;;    
; ! (List.countOccurrences (True False) (Cons (True True) (Cons (True False) (Cons (True False) Nil))))           

(: List.removeAll (-> $a (List $a) (List $a)))
(= (List.removeAll $item $list)
    (unify $list Nil Nil
        (unify $list (Cons $x $xs)
            (if (== $x $item)
                (List.removeAll $item $xs)
                (Cons $x (List.removeAll $item $xs)))
            ())))

(: List.frequencies (-> (List $a) (List (($a) Number))))
(= (List.frequencies $list)
    (unify $list 
        Nil Nil
        (unify $list (Cons $x $xs)
            (let $count (List.countOccurrences $x $list)
                (let $rest (List.removeAll $x $xs)
                    (Cons ($x $count)
                          (List.frequencies $rest))))
            ())))
          
; ! (List.frequencies (Cons (True True) (Cons (True False) (Cons (True False) Nil))))           


(:listToExpr (-> (List $a) Expression))            
(= (listToExpr $list)
    (unify $list (Cons $x $xs)
        (chain (listToExpr $xs) $res (cons-atom $x $res))
        ()))

; ! (listToExpr Nil) ;; ()
; ! (listToExpr (Cons 1 Nil)) ;; (1)
; ! (listToExpr (Cons 2 (Cons 1 Nil))) ;; (2 1)
; ! (listToExpr (List.frequencies (Cons (True True) (Cons (True False) (Cons (True False) Nil)))))

;; this is a procedure that calcualtes the mutual information between an input and output features
;; assuming the two columns are to be gotten from a preceeding sub-procedure in a main loop
;; as well as the row count of the table
;; $if/$of -- input/output feature
;; $ie/$oe -- input/output feature entropy

(= (mutualInformation $if $of $len) 
    ;; get entropy of the input and output feature separately
    ;; as well as the entropy of input output combination 
    (chain (List.uniqueValuesCount $if ()) $ic  ;; input count / distinct
    (chain (entropy $ic $len 0) $ie
    (chain (List.uniqueValuesCount $of ()) $oc ;; output count / distinct
    (chain (entropy $oc $len 0) $oe ;; rather than calculating this value for each feature better pass it as an argument
    (chain (List.zip $if $of) $io-zip
    (chain (List.uniqueValuesCount $io-zip ()) $io-c
    (chain (entropy $io-c $len 0) $io-e
    (- (+ $ie $oe) $io-e)))))))))

;; simpleFeatureSelector -- simple feature selection algo
;;                      -- producse singletone of sets selected using MI as the scorer
;; parameters 
;;          $table      -- datarows
;;          $labels     -- column labels
;;          $th   -- minimum MI thhold value considered for selection
;;          $expDist    -- bool value if exponential distn is preferred instead of sharp cut off   
;;          $acc        -- accumulator for selected features

(= (simpleFeatureSelector $numDesired (mkITable $table $labels) $th $expDist $acc)
    (chain (List.length $labels) $colNum 
    (chain (List.length $table) $rowNum $rowNum
    (chain (Table.getColumn (- $colNum 1) $table) $oc ;; get the output column
    (chain (List.uniqueValuesCount $oc ()) $ouc ;; output colum unique count
    (chain (entropy $ouc $rowNum 0) $oe ;; ouput feature entropy -- not used now but to avoid repeated calculation of output entropy
    ;; all that remains to be done is to get mi value of all the input features against the output feature
    (chain (selectorIterator $th $rowNum $oc $labels $table 0 $acc) $selected-features 
    
    ; this is the actual selection after the scoring
    ; if exponential distn is preferred 
    (chain (if $expDist
        (chain (- 1 (/ 1 (+ $numDesired 1))) $mean
            (exponentialSelection $mean $numDesired $selected-features 1 ()))
        (takeN $numDesired $selected-features)) $index-score-tuples
        (collapse (chain (superpose $index-score-tuples) $pair (second $pair)))))))))))

;;          $mean                   -- mean of num desired for the exponential dist
;;          $numDesired             -- number of features to be selected
;;          $scoreLableTuple        -- tuple of MI scores and corresponding labels -- this might change into index values
;;          $xn                     -- factor controlling what gets selected -- starts as 1
;;          $acc                    -- accumulator for selected features

(= (exponentialSelection $mean $numDesired $scoreLabelTuple $xn $acc)
    (if (== $numDesired 0)
        $acc
        (trace! ($rndFloat $xn) (if-decons-expr $scoreLabelTuple $h $t
            (chain (rndFloat) $rndFloat
            (if (< $rndFloat $xn)
                (chain (union-atom $acc ($h)) $new-acc
                    (exponentialSelection $mean (- $numDesired 1) $t (* $xn $mean) $new-acc))
                (exponentialSelection $mean $numDesired $t (* $xn $mean) $acc))) ;; some adjustment needed here to make sure numDesired amount is returned check if numDesired is equal to what is left. if so append all to the acc to make sure  
        $acc))))
    
;;      $th                       -- threshold
;;      $rowNum                     -- total data rows count
;;      $oc                         -- output column
;;      $dataRows                   -- data rows
;;      (Cons $label $labels)       -- list of lables (Cons A (Cons B ..))
;;      $counter                      -- feature index counter

(= (selectorIterator $th $rowNum $oc (Cons $label $labels) $dataRows $counter $acc)
    (chain (List.length (Cons $label $labels)) $list-len
        (if (== $list-len 1) ;; this means we are at the output label
            $acc
            (chain (Table.getColumn 0 $dataRows) $if    ;; input feature taken from the table ,, always the first column
            (chain (Table.pop $dataRows) $rem-table  $rem   ;; remove the first column -- better than carrying around the whole table
            (chain (mutualInformation $if $oc $rowNum) $mi  ;; mutual information calculated for the input feature
                (if (=> $mi $th)
                    (chain (insertPair > ($mi $counter) $acc) $new-acc
                        (selectorIterator $th $rowNum $oc $labels $rem-table (+ $counter 1) $new-acc))
                    (selectorIterator $th $rowNum $oc $labels $rem-table (+ $counter 1) $acc))))))))        ;; an improvement point --> instead of calculating output feature entropy every time, calcualte once and pass it to the MI calculator


; ! (simpleFeatureSelector 4 ttable 0 True ()) ;; ((1.0 A) (0.0 B) (0.0 C) (0.0 D))
! (simpleFeatureSelector 2 ttable 0 False ()) ;; ((1.0 A) (0.0 B) (0.0 C) (0.0 D))

