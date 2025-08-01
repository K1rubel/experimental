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
