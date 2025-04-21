;; node to id
(= (getNodeId $node Nil) (Error Nil "No such node"))

;; $index -- starts from 0
(= (getNodeId (mkTree (mkNode $r) Nil) $node $idx) (if (== $node $r) $idx (Error "No such node"))) 
(= (getNodeId (mkTree (mkNode $r) (Cons $x $xs)) $node $index)
    (if (== $node $r)
        $index
        (mpp getNodeId (Cons $x $xs) $node (+ 1 $index))))

(= (mpp $func Nil $node $index) (Error $node "No such node in tree"))
(= (mpp $func (Cons $x $xs) $node $index)
    (let $idx ($func $x $node $index)
        (if (== (get-metatype $idx) Number)
            $idx
            (mpp $func $xs $node (+ $index 1)))))

(= (getNodeId (mkTree (mkNode $r) $treeList) $node $index)
    (case $treeList
        ((Nil) (if))
    )
)

! (getNodeId (mkTree (mkNode A) Nil) A 0) ;; 
! (getNodeId (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)) A 0) ;; 1
! (getNodeId (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) B 0) ;; 2
! (getNodeId (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil) Nil)) OR 0) ;; 2