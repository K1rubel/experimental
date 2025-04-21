;; get node by ID
;; assuming preorder traversal
;; Type definitions for Tree
(: Tree (-> $a Type))
(: List (-> $a Type))
(: Cons (-> $a (List $a) (List $a)))
(: Node (-> $a Type))
(: mkNode (-> $a (Node $a)))
(: Nil (List $a))
(: mkTree (-> (Node $a) (List (Tree $a)) (Tree $a)))
(: A Bool)


; (: getNodeByID (-> Expression Number Node))
; (= (getNodeByID (mkTree (mkNode $p) Nil) $n) (if (== $n 0) (mkNode $p) (Error $n "Out of range")))
; (= (getNodeByID (mkTree (mkNode $p) (Cons $x $xs)) $id)
;     (if (== $id 0)
;         (mkNode $p)
;         (if (== $xs Nil)
;             (getNodeByID $x (- $id 1))
;             (map (getNodeByID $x $xs (- $id 1))))))
        
        ; (let (mkTree $node $treeList) (getByID $children (- $id 1)) $node)))


; (: getByID (-> (List $a) Number $a))

(= (getByID Nil $id) Nil)
(= (getByID (Cons $x $xs) $id) (if (== $id 0) $x (getByID $xs (- $id 1))))

; ! (getByID Nil 1)
; ! (getByID (Cons 1 (Cons 2 Nil)) 1)
; ! (getByID (Cons 1 (Cons 2 (Cons 4 Nil))) 0)
; ! (get-type (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode C) Nil) Nil)))
; ! (get-type (Cons 1 (Cons 2 Nil)))

;; 

(mkTree (mkNode AND) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) Nil)) (Cons (mkTree (mkNode B) Nil) Nil)))

; ! (get-type Nil)
; ! (get-metatype (mkTree (mkNode AND) Nil))
; ! (== (get-meta (mkTree (mkNode AND) Nil)) (Tree $a))
; (= (getNodeByID (mkTree $node Nil) 0) $node)
; (= (getNodeByID (mkTree $node $treeList) $id)
;     (if (== $id 0)
;         $node
;         (case 
;         $treeList 
;             ((Nil (if (== $id 0) $node (Error $id "out of range")))
;             ((Cons $x $xs) (case 
;                                 $xs 
;                                     ((Nil (getNodeByID $x (- $id 1)))
;                                     ($_ let (Cons $s $t) $xs (getNodeByID $s (- $id 1)))
;                                     )))))))


;; Define a mapping function that returns  a single tuple 
; ! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) Nil)) (Cons (mkTree (mkNode B) Nil) Nil))) 2) ;; B
(= (getNodeByID (mkTree (mkNode $node) Nil) $id) (if (== $id 0) (mkNode $node) (Error $id "Out of bounds")))
(= (getNodeByID (mkTree (mkNode $node) (Cons $x $xs)) $id)
    (if (== $id 0)
        (mkNode $node)     
            (map` getNodeByID (Cons $x $xs) (- $id 1))))

; (: map (-> (-> $a $b) (List $a) (List $b)))
(= (map` $func Nil $n) Nil)
(= (map` $func (Cons $x $xs) $id) 
    (if (== $id 0)
        (let (mkTree (mkNode $node) $t) $x (mkNode $node))
        
    )
(Cons ($func $x $id) (map` $func $xs (- $id 1))))

! (getNodeByID (mkTree (mkNode A) Nil) 0)
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)) 0) ;; AND
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)) 1) ;; A
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) 2) ;; B

