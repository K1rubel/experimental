;; the c++ version starts logging feature selection options 
;; reads in the data table
;; checks if subsampling ratio is < 1 ===> if so do a subsampling -> subsampleTable
;; the sub sampler -- just removes a number of rows from the input table by random
;; this is done to reduce a potentailly large data into managable size
;; nrow -- to be removed
;; 
(= (subsampleTable $nrow $table)
    (let $t-size (List.length $table)
        (subSampleHelper $nrow $t-size $table)))

;; helper -- subSampleHelper
(= (subSampleHelper $nrow $t-size $table)
    (if (== $t-size $nrow)
        $table
        (let* (($row-index (random-int 0 $t-size))
                ($new-table (List.pop $row-index $table)))
            (subSampleHelper $nrow (- $t-size 1) $new-table ))))
    
;; then get the singature type of the table and  go for the feature selection
;; result of feature selection is a set of features with the highest scores
;; 

;; can a dorepeat kind of function be defined for metta/log

; (: until (-> (-> $a Bool) (-> $a $a) $a $a))
; (= (until $predicate $function $x) (if ($predicate $x) $x (let $x' ($function $x) (until $predicate $function $x'))))

(= (featureSelector 
            $algo               ;; feature selection algo
            (mKITable $table $labels)   ;; the table
            $exemplar           ;; the exemplar tree
            $diversity-cap      ;; cap on population of feature sets
            $target-size        ;; number of features in a feature set
            $init-xmplr-fts     ;; bool to determine to use exemplar features as initial features or not
            $init-fts           ;; initial features specified list of symbols -- column labels
            $ignore-xmplr-fts   ;; bool dictating whether to/not ignore exemplar features in feature selection
            $div-pres           ;; diversity pressure -- XXX more explanation 
            $multi-diversity    ;; multiply diversity 
            $sim-scorer         ;; feature set similarity scorer either mi or jaccard
            $nDeme              ;; number of demes to spawn
            
        )
        ;; include result of preprocess params here -- 
        ;; call the feature selector to return multiple feature sets with scores associated 
        ;; cap the feature set pop size
        ;; select top features -- entails sim penality --
        (let* (($exemplar-fts (exemplarFtsIndices $exemplar $labels))
                ($exemplar-fts-size (size-atom $exemplar-fts))

                ($ft-set-pop (if $init-xmplr-fts
                                (let* (($updated-init-fts (union-atom $init-fts $exemplar-fts))
                                        ($updated-target-size (+ $target-size $exemplar-fts-size))) 

                                        (featureSelection $algo (mKITable $table $labels) $updated-target-size ..))
                                        (if $ignore-exemplar-fts 
                                            (let $filtered-table (filterTable $exemplar-fts (mkITable $table $labels))          ;; filter the table and pass only labels that don't include exemplar features
                                                (featureSelection $algo $filtered-table $target-size ..))
                                            (featureSelection $algo (mKITable $table $labels) $target-size ..))))
                ($ft-set-pop-size (size-atom $ft-set-pop))                            
                ($capped-ft-set-pop (if (and (> $diversity-cap 0) (< $diversity-cap $ft-set-pop-size))
                                        (takeN $diversity-cap $ft-set-pop)
                                        $ft-set-pop)))
                (selectTopFts $div-pres $multi-diversity $sim-scorer $capped-ft-set-pop $nDeme)    
                                    ))

(= (featureSelection $algo) 
	(case $algo
		((hc (hillclimbing ))
		 (rnd (random ))
		 (sim (simple ..))
		 (inc (incrementatl))
		 (smd (stochasticMaxDependency ))
		)))
