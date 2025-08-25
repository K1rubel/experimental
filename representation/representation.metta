(: DiscMap Type)   
(: DiscKnobMap Type)
(: mkDscMp (-> (MultiMap (DiscSpec $knob)) DiscMap))
(: mkDscKbMp (-> (Map (NodeId Number)) DiscKnobMap))
(: KnobMap Type)
(: mkKbMap (-> DiscKnobMap DiscMap KnobMap))
(: Representation Type)
(: mkRep (-> KnobMap (Tree $a) Representation)) 

;; helper function to representation
;; Converts DiscMap (multimap of knobSpec & knob) to DiscKnobMap (map of location & index)
;; Params: DiscMap
;; Returns: DiscKnobMap
(: crtDiscKnobMap (-> DiscMap DiscKnobMap Number DiscKnobMap))
(= (crtDiscKnobMap (mkDscMp NilMMap) (mkDscKbMp $dkm) $index) (mkDscKbMp $dkm))
(= (crtDiscKnobMap (mkDscMp (ConsMMap ($kbSpec $kb) $tail)) (mkDscKbMp $dkm) $index)
   (let*
   (
    ($loc (getKnobLoc $kb))
    ($updatedDkm (Map.insert ($loc $index) $dkm == nodeId<))
   ) 
   (crtDiscKnobMap (mkDscMp $tail) (mkDscKbMp $updatedDkm) (+ $index 1))
  ))

;; representation constructor
;; Params: Tree (Exemplar)
;;         $argLabels: list of argument labels (input variables) from the ITable
;; Returns: Representation
; (: representation (-> (Tree $a) Expression Representation))
; (= (representation $exemplar $argLabels)
; (let*
; (
;     (($updatedTree $dscMp) (buildKnobs $exemplar NilMMap $argLabels))
;     ($dscKbMp (crtDiscKnobMap (mkDscMp $dscMp) (mkDscKbMp NilMap) 0))
; )   
; (mkRep (mkKbMap $dscKbMp (mkDscMp $dscMp)) $updatedTree)
; ))

(: representation (-> (Tree $a) (ITable $a) Symbol bool Expression Expression))
(= (representation 
            $exemplar                   ;; tree around which multiple representations are to be built
            (mkITable $table $labels)   ;; table from which to select features and base the representations with
            $ft-selection-algo          ;; feature selection algorithm to be used -- symbol 
            $prune-exemplar             ;; bool to decide to prune the exemplar or keep the exemplar as is
            $enforced-fts               ;; set of features to be enforced in to selected features
        )
        
        (let*   (($exemplar-fts (treeFtsIndices $exemplar $labels))           ;; exemplarFtsIndices function in deme/expand-deme.metta
                 ($all-labels (getInputLabels $labels))                       ;; getInputLabels in deme/expand-deme.metta
                 ($selected-fts-pop (featureSelector $ft-selection-algo (mkITable $table $labels) 0.0 $exemplar 2 2 False () False 2 False ja 2)))     ;; applies the right parameteres for feature selection based on selected selection algorithm 
               ;   ($selected-ft-sets (map-atom $selected-fts-pop $selected-ft-set (second $selected-ft-set)))         ;; just set of selected features without their scores
               ;   ($diff-fts (map-atom $selected-fts-pop $selected-ft-set (subtraction-atom $exemplar-fts $selected-ft-set))) ) $diff-fts))    ;; set of features in exemplar but not selected during feature selection for pruning
               ;  ;  ($exemplar-seq (if $prune-exemplar
               ;  ;                     (map-atom $diff-fts $diff-ft (pruneExemplar $exemplar $diff-ft))                             ;; set of exemplars which have been pruned
               ;  ;                     (map-atom $selected-ft-sets $selected-ft-set (union-atom $exemplar-fts $selected-ft-set))))  ;; include exemplar features in the selected feature set
               ;  )
               
                (if $prune-exemplar
                    (let* (($diff-fts (map-atom $selected-fts-pop $selected-ft-set (subtraction-atom $exemplar-fts $selected-ft-set)))                 ;; selected features without exemplar features
                            ($exemplar-seq (map-atom $diff-fts $diff-ft (let $ft-names (fsToNames $labels $diff-ft) (pruneExemplar $exemplar $ft-names)))) 
                            ($used-ft-sets (map-atom $selected-fts-pop $selected-ft-set (subtraction-atom $selected-ft-set $exemplar-fts))) 
                            ($arg-sets (if (== $enforced-fts ())
                                             (map-atom $used-ft-sets $used-ft-set (fsToNames $labels $used-ft-set)) ;; .. ))) $arg-sets) ..)))
                                             (let $sampled-enforced-fts (sampleEnforcedFts $enforced-fts $labels) $sampled-enforced-fts) .. ))) $arg-sets) ..)))           ;; from feature-selection/select-top-features.metta)
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
(: getCandidate (-> Representation Instance (Tree $a)))
(= (getCandidate $repObj $inst)
   (trace! (Converting instance: $inst to tree) (chain (getCandidateRec $repObj $inst (mkNodeId (0)) (mkNodeId (0)) (mkNullVex Nil)) $candidate
    (cleanTree $candidate))))
     ;; (trace! (Done converting instance to tree $candidate) $candidate))))

;; Assumes the reverseLookupTable's order never changes during this call.
(: getCandidateRec (-> Representation Instance NodeId NodeId (Tree $a) (Tree $a)))
(= (getCandidateRec (mkRep $knobMapObj $tree) (mkInst $inst) $parentId $srcId $candidate)
   ;; Find the knob associated with src (if any)
   (chain (findDiscKnob $knobMapObj $srcId) $knobIdxPair
      (if (~= (second $knobIdxPair) -1)
          (chain (List.getByIdx $inst (second $knobIdxPair)) $d
          (chain (appendTo $tree (first $knobIdxPair) $candidate $parentId $d) $updatedCnd

          ;; The C++ version needs to call the getCandidateRec 
          ;;  on the newly added node of the candidate but we 
          ;;  already took care of that addition using the appendTo
          ;;  function. Therefore that part is ommited here.
          $updatedCnd))

         ;; No knob found. Just copy.
         (chain (getNodeById $tree $srcId) $src ;; Get node value using id
         (chain (appendChild $candidate $parentId (mkTree (getNodeValue $src) Nil)) $cndChIdPair ;; AppendChild returns a pair of tree and appended child Id
         (chain (getChildren $src) $srcChildren
         (chain (List.foldl applyGetCandidateRec ((mkRep $knobMapObj $tree) (mkInst $inst) (second $cndChIdPair) (first $cndChIdPair) 1) $srcChildren) $state
            (let ((mkRep $knobMapObj $tree) (mkInst $inst) $newParentId $finalCnd $_) $state $finalCnd)))))))
)


(: applyGetCandidateRec (-> (Tree $a)
                            (Representation Instance NodeId (Tree $a) Number)
                            (Representation Instance NodeId (Tree $a) Number)))
(= (applyGetCandidateRec $_ ($repObj $inst (mkNodeId $parentId) $candidate $chIdx))
   (chain (if (== $parentId (0)) (mkNodeId ($chIdx)) (mkNodeId (unionAtom $parentId ($chIdx)))) $srcId ;; Skip 0 from tree id.
   (chain (getCandidateRec $repObj $inst (mkNodeId $parentId) $srcId $candidate) $updatedCnd
      ($repObj $inst (mkNodeId $parentId) $updatedCnd (+ 1 $chIdx)))))


