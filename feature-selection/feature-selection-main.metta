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
            $algo               ;; feature selection algo one of the following symbols hc, rnd, sim, inc, smd for hillclimbing, random, simple, incremental and stochasticMaxDependency selection algos
            (mKITable $table $labels)   ;; the table
            $th                 ;; score threshold (MI for instance)
            $exemplar           ;; the exemplar tree
            $diversity-cap      ;; cap on population of feature sets
            $target-size        ;; number of features in a feature set
            $init-xmplr-fts     ;; bool to determine to use exemplar features as initial features or not
            $init-fts           ;; initial features specified list of symbols -- column labels
            $ignore-xmplr-fts   ;; bool dictating whether to/not ignore exemplar features in feature selection
            $div-pres           ;; diversity pressure -- XXX more explanation 
            $multi-diversity    ;; multiply diversity -- used when updating the penalized score
            $sim-scorer         ;; feature set similarity scorer either mi or jaccard
            $nDeme)             ;; number of demes to spawn
            
        (let* (($exemplar-fts (treeFtsIndices $exemplar $labels))
                ($exemplar-fts-size (size-atom $exemplar-fts))
                ($init-ft-indices (map-atom $init-ft $ft (List.index $labels $ft)))                 ;; initial ft names changed into index values

                ($ft-set-pop (if $init-xmplr-fts                                                    ;; if the featue selection is to be initialized with exemplar features
                                (let* (($updated-init-fts (union-atom $init-fts $exemplar-fts))     ;; include exemplar featues in the init features list(tuple)
                                        ($updated-target-size (+ $target-size $exemplar-fts-size))  ;; target size also should be upped
                                        ($updated-init-fts (union-atom $init-ft-indices $exemplar-fts)))

                                        (featureSelection $algo (mKITable $table $labels) $th $updated-target-size $updated-init-fts))     ;; do the feature selection using the new target-size
                                        
                                        (if $ignore-exemplar-fts                                                        ;; on the other hand, if we elect to ignore exemplar features 
                                            (let $filtered-table (filterTable $exemplar-fts (mkITable $table $labels))   ;; filter the table and pass only labels that don't include exemplar features
                                                (featureSelection $algo $filtered-table $th $target-size $init-ft-indices))
                                            (featureSelection $algo (mKITable $table $labels) $th $target-size $init-ft-indices))))
                ($ft-set-pop-size (size-atom $ft-set-pop))                            
                ($capped-ft-set-pop (if (and (> $diversity-cap 0) (< $diversity-cap $ft-set-pop-size))                  ;; limmit the size of feature set pop to diversity cap value
                                        (takeN $diversity-cap $ft-set-pop)
                                        $ft-set-pop)))

                (selectTopFts $div-pres $multi-diversity $sim-scorer $capped-ft-set-pop $nDeme)))                       ;; select top features out of set of selected features after applying uniformity penality 

(= (featureSelection    ;; for sake of clarity I chose to list the parameteres top-down style
            $algo
            (mkITable $table $labels)
            $th             ;; threshold for simle, smd ..
            $target-size    ;; desired number of features in a set   
            $init-fts       ;; indices of initial features -- ne
            ) 
	(case $algo
		((hc (hillclimbing ))
		 (rnd (randomFeatureSelection (mkITable $table $labels) $num-desired))                                       
		 (sim (simpleFeatureSelector $th $num-desired (mkITable $table $labels) ()))                           ;; False -- default value for using exp distribution for selection of top N features -- and start with empty feature list as initial features -- th here refers to the minimum score required for feature set to be selected
		 (inc (incrementatl .. ))
		 (smd   (if (== $init-fts ())
                    (stochasticMaxDependency $th $feature-count $num-desired (mKITable $table $labels) mi ())
                    (let* (($len (List.length $labels))
                            ($oc (Table.getColumn (- $len 1) $table))      ;; output column to calculate MI for initial ft set
                            ($init-ft-zip (zipColumn $init-fts $table))    ;; 
                            ($mi (mutualInformation $init-ft-zip $oc)))
                            
                            (stochasticMaxDependency $th $feature-count $num-desired (mKITable $table $labels) mi ($mi $init-fts)))))          ;; this `th` is a vlue used to check marginal score improvements as a features are added to the set. feature-count refers to the number of features in a single feature set
		)))  