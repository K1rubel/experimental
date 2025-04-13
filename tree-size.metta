; ! (register-module! ./experimental)
; ! (import! &self experimental:tree-type)
; ! (import! &self experimental:list-related)


(: map (-> (-> $a $b) (List $a) (List $b)))
(= (map $f Nil) Nil)
(= (map $f (Cons $x $xs)) (Cons ($f $x) (map $f $xs)))

(: filter (-> (-> $a Bool) (List $a) (List $a)))
(= (filter $p Nil) Nil)
(= (filter $p (Cons $x $xs)) (if ($p $x) (Cons $x (filter $p $xs)) (filter $p $xs)))

(: listToExpr (-> (List $a) Expression))
(= (listToExpr Nil) ())
(= (listToExpr (Cons $x $xs)) (let $t (listToExpr $xs) (cons-atom $x $t)))

(: isUnit (-> $a Bool))
(= (isUnit $x) (== $x ()))

(: . (-> (-> $b $c) (-> $a $b) (-> $a $c)))
(= ((. $g $f) $x) ($g ($f $x)))

(: preOrder (-> (Tree $a) $a))
(= (preOrder (mkTree (mkNode $r) Nil)) $r)
(= (preOrder (mkNullVex $knobs)) ())
(= (preOrder (mkTree (mkNode $r) (Cons $x $xs)))
     (let*
         (
           ($lc  (map preOrder (Cons $x $xs))) ;; (Cons B (Cons C (Cons () Nil)))
           ($lc' (filter (. not isUnit) $lc)) ;; (Cons B (Cons C Nil))
           ($lcE (listToExpr $lc')) ;; (B C)
           ;; (()   (println! (Root: $r Children: $lc Children': $lc' Expression: $lcE)))
           ($exp (cons-atom $r $lcE)) ;; (OR B C)
         )
         $exp)
)

(: replaceAll (-> Expression $a Expression))
(= (replaceAll $exp $val)
    (if (== $exp ())
        $exp
        (let* ((($f $t) (decons-atom $exp))
            ($c (replaceAll $t $val)))
            
            (cons-atom 1 $c))))

; (: treeSize (-> (Tree $a) Number))
; (= (treeSize $tree) (sizeAtom ((preOrder $tree))))

;; size atom for nested expression
(: sizeAtom (-> Expression Number))
(= (sizeAtom $exp)
    (if (== $exp ())
        0
        (let* ((($f $t) (decons-atom $exp))
                ($c (sizeAtom $t)))
                
                (if (not (== (get-metatype $f) Expression))
                    (+ 1 $c)
                    (let $r (sizeAtom $f)
                        (+ $r $c))))))

;; Tree complexity
(: complexity (-> Atom Complexity))

(= (complexity $exp)
        (if (== $exp ())
            0
            (case (get-metatype $exp)
                
                    ((Expression (let* ((($f $t) (decons-atom $exp))
                                            ($tc (complexity $t)))
                                            
                                            (if (isMember $f (NOT AND OR))
                                                $tc
                                                (let $fc (complexity $f) (+ $fc $tc)))))

                    ($_ (case (isBoolConst $exp) 
                                ((True 0)
                                (False 1))))))))                 

(: isBoolConst (-> Atom Bool))
(= (isBoolConst $atom) (or (noreduce-eq $atom False) (noreduce-eq $atom True)))

;; check membership of an element in a tuple
(: isMember (-> Atom Expression Bool))
(= (isMember $el $set) (not (== (collapse (intersection $el (superpose $set))) ())))

; ! (isMember OR (AND A B))

; ! (complexity A) ;; 1
; ! (complexity True) ;; 0
; ! (complexity (AND True)) ;; 1
; ! (complexity (AND A)) ;; 2
; ! (complexity (AND A (OR A B))) ;; 3


;; Tree size -- size of a tree from the tree representation -- not from tuple representation
;; TODO -- type definition
;; TODO -- more tests

(= (treeSize (mkTree (mkNode $node) Nil)) 1)

(= (treeSize (mkTree (mkNode $node) (Cons $x $xs)))
    (+ 1 (mppp treeSize (Cons $x $xs))))

(= (mppp $func Nil) 0)
(= (mppp $func (Cons $x $xs)) (+ (+ 0 ($func $x)) (mppp $func $xs)))

! (treeSize Nil) ;; 0
! (treeSize (mkTree (mkNode A) Nil)) ;; 1
! (treeSize (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil))) ;; 2
! (treeSize (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil)))) ;; 3
! (treeSize (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))))) ;; 4

;; (AND A (OR B C))
! (treeSize (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil)))) ;; 4