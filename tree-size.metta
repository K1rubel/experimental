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

! (replaceAll (AND A B) 1)

; (: treeSize (-> (Tree $a) Number))
(= (treeSize $tree) (sizeAtom ((preOrder $tree))))

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