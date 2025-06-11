; ! (register-module! ../../experimental)
; ! (import! &self experimental:merge-deme:sort-demes:sort_demes)
; ! (import! &self experimental:list:type)
; ! (import! &self experimental:crossover:helpers)


; (: partialSortHelper (-> (List Number) Number (List Number) (List Number)))
; (= (partialSortHelper Nil $_ $acc) $acc)
; (= (partialSortHelper $lst 0 $acc) $acc)
; (= (partialSortHelper $lst $n $acc)
;     (let* (($maxVal (List.max $lst))
;            ($rest (List.delete $maxVal $lst)))
;       (partialSortHelper $rest (- $n 1) (List.prepend $maxVal $acc))))

; ;; Partially sorts a list of numbers by selecting top 'n' largest values and placing them at the front,
; ;; leaving the remaining elements unsorted.
; (: List.partialSort (-> (List Number) Number (List Number)))
; (= (List.partialSort $xs $n)
;     (if (< $n 0)
;         (Error Nil "Invalid argument: n must be >= 0")
;         (let* (($sortedTop (partialSortHelper $xs $n Nil))
;                ($usedElems $sortedTop)
;                ($remaining (List.diff $xs $usedElems)))
;           (List.appendList $remaining $sortedTop))))
          
; ;; Removes one occurrence of each element in 'ys' from 'xs'
; (: List.diff (-> (List Number) (List Number) (List Number)))
; (= (List.diff $xs Nil) $xs)
; (= (List.diff $xs (Cons $y $ys))
;     (List.diff (List.delete $y $xs) $ys)) 

    
; ! (List.partialSort (Cons 5 (Cons 1 (Cons 8 (Cons 3 Nil)))) 2)
; ! (List.partialSort (Cons 5 (Cons 1 (Cons 8 (Cons 3 (Cons 4 Nil))))) 2)          

;; Implementation of sorting algorithms for scored instance sets
;; Based on example-sorting-task.metta

;; First, let's define all the necessary types from the example
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

(: Size Type)
(: mkSize (-> Number Size))

(: Instance Type)
(: mkInst (-> (List Number) Instance))

(: Pair (-> $a $b Type))
(: mkPair (-> $a $b (Pair $a $b)))

(: Cscore Type)
(: mkCscore (-> Number Number Cscore))

(: ScoredInstance (-> $score Type))
(: mkSInst (-> (Pair Instance $score) (ScoredInstance $score)))

(: InstanceSet (-> $score Type))
(: mkSInstSet (-> (List (ScoredInstance $score)) (InstanceSet $score)))

;; Helper functions
;; Extract the score from a ScoredInstance
(: getScore (-> (ScoredInstance Cscore) Cscore))
(= (getScore (mkSInst (mkPair $inst $score)))
   $score)

;; Extract the second component of a Cscore
(: getScoreValue (-> Cscore Number))
(= (getScoreValue (mkCscore $x $y))
   $y)

;; Get the score value from a ScoredInstance
(: getScoreVal (-> (ScoredInstance Cscore) Number))
(= (getScoreVal $sinst)
   (getScoreValue (getScore $sinst)))

;; Length of a list
(: len (-> (List $a) Number))
(= (len Nil) 0)
(= (len (Cons $x $xs))
   (+ 1 (len $xs)))

;; Bubble Sort Implementation
;; Swap two elements if they are in the wrong order
(: bubbleSwap (-> (ScoredInstance Cscore) (ScoredInstance Cscore) (Pair (ScoredInstance Cscore) (ScoredInstance Cscore))))
(= (bubbleSwap $a $b)
   (if (> (getScoreVal $a) (getScoreVal $b))
       (mkPair $b $a)
       (mkPair $a $b)))

;; One pass of bubble sort
(: bubblePass (-> (List (ScoredInstance Cscore)) (List (ScoredInstance Cscore))))
(= (bubblePass Nil) Nil)
(= (bubblePass (Cons $x Nil)) (Cons $x Nil))
(= (bubblePass (Cons $x (Cons $y $rest)))
   (let $swapped (bubbleSwap $x $y)
        (let $first (car $swapped)
             (let $second (cdr $swapped)
                  (Cons $first (bubblePass (Cons $second $rest)))))))

;; Complete bubble sort
(: bubbleSort (-> (List (ScoredInstance Cscore)) (List (ScoredInstance Cscore))))
(= (bubbleSort $list)
   (if (<= (len $list) 1)
       $list
       (bubbleSort (bubblePass $list))))

;; Bubble sort for InstanceSet
(: bubbleSortInstanceSet (-> (InstanceSet Cscore) (InstanceSet Cscore)))
(= (bubbleSortInstanceSet (mkSInstSet $list))
   (mkSInstSet (bubbleSort $list)))

;; Merge Sort Implementation
;; Split a list into two halves
(: splitList (-> (List $a) (Pair (List $a) (List $a))))
(= (splitList Nil) (mkPair Nil Nil))
(= (splitList (Cons $x Nil)) (mkPair (Cons $x Nil) Nil))
(= (splitList (Cons $x (Cons $y $rest)))
   (let $split (splitList $rest)
        (let $left (car $split)
             (let $right (cdr $split)
                  (mkPair (Cons $x $left) (Cons $y $right))))))

;; Merge two sorted lists
(: merge (-> (List (ScoredInstance Cscore)) (List (ScoredInstance Cscore)) (List (ScoredInstance Cscore))))
(= (merge Nil $right) $right)
(= (merge $left Nil) $left)
(= (merge (Cons $x $xs) (Cons $y $ys))
   (if (<= (getScoreVal $x) (getScoreVal $y))
       (Cons $x (merge $xs (Cons $y $ys)))
       (Cons $y (merge (Cons $x $xs) $ys))))

;; Merge sort
(: mergeSort (-> (List (ScoredInstance Cscore)) (List (ScoredInstance Cscore))))
(= (mergeSort Nil) Nil)
(= (mergeSort (Cons $x Nil)) (Cons $x Nil))
(= (mergeSort $list)
   (let $split (splitList $list)
        (let $left (car $split)
             (let $right (cdr $split)
                  (merge (mergeSort $left) (mergeSort $right))))))

;; Merge sort for InstanceSet
(: mergeSortInstanceSet (-> (InstanceSet Cscore) (InstanceSet Cscore)))
(= (mergeSortInstanceSet (mkSInstSet $list))
   (mkSInstSet (mergeSort $list)))

;; Test cases
(: testList (List (ScoredInstance Cscore)))
! (bind! testList 
   (Cons (mkSInst (mkPair (mkInst (Cons 1 Nil)) (mkCscore 1 5)))
   (Cons (mkSInst (mkPair (mkInst (Cons 2 Nil)) (mkCscore 2 3)))
   (Cons (mkSInst (mkPair (mkInst (Cons 3 Nil)) (mkCscore 3 7)))
   (Cons (mkSInst (mkPair (mkInst (Cons 4 Nil)) (mkCscore 4 1)))
   Nil)))))

(: testSet (InstanceSet Cscore))
(= testSet (mkSInstSet testList))

;; Run tests
! (bubbleSortInstanceSet testSet)
! (mergeSortInstanceSet testSet)
; ! (get-type (mkSInstSet testList))

;; Time complexity comparison:
;; Bubble Sort: O(n²) - where n is the number of elements in the list
;; Merge Sort: O(n log n) - much more efficient for large lists