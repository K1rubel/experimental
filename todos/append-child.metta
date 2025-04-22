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

; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil) )))

; ! (get-type random-int)
; ; ! (random-float &rng 0 1)

;; get the node id from lsk
(: mkLSK (-> DiscreteKnob (Tree $a) LogicalSubtreeKnob))

(mkLSK
    (mkDiscKnob
      (mkKnob
        (mkTree (mkNode OR)
          (Cons (mkTree (mkNode X) Nil)
            (Cons (mkTree (mkNode Y) Nil)
              (Cons (mkTree (mkNode Z) Nil)
                Nil))))
        (mkNodeId (0 2)))
      (mkMultip 3)
      (mkDiscSpec 1)
      (mkDiscSpec 1)
      Nil)
    (mkTree (mkNode Y) Nil))

(= (getNodeId (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
   $nodeId)
;; get current and default disc spec
(= (getDiscSpec (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
    (let ((mkDiscSpec $def) (mkDiscSpec $cur)) ($default $current) ($def $cur)))

(= (getSubtree (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
    $subtree)

;; represeantation of an empty tree with nullvertex 

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
    (let* (($nodeId (getNodeId))
            (($default $current) (getDiscSpec $lsk))
            ($subtree (getSubtree $lsk)))
            (if (isEmpty $tree)
                $subtree
                (let $treeToAppend 
                   (case ($current $default)
                        (((2 1) (insertAbove $subtree (mkNode NOT))) ;; negating the subtree 
                         ((2 0) (let $child (getChildrenByIdx $subtree 0) (insertAbove $child (mkNode NOT)))) ;; getting the first child of the subtree
                         (($n 1) $subtree)
                         (($n 0) (getChildrenByIdx $subtree 0))))

                    (replaceNodeById $tree $nodeId $treeToAppend)))))

;; getNodeById (AND A (OR B C))
; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))))
; ! (getNodeById (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))) (mkNodeId (0 2)))
; ; ! (getChildrenByIdx (mkTree (mkNode NOT) Nil) (mkNodeId (0)))

; ! (getChildrenByIdx (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) 0)
; ! (get-type (mkNullVex Nil))

; ! (get-type (mkTree (mkNode AND) 
;         (Cons (mkTree (mkNode A) Nil) 
;             (Cons (mkNullVex (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil)) Nil))))

; ! (get-type (mkNullVex (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil)))            
; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)))
; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)))

; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil)
;     (Cons (mkTree (mkNode NullVertex) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil)) Nil))))

; ! (get-type (mkTree (mkNode OR)
;   (Cons
;     (mkNullVex
;       (Cons
;         (mkTree (mkNode AND)
;           (Cons (mkTree (mkNode B) Nil)
;             (Cons (mkTree (mkNode A) Nil) Nil)))
;         Nil))
;     (Cons (mkTree (mkNode D) Nil) Nil))))

; ! (getNodeById (mkTree (mkNode OR)
;   (Cons
;     (mkNullVex
;       (Cons
;         (mkTree (mkNode AND)
;           (Cons (mkTree (mkNode B) Nil)
;             (Cons (mkTree (mkNode A) Nil) Nil)))
;         Nil))
;     (Cons (mkTree (mkNode D) Nil) Nil))) (mkNodeId (0 2)))

; ! (appendTo (mkTree (mkNode OR)
;   (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode A) Nil) Nil))) Nil))
;     (Cons (mkTree (mkNode D) Nil) Nil))) 
;             (mkLSK
;                 (mkDiscKnob
;                     (mkKnob
;                     (mkTree (mkNode OR)
;                         (Cons
;                         (mkNullVex
;                             (Cons
;                             (mkTree (mkNode AND)
;                                 (Cons (mkTree (mkNode B) Nil)
;                                     (Cons (mkTree (mkNode A) Nil) Nil)))
;                             Nil))
;                         (Cons (mkTree (mkNode D) Nil) Nil)))
;                     (mkNodeId (0 1)))
;                     (mkMultip 3)
;                     (mkDiscSpec 1)
;                     (mkDiscSpec 2)
;                     Nil)
;                 (mkTree (mkNode AND)
;                     (Cons (mkTree (mkNode B) Nil)
;                         (Cons (mkTree (mkNode A) Nil) Nil)))))

; ! (getSubtree (mkLSK
;   (mkDiscKnob
;     (mkKnob
;       (mkTree (mkNode OR)
;         (Cons
;           (mkNullVex
;             (Cons
;               (mkTree (mkNode AND)
;                 (Cons (mkTree (mkNode B) Nil)
;                       (Cons (mkTree (mkNode A) Nil) Nil)))
;               Nil))
;           (Cons (mkTree (mkNode D) Nil) Nil)))
;       (mkNodeId (0 1)))
;     (mkMultip 3)
;     (mkDiscSpec 1)
;     (mkDiscSpec 2)
;     Nil)
;   (mkTree (mkNode AND)
;     (Cons (mkTree (mkNode B) Nil)
;           (Cons (mkTree (mkNode A) Nil) Nil)))))

; ! (replaceNodeById (mkTree (mkNode OR)
;                         (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode A) Nil) Nil))) Nil))
;                             (Cons (mkTree (mkNode D) Nil) Nil)))  (mkNodeId (0 1)) 
;                             (mkTree (mkNode AND)
;                                 (Cons (mkTree (mkNode B) Nil)
;                                     (Cons (mkTree (mkNode A) Nil) Nil))))

; ! (getNodeById (mkTree (mkNode OR)
;                         (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode A) Nil) Nil))) Nil))
;                             (Cons (mkTree (mkNode D) Nil) Nil)))  (mkNodeId (0 1)))

; ! (getNodeById (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) (mkNodeId (0 1 0)) ) 
; ! (replaceNodeById (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) (mkNodeId (0 1)) (mkTree (mkNode AND) (Cons (mkTree (mkNode B) Nil) Nil)))                      

(: replaceNodeById (-> (Tree $a) NodeId (Tree $a) (Tree $a)))
(= (replaceNodeById (mkTree (mkNode $r) $children) (mkNodeId $id) $subtree)
    (let* ((($f $t) (decons-atom $id))
        )
            
            (if (== $t ())
                (if (== $f 0)
                    $subtree
                    (mkTree (mkNode $r) (List.replaceByIdx $children (- $f 1) $subtree))
                )
                (if (== $f 0)
                    (let* ((($f2 $t2) (decons-atom $t))
                            ($c )) (mkTree (mkNode $r) (List.replaceByIdx $children (- $f2 1) $subtree)))
                    ()
                )
            )))

;; checking working import for List.replaceByIdx
; ! (List.replaceByIdx (Cons 0 Nil) 0 1)      
; ! (List.replaceByIdx (Cons 0 (Cons 1 Nil)) 1 2) 

! (replaceNodeById (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) (mkNodeId (1)) (mkTree (mkNode C) Nil))