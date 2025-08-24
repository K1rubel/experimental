 ;; representation constructor
;; Params: Tree (Exemplar)
;;         $argLabels: list of argument labels     (input variables) from the ITable
;; Returns: Representation
(: representation (-> (Tree $a) Expression Representation))
(= (representation $exemplar $argLabels)
(let*
(
    (($updatedTree $dscMp) (buildKnobs $exemplar NilMMap $argLabels))
    ($dscKbMp (crtDiscKnobMap (mkDscMp $dscMp) (mkDscKbMp NilMap) 0))
 )
 (mkRep (mkKbMap $dscKbMp (mkDscMp $dscMp)) $updatedTree)
 ))
(: representation (-> (Tree $a) (ITable $a) Symbol bool Expression Expression))
(= (representation 
            $exemplar                   ;; tree around which multiple representations are to be built
            (mKITable $table $labels)   ;; table from which to select features and base the representations with
            $ft-selection-algo          ;; feature selection algorithm to be used -- symbol 
            $prune-exemplar             ;; bool to decide to prune the exemplar or keep the exemplar as is
            $enforced-fts               ;; set of features to be enforced in to selected features
        )
        
        (let*   (($exemplar-fts (treeFtsIndices $exemplar $labels))       ;; exemplarFtsIndices function in deme/expand-deme.metta
                 ($all-labels (getInputLabels $labels))                       ;; getInputLabels in deme/expand-deme.metta
                 ($selected-fts-pop (featureSelection $ft-selection-algo))     ;; applies the right parameteres for feature selection based on selected selection algorithm 
                 ($selected-ft-sets (map-atom $selected-fts-pop $selected-ft-set (second $selected-ft-set)))         ;; just set of selected features without their scores
                ;  ($diff-fts (map-atom $selected-ft-sets $selected-ft-set (subtraction-atom $exemplar-fts $selected-ft-set)))     ;; set of features in exemplar but not selected during feature selection for pruning
                ;  ($exemplar-seq (if $prune-exemplar
                ;                     (map-atom $diff-fts $diff-ft (pruneExemplar $exemplar $diff-ft))                             ;; set of exemplars which have been pruned
                ;                     (map-atom $selected-ft-sets $selected-ft-set (union-atom $exemplar-fts $selected-ft-set))))  ;; include exemplar features in the selected feature set
                )
                (if $prune-exemplar
                    (let* (($diff-fts (map-atom $selected-ft-sets $selected-ft-set (subtraction-atom $exemplar-fts $selected-ft-set)))  ;; selected features without exemplar features
                            ($exemplar-seq (map-atom $diff-fts $diff-ft (pruneExemplar $exemplar $diff-ft)))
                            ($used-ft-sets (map-atom $selected-ft-sets $selected-ft-set (subtraction-atom $selected-ft-set $exemplar-fts)))
                            ($arg-sets (if (== $enforced-fts ())
                                             (map-atom $used-ft-sets $used-ft-set (fsToNames $used-ft-set $labels))
                                             (let $sampled-enforced-fts (SampleEnforcedFts $enforced-fts $labels)            ;; from feature-selection/select-top-features.metta)
                                                (map-atom $used-ft-sets $used-ft-set 
                                                        (let $args (fsToNames $used-ft-set $labels) (union-atom $sampled-enforced-fts $args)))))
                            ($exemplar-arg-seq (one2one $exemplar-seq $arg-sets)))
                        
                            (collapse 
                                (let* ((($xmplr $argLabels) (superpose $exemplar-arg-seq))
                                        (($updatedTree $dscMp) (buildKnobs $xmplr NilMMap $argLabels))
                                        ($dscKbMp (crtDiscKnobMap (mkDscMp $dscMp) (mkDscKbMp NilMap) 0)))

                                        (mkRep (mkKbMap $dscKbMp (mkDscMp $dscMp)) $updatedTree)))))

                    (let* (($used-ft-sets (map-atom $selected-ft-sets $selected-ft-set (union-atom $selected-ft-set $exemplar-fts)))
                            ($final-ft-sets (if (== $enforced-fts ())
                                                (map-atom $used-ft-sets $used-ft-set (fsToNames $used-ft-set $labels))
                                                (let $sampled-enforced-fts (SampleEnforcedFts $enforced-fts $labels)            ;; from feature-selection/select-top-features.metta
                                                    (map-atom $used-ft-sets $used-ft-set 
                                                        (let $args (fsToNames $used-ft-set $labels) (union-atom $sampled-enforced-fts $args))))))
                            ($exemplar-arg-seq (map-atom $fina-ft-sets $final-ft-set ($exemplar $final-ft-set))))
                        
                            (collapse 
                                (let* ((($xmplr $argLabels) (superpose $exemplar-arg-seq))
                                        (($updatedTree $dscMp) (buildKnobs $xmplr NilMMap $argLabels))
                                        ($dscKbMp (crtDiscKnobMap (mkDscMp $dscMp) (mkDscKbMp NilMap) 0)))

                                        (mkRep (mkKbMap $dscKbMp (mkDscMp $dscMp)) $updatedTree)))))))