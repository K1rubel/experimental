(: Pair (-> $a $b Type))
(: mkPair (-> $a $b (Pair $a $b)))

;; Types, constructors and functions related to instance.
(: Cscore Type)
(: Instance Type)

(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

(: mkCscore (-> Number Number Number Number Number Cscore))

;; An instance is just a vector of numbers
(: Instance Type)
(: mkInst (-> (List Number) Instance))
! (get-type (mkInst (Cons 1 Nil)))
;; A scored instance is just a pair of instance and it's score.
;; (: ScoredInstance (-> $score Type))
(: ScoredInstance (-> $score Type))
(: mkSInst (-> (Pair Instance $score) (ScoredInstance $score)))
! (get-type (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5)))
;; An instance set is a list of scored instances.
(: InstanceSet (-> $score Type))
(: mkSInstSet (-> (List (ScoredInstance $score)) (InstanceSet $score)))

! (mkSInstSet (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) Nil))
! (get-type (mkSInstSet (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) Nil)))
; Compare penalized scores.  That is, we compare score-penalty
; on the right to score-penalty on the left. If the 2
; score-penalty qre equal then we compare by complexity
; (decreasing order, as complexity is positive). We do that in
; case no score penalty has been set.

; Additionally we assume that nan is always smaller than
; anything (including -inf) except nan


(= (List.sort Nil) Nil)
(= (List.sort (Cons ($inst $cScore) $rest))
    (List.insert ($inst $cScore) (List.sort $rest)))

(= (List.insert ($inst $cScore) Nil) (Cons ($inst $cScore) Nil))
(= (List.insert ($inst1 $cScore1) (Cons ($inst2 $cScore2) $rest))
    (if (cScore< $cScore1 $cScore2)
        (Cons ($inst2 $cScore2) (Cons ($inst1 $cScore1) $rest))
        (Cons ($inst1 $cScore1) (List.insert ($inst2 $cScore2) $rest))))

(: getPenScore (-> Cscore Number))
(= (getPenScore (mkCscore $scor $cpxy $complexityPenalty $uniformityPenalty $penalizedScore)) $penalizedScore)
(= (getScore (mkCscore $scor $cpxy $complexityPenalty $uniformityPenalty $penalizedScore)) $scor)
(= (getComp (mkCscore $scor $cpxy $complexityPenalty $uniformityPenalty $penalizedScore)) $cpxy)
(= (getCompPen (mkCscore $scor $cpxy $complexityPenalty $uniformityPenalty $penalizedScore)) $complexityPenalty)
(= (getUniPen (mkCscore $scor $cpxy $complexityPenalty $uniformityPenalty $penalizedScore)) $uniformityPenalty)

! (bind! nan (py-atom math.nan))
! (bind! nInf (py-atom "float('-inf')")) ;; negative infinity
! (bind! pInf (py-atom "float('inf')")) ;; positive infinity

;; comparing composite scores
;; cScore< -- composite score less than operator
;; uses penalized scores to compare and complexity score to break ties in the penalized score
;; $csl -- composite score of the left side instance ..
;; $csr -- composite score of the right side instance or whatever

(: cScore< (-> Cscore Cscore Bool)) 
(= (cScore< $csl $csr)
    (let ($pl $pr $cl $cr) ((getPenScore $csl) (getPenScore $csr) (getComp $csl) (getComp $csr))
        (if (type-cast (isnan-math $pl) Bool &self)
            (not (isnan-math $pr))
            (or (< $pl $pr) (and (== $pl $pr) (> $cl $cr))))))

! (cScore< (mkCscore -2 3 1.2 0.0 -3.4) (mkCscore -2 3 1.2 0.0 -3.2))            
! (cScore< (mkCscore -2 4 1.2 0.0 -3.4) (mkCscore -2 3 1.2 0.0 -3.4))            

;; Check for equality, to within floating-point error, EPSILON
! (bind! EPSILON (pow-math 10 -6))
(: cScore== (-> Cscore Cscore Bool))
(= (cScore== $csl $csr)
    (let ($sL $cL $cpL $upL $pL $sR $cR $cpR $upR $pR) 
            ((getScore $csl) (getComp $csl) (getCompPen $csl) (getUniPen $csl) (getPenScore $csl)
            (getScore $csr) (getComp $csr) (getCompPen $csr) (getUniPen $csr) (getPenScore $csr)) 
        
            (and (isApproxEq $sL $sR) 
                (and (isApproxEq $cL $cR) 
                    (and (isApproxEq $cpL $cpR) 
                        (and (isApproxEq $upL $upR) (isApproxEq $pL $pR)))))))

(: isApproxEq (-> Number Number Bool))
(= (isApproxEq $x $y)
    (let $diff (abs-math (- $x $y))
        (if (< $diff EPSILON)
            True
            (let $amp (abs-math (+ $x $y))
                (<= $diff (* EPSILON $amp))))))

! (cScore< (mkCscore -2 4 1.2 0.0 -3.4) (mkCscore -2 3 1.2 0.0 -3.4))            
; (: List.sort (-> (List $a) (List $a)))
; (= (List.sort Nil) Nil)
; (= (List.sort (Cons $head $tail)) (List.insert $head (List.sort $tail)))

; (= (List.insert $x Nil) (Cons $x Nil))
; (= (List.insert $x (Cons $head $tail))
;    (if (< $x $head)
;        (Cons $x (Cons $head $tail))
;        (Cons $head (List.insert $x $tail))))

! (List.sort (Cons (A (mkCscore -2 4 1.2 0.0 -3.4)) (Cons (B (mkCscore -2 3 1.2 0.0 -3.4)) Nil) ))
; ! (List.sort (Cons 1 (Cons 2 Nil)))
; ! (mkSInstSet (Cons (mkSInst (Pair (Cons 1 (Cons 2 Nil)) (mkCscore 1 2 3 4 5))) Nil))
! (mkSInstSet (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))) Nil))
! (get-type (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 2 3 4 5))))