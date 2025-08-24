;; mutual information between feature sets -- makes use of the diversity interaction parameter, which dictates the amount of set to set interaction required to calculate similarity of sets using average mutual inforamtion
(= (mi $set1 $set2 $div-interaction (mkITable $table $lables))
    (if (< $div-interaction 0)
            (mutualInformationBtwSets $set1 $set2 (mkITable $table $labels))
            (let* (($sss (+ $div-interaction 1))
                    (($ps1 $ps2) (map-atom ($set1 $set2) $set (powerset $set $sss True)))           ;; powersets of the two feature sets
                    (($ps1-size $ps2-size) ((size-atom $ps1) (size-atom $ps2)))                     ;; size of the power sets
                    ($all-comb-mi (map-atom $ps1 $ps-a (map-atom $ps2 $ps-b (mutualInformationBtwSets $ps-a $ps-b (mkITable $table $labels)))))        ;; calculation of mutual information between all features sets in the powersets -- all combinations XXX -- i think the labels are not needed in the calculation
                    ($inner-sum (map-atom $all-comb-mi $mi (foldl-atom $mi 0 $acc $x (+ $acc $x))))         ;; folding the resulting tuple of tuples of MI values into one tuple
                    ($total-mi (foldl-atom $inner-sum 0 $acc $x (+ $acc $x))))                              ;; final fold to get the sum MI
                    
                    (/ $total-mi (* $ps1-size $ps2-size))))) ;; the final answer is an average value of the total MI 

(= (mutualInformationBtwSets $set1 $set2 (mkITable $table $labels))
    (let* (($union (union-atom $set1 $set2))
            ($len (List.length $table))     ;; total number of rows
            (($set1-zip $set2-zip $union-zip) (map-atom ($set1 $set2 $union) $set (zipColumn $set $table)))
            (($zip1-count $zip2-count $union-count) (map-atom ($set1-zip $set2-zip $union-zip) $zip (List.uniqueValuesCount $zip ())))
            ; (($e1 $e2 $eu) (map-atom ($zip1-count $zip2-count $union-count) $count (if (== $count ()) 0 (entropy $count $len 0)))) ;; thought this would have performance improvement but appears to not
            (($e1 $e2 $eu) (map-atom ($zip1-count $zip2-count $union-count) $count (entropy $count $len 0))))

            (- (+ $e1 $e2) $eu)))

;; what is left is to calcualte power set of a set based on diversity interaction value and 
;; find the average mutual information between every combination of the two power sets

;; powerset -- generates all the subsets of $set including 
;;          -- $n number of interaction
;;          -- $exact bool indicating whether to generate all combinations or just the exact number of interaction set sizes only True -- means exactly that amount False -- all combinations

(: powerset (-> Expression Number Bool Expression))
(= (powerset $set $n $exact)
   (if (== $n 0)
       (()) 
       (let* (($ps (powerset $set (- $n 1) $exact))
              ($new (collapse 
                       (let $subset (superpose $ps)
                         (let $el (superpose $set)
                           (if (== (isMember $el $subset) False)
                               (cons-atom $el $subset)
                               (Empty))))))
              ($filteredNew (unyque $new ()))
              ($res  (if (== $exact False)
                        (union-atom $filteredNew $ps)
                        $filteredNew)))
             $res )))

;; set -- changes tuples into set             
(: set (-> Expression Expression Expression))
(= (set $expr $acc)
    (if-decons-expr $expr $h $t
        (let $carry (union-atom $acc ($h))
            (let $rest (collapse 
                (let $h-s (superpose $t)
                    (if (isEqual $h-s $h)
                        (Empty)
                        $h-s))) 
                (set $rest $carry)))
        $acc))             