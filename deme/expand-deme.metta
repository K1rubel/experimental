;; python binding for ceiling functionality
;; this dont appear to work while importing to the another file
! (bind! ceil (py-atom math.ceil))
;;! (bind! rand (py-atom random.randint))
;; integer indices to feature names
(= (fsToNames $labels $ft-indices)
	(collapse (chain (superpose $ft-indices) $ft 
		(List.at $ft $labels))))
		
;; something weird going on here
; !(bind! a (2 3))
; !(bind! Da 3)

;; subsample by row
;; result -- depending on the number of subsampling demes, a set of rows to be ignored during optimization by each deme

(= (ssByRow (mkITable $table $lables) $nSubSample)
	(chain (List.length $table) $row-count
		(chain (range 0 1 $row-count) $r-indices 
		(chain (shuffle $r-indices ()) $shuffled-indices
			(chain (ceil (/ $row-count $nSubSample)) $to-ignore-count 
					(ssIterator $shuffled-indices $to-ignore-count ()))))))		
(= (ssIterator $shuffled-indices $rowCount $acc)
	(if (== $shuffled-indices ())
		$acc
		(let* (($sampled-r (takeN $rowCount $shuffled-indices))
			   ($rem-indices (subtraction-atom $shuffled-indices $sampled-r))
			   ($new-acc (cons-atom $sampled-r $acc)))
				
				(ssIterator $rem-indices $rowCount $new-acc))))
	

;; create_representations flow
;; feature selection -- festor(exemplar)
;; dont know exactly why the exemplar has to be inferred here????????

;; set of features selected using feature selection algorithms
;; get features used in the exemplar -- getArgs should do it -- 

;; Takes a tree and decides if the node is an argument or not.
;; An argument is anything that's not an operator or a null vertex.
(: isArgument (-> (Tree $a) Bool))
(= (isArgument (mkNullVex $x)) False)
(= (isArgument (mkTree (mkNode $x) $children))
   (and (not (isMember $x (AND OR NOT))) (== $children Nil)))

; (: getArguments (-> (Tree $a) Expression Expression))
; (= (getArguments Nil $acc) $acc)
; (= (getArguments (mkTree (mkNode $n) Nil) $acc) (if (isArgument (mkTree (mkNode $n) Nil)) (union-atom ($n) $acc) $acc))
; (= (getArguments (mkTree (mkNode $t) (Cons $child $childs)) $acc) 
	
; 	;; some way to map this to the rest of the tab
; 	(let $fist-node-child (getArguments $child $acc) 
; 		(unify $childs Nil
; 			$fist-node-child
; 			(unify $childs (Cons $x $xs)
; 				(let* (($rest (getArguments $xs $fist-node-child))
; 						($cur (getArguments $x $fist-node-child)))
; 					(union-atom $cur $rest)
; 					; $rest
; 				)
; 				()))))

(: isMember (-> $a $aa Bool))
(= (isMember $x $list)
    (not (== (collapse (intersection (superpose ($x)) (superpose $list))) ())))

(: List.map (-> (-> $a $b) (List $a) (List $b)))
(= (List.map $f Nil) Nil)
(= (List.map $f (Cons $x $xs)) (Cons ($f $x) (List.map $f $xs)))

(: List.foldl (-> (-> $a $b $b) $b (List $a) $b))
(= (List.foldl $f $i Nil) $i)
(= (List.foldl $f $i (Cons $h $t)) (chain ($f $h $i) $i' (List.foldl $f $i' $t)))


; (: isOperator (-> Atom Bool))
; (= (isOperator $x)
;     (or (== $x AND) (or (== $x OR) (== $x NOT))))

(: extractArgs (-> Tree List))
(= (extractArgs (mkTree (mkNode $node) $children))
    (if (isMember $node (AND OR NOT))
        ;; if it's an operator, collect args from children
        (extractArgsFromList $children)
        ;; else it's a literal, return it in a singleton list
        (Cons $node Nil)))

(: extractArgsFromList (-> List List))
(= (extractArgsFromList Nil) Nil)
(= (extractArgsFromList (Cons $head $tail))
    (List.appendList (extractArgsFromList $tail) (extractArgs $head)))

;; append a list to a list
(: List.appendList (-> (List $a) (List $a) (List $a)))
(= (List.appendList $a (Cons $x $xs))
    (if (== $xs Nil)
        (Cons $x $a)
        (Cons $x (List.appendList $a $xs))))

; ! (getArguments (mkTree (mkNode A) Nil))	
; ! (getArguments (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)))	
; ! (getArguments (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil)))))	

! (extractArgs (mkTree (mkNode A) Nil))	
! (extractArgs (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)))	
! (extractArgs (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil)))))	

! (let $result (extractArgs (mkTree (mkNode AND)
    (Cons (mkTree (mkNode A) Nil)
        (Cons (mkTree (mkNode OR)
            (Cons (mkTree (mkNode A) Nil)
                (Cons (mkTree (mkNode B) Nil) Nil)))
            Nil))))
		(List.foldl $result union-atom ()))

;; generalized foldl 
;; considering potential transfomration of input values before applying a function over them
(= (id $x) $x)
(= (exp $x) ($x))
(= (List.t-foldl Nil $f $t $acc) $acc)		
(= (List.t-foldl (Cons $x $xs) $f $t $acc) (let $tr ($t $x) (let $new-acc ($f $tr $acc) (List.t-foldl $xs $f $t $new-acc))))		

(= (List.t-foldr Nil $f $t $acc) $acc)		
(= (List.t-foldr (Cons $x $xs) $f $t $acc) (let $new-acc (List.t-foldr $xs $f $t $acc) (let $tr ($t $x) ($f $tr $new-acc))))		

;; Testing List.t-foldl
! (List.t-foldl Nil union-atom exp ())	;; ()
! (List.t-foldl (Cons A Nil) union-atom exp ())	;; (A)
! (List.t-foldl (Cons A (Cons B Nil)) union-atom exp ())	;; (A)

! (List.t-foldr Nil union-atom exp ())						;; ()
! (List.t-foldr (Cons A Nil) union-atom exp ())				;; (A)
! (List.t-foldr (Cons A (Cons B Nil)) union-atom exp ())	;; (A)
! (List.t-foldr (Cons A (Cons B (Cons C Nil))) union-atom exp ())	;; (A)
! (List.t-foldr (Cons A (Cons B (Cons C (Cons D (Cons D Nil))))) union-atom exp ())	;; (A)
;; (Cons B Nil) A -- wating for out put of the left side
;; (B) union () -- (B)
;; union (A) -- result of Cons B Nil

