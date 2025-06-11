! (register-module! ../../experimental)
! (import! &self experimental:merge-deme:sort-demes:sort_demes)
! (import! &self experimental:list:type)
! (import! &self experimental:crossover:helpers)
! (import! &self experimental:crossover:partial-sort)

;; Cross the single top-scoring instance against the next-highest scorers.
;; 
;; As arguments, accepts a range of scored instances ("the sample"),
;; and a single instance from which these were all derived ("the base"
;; or center instance). This will create a number of new instances,
;; which will be a cross of the highest-scoring instance with the
;; next-highest scoring instances.

;; crossTopOne -- 

(: crossTopOne (-> Deme Number Number Number Instance Deme))
(= (crossTopOne $deme $nToMake $sampleStart $sampleSize $baseInstance) 
    (if (< (- $sampleSize 1) $nToMake)
        (crossTopOne $deme $demSize (- $sampleSize 1) $sampleStart $sampleSize $baseIstance)
        (let* (((mkDeme (mkRep (mkKbMap $dscKbMp (mkDscMp $dscMp)) $tree) (mkSInstSet $instSet) $demeId) $deme)
                ((Cons $reference $rest) (List.partialSort instance>= $instSet $nToMake Nil)) ;; deconstruct the partial sorted set of instances into the reference and the rest and take the next N values from the rest for crossover
                ($targetInstances (List.takeN (- $nToMake 1) $rest))
                ($targetExpr (List.listToExpr $targetInstances))
                ((mkSInst (mkPair $referenceInst $referenceScore)) $reference)
                ($newInstances (merger $targetExpr $baseInstance $referenceInst)))
                
                (mkDeme (mkRep (mkKbMap $dscKbMp (mkDscMp $dscMp)) $tree) (mkSInstSet (List.appendList (exprToList $newInstances) $instSet)) $demeId))))
                
((mkSInst (mkPair (mkInst (Cons 2 Nil)) (mkCscore 1 2 3 4 4))) (mkSInst (mkPair (mkInst (Cons 3 Nil)) (mkCscore 1 2 3 4 3))))            
(= (merger $targetInstances $baseInst $referenceInst)
    (collapse (let* (((mkSInst (mkPair $targetInst $score)) (superpose $targetInstances))) 
        (mkSInst (mkPair (mergeInstance $targetInst $baseInst $referenceInst) (worstCscore))))))

       
! (bind! deme1 
        (mkDeme (mkRep (mkKbMap 1 (mkDscMp 2)) 
                (mkTree (mkNode A) Nil)) 
                    (mkSInstSet (Cons (mkSInst (mkPair (mkInst (Cons 5 Nil)) (mkCscore 1 2 3 4 1))) 
                        (Cons (mkSInst (mkPair (mkInst (Cons 3 Nil)) (mkCscore 1 2 3 4 3))) 
                            (Cons (mkSInst (mkPair (mkInst (Cons 2 Nil)) (mkCscore 1 2 3 4 4)))
                                (Cons (mkSInst (mkPair (mkInst (Cons 4 Nil)) (mkCscore 1 2 3 4 2))) 
                                    (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) 
                                        (Cons (mkSInst (mkPair (mkInst (Cons 10 Nil)) (mkCscore 1 2 3 4 0.5))) 
                                            (Cons (mkSInst (mkPair (mkInst (Cons 12 Nil)) (mkCscore 1 2 3 4 0.25))) 
                                                (Cons (mkSInst (mkPair (mkInst (Cons 15 Nil)) (mkCscore 1 2 3 4 0.15))) Nil))))))))) "1"))

! (crossTopOne deme1 3 0 4 (mkInst (Cons 6 Nil)))    

! (get-type (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) (Cons (mkSInst (mkPair (mkInst (Cons 3 Nil)) (mkCscore 1 2 3 4 3))) (Cons (mkSInst (mkPair (mkInst (Cons 2 Nil)) (mkCscore 1 2 3 4 4))) (Cons (mkSInst (mkPair (mkInst (Cons 4 Nil)) (mkCscore 1 2 3 4 2))) (Cons (mkSInst (mkPair (mkInst (Cons 5 Nil)) (mkCscore 1 2 3 4 1))) Nil))))))
! (let* (($a ((mkSInst (mkPair (mkInst (Cons 2 Nil)) (mkCscore 1 2 3 4 4))) (mkSInst (mkPair (mkInst (Cons 3 Nil)) (mkCscore 1 2 3 4 3)))))
        ((mkSInst (mkPair $inst $score)) (superpose $a)))
        $inst)
