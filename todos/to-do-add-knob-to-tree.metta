;; add knob to tree
;; Knob contains information about where in the exemplar it belongs

(= (getPosition $knob) .. return knob position)

(= (addKnobToTree (mkTree (mkNode $node) Nil)) )
(= (addKnobToTree (mkTree (mkNode $node))) )

(: NullVertex (Tree $a))
(: mkNullVex (-> (List (Tree $a)) (Tree $a)))

;; a sample null vetex (() (AND A B))
(mkTree (mkNode ()) (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil))))))
;; the above indicates that nullVertex is kind of 
;; Insert ()

(= (insertKnobToExemplar $tree $knob $nodeId)

)

(: List.append (-> $a (List $a) (List $a)))
(= (List.append $a Nil) (Cons $a Nil))
(= (List.append $a (Cons $x $xs)) (if (== $xs Nil) (Cons $x (Cons $a $xs)) (Cons $x (List.append $a $xs))))

(= (insertNodeToTree (mkTree (mkNode $node) $children) $node)
    (let $appended (List.append $node $children) 
        (mkTree (mkNode $node $appended))
    )
)

(= (tree.replace (mkTree (mkNode $node) $treeList) $oldnode $newnode)
    (case $treeList
        ((Nil ))
    )
)
;; but in the case of a knob it will be a null vertex

(mkTree (mkNode $node) (Cons $x $xs))