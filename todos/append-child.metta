! (register-module! ../../../experiments)
! (import! &self experiments:experimental:tree-type)
! (import! &self experiments:experimental:list-related)
! (import! &self experiments:experimental:helpers)
;;;;;;;;;;;;;;;;;;; ID System ;;;;;;;;;;;;;;;;;;;;

;; Uses indices to identify nodes in a tree. 
;; Example: (AND A (OR B C))
;; AND : (0)
;; A : (1) or (0 1)
;; (OR B C) : (2) or (0 2)
;; B : (2 1)
;; C : (2 2)

(: NodeId Type)
(: mkNodeId (-> $tuple NodeId)) 

(: mkLSK (-> DiscreteKnob (Tree $a) LogicalSubtreeKnob))
(: DiscSpec Type)
(: mkDiscSpec (-> Number DiscSpec))

(: mkDiscKnob (-> Knob Multiplicity DiscreteKnob))
(: mkDiscKnob (-> Knob Multiplicity DiscSpec DiscSpec (List DiscSpec) DiscreteKnob))
(= (mkDiscKnob $knob $multiplicity) 
   (mkDiscKnob $knob $multiplicity (mkDiscSpec 0) (mkDiscSpec 0) Nil)
)
(: Knob Type)
(: mkKnob (-> (Tree $a) NodeId Knob)) 

; $tree -- (mkTree (mkNode $node) (Cons $x $xs)) or (mkTree (mkNode $node) Nil)
; $nodeId -- (mkNodeId $tuple) -- tuple of indices
; $multi -- multiplicity of the DiscreteKnob
; $discSpecList -- list of disc specifications


;; replace a node
(: removeNodeById (-> (Tree $a) NodeId (Tree $a)))
(= (removeNodeById $tree $node)

)

! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil) )))

; ! (get-type random-int)
; ; ! (random-float &rng 0 1)

;; append child would be replace 


; (: appendTo (-> (Tree $a) lsk (Tree $a)))

(= (appendTo $tree $lsk)
    ;; get node id and specification of the node from the lsk using getter functions
    ;; then apply modification based on the specification
    ;; if absent, remove the node from list of children of the 
    ;; if negated add a NOT parent node above the node
    ;; if present just leave it as is
    ;; in the case of absent Since I dont have access to the parent list what I can do is just replace the target node with a null value
    ;; then just clean the tree of such null values afterwards
    ;; null also must be typed as (Tree $a)

    (let* (($nodeId (getNodeById $lsk))
           ($current (getDisSpec $lsk))
           ($targetNode (getNodeById $tree $nodeId)))
            
            (case $current
                ((0     (let $newT (replaceNodeById $tree $nodeId null)
                            (cleanTree $newT)))
                (1      $tree)
                (2      (let $negatedNode (insertAbove $targetNode (mkNode NOT))
                            (replaceNodeById $tree $nodeId $negatedNode)))))))


;; get the node id from lsk
(: mkLSK (-> DiscreteKnob (Tree $a) LogicalSubtreeKnob))

(= (getNodeId (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
    (let ($ctor $id) $nodeId $id)
)
;; get current and default disc spec
(= (getDisSpec (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
    ($default $current))

(= (getSubtree (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
    $subtree)

;; Question XXX : how to represent an empty tree
;; I have used Nill (not Nil) to represent the an empty tree
(: Nill (Tree $a))

;; or an alternative representation would be to consider a null vertex with zero children to be empty tree
;; here is a reference to how nullvertex is represented 

(: NullVertex (Tree $a))
(: mkNullVex (-> (List (Tree $a)) (Tree $a)))

;; a sample null vertex
! (get-type (mkNullVex (Cons NullVertex Nil)))

(: isEmpty (-> (Tree $a) Bool))
(= (isEmpty $tree)
    (case $tree
        (((mkNullVex (Cons NullVertex Nil)) True) ;; can replace (Cons NullVertex Nil) with a variable
        ($else False))))

! (isEmpty (mkNullVex (Cons NullVertex Nil)))
! (isEmpty (mkTree (mkNode AND) Nil))
;; appendTo -- appends a subtree in place of a logical subtree using information from the subtree 
;;          -- $tree is an tree decorated with logica subtree knobs
;;          -- $lsk is a tree 

(: appendTo (-> (Tree $a) LogicalSubtreeKnob (Tree $a)))
(= (appendTo $tree $lsk)
    ;; get current and default specifications, tree to be added to candidate from the
    (let* (($nodeId (getNodeByID))
            (($default $current) (getDisSpec $lsk))
            ($subtree (getSubtree $lsk)))
            (if (isEmpty $tree)
                $subtree
                (let $treeToAppend 
                   (case ($current $default)
                        (((2 1) (insertAbove $subtree (mkNode NOT))) ;; negating the subtree 
                         ((2 0) (let $child (getChildrenById $subtree (mkNodeId (0))) (insertAbove $child (mkNode NOT)))) ;; getting the first child of the subtree
                         (($n 1) $subtree)
                         (($n 0) (getChildrenById $subtree (mkNodeId (0))))))

                    (replaceNodeById $tree $nodeId $treeToAppend)))))

;; getNodeById (AND A (OR B C))
! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))))
! (getNodeById (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))) (mkNodeId (0 2)))
; ! (getChildrenById (mkTree (mkNode NOT) Nil) (mkNodeId (0)))

! (getChildrenById (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) (mkNodeId (0)))