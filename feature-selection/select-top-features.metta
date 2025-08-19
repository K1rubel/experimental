;; select top features -- based on value of diversity pressure parameter
;;          $ft-set         -- feature set from feature selection algos
;;          $div-pres       -- diversity pressure parameter
;;XXX --- this implementation requires the feature sets to come with their MI score

(= (selectTopFts $div-pres $multi-diversity $sim-scorer $ft-set $nDeme)
    (chain (size-atom $ft-size) $fts-size 
        (chain (min-atom ($fts-size $nDeme)) $res-size 
            (if (> $div-pres 0)
                (let $ranked-set (rankFtSet $div-pres $multi-diversity $sim-scorer $ft-set $ft-set)
                    (takeN $res-size $ranked-set))
                (takeN $res-size $ft-set)))))

;;            
;;     $csc-ft-set -- composite scored feature set  
;; XXX -- asumption is that the input feature sets are sorted according to the raw score 
;;      $sim-scorer -- either jacaard or mi
(= (rankFtSet $div-pres $multi-diversity $sim-scorer $ft-set $ft-set $acc)
    ;; convert each feature set into composite scoreed set -- 
    (let $csc-ft-set 
        (map-atom $ft-sets $ft-set ((mkCscore (first $ft-set) (let $set (second $ft-set) (size-atom $set)) 0.0 0.0 (first $ft-set)) (second $ft-set)))
            (rankIterator $div-pres $multi-diversity $sim-scorer $csc-ft-set $acc)))

(= (rankIterator $div-pres $multi-diversity $sim-scorer $csc-ft-set $acc)
    (if (== $acc ())
        (rankIterator $div-pres $multi-diversity $sim-scorer (cdr-atom $csc-ft-set) ((car-atom $csc-ft-set))) ;; add the first feature -- since this is the one with the best raw score
        (if (== $csc-ft-set ())
            $acc
            (let* (($current-ft-set (car-atom $csc-ft-set))
                    ($last-ft-set (car-atom $acc))
                    ($current-cscore (first $current-ft-set))
                    ($current-ft (second $current-ft-set))
                    ($last-cscore (first $last-ft-set))
                    ($last-ft (second $last-ft-set))
                    ($sim (if (== $sim-scorer ja)
                                (jaccardIndex $last-ft $current-ft)
                                (...)            ;; calculation of feature set similarity uisng mutual infomration
                            )) 
                    ($last-dp (simToPen $sim $div-pres))      ;; the latest diversity penality
                    ($current-unipen-score (getUniPen $current-cscore))
                    ($agg-dp (max-atom ($last-dp $current-unipen-score)))
                    ($updated-uniPen-score (setUniPen $current-cscore $agg-dp))
                    ($updatd-pen-score (updatePenalizedScore $updated-uniPen-score $multi-diversity))
                    ($new-acc (insertPair cScore>= ($updatd-pen-score $current-ft) $acc)))

                (rankIterator $div-pres $multi-diversity $sim-scorer (cdr-atom $csc-ft-set) $new-acc)))))

;; csc_featureset less than function
(= (cscFtSet< (mkCscore $sl $cl $cpl $upl $psl) (mkCscore $sr $cr $cpr $upr $psr)))            


(= (setUniPen (mkCscore $scor $cpxy $complexityPenalty $uniformityPenalty $penalizedScore) $newUniPen)
    (mkCscore $scor $cpxy $complexityPenalty $newUniPen $penalizedScore))
;; simToPen similarity to penality                    
(= (simToPen $sim $div-pres)
    (* $sim $div-pres))
;; imported for the purpose of test
(= (first ($a $b)) $a)        
(= (second ($a $b)) $b)       

;; testing rankFtSet
; ! (rankFtSet ((0.3 (1 2 3)) (0.4 (3 1))) ())     

; ! (setUniPen (mkCscore 1 2 4 5 6) 423)