! (register-module! ../../../experiments)
! (import! &self experiments:experimental:tree-type)
! (import! &self experiments:experimental:list-related)
! (import! &self experiments:experimental:helpers)
;;;;;;;;;;;;;;;;;;; ID System ;;;;;;;;;;;;;;;;;;;;

; ;; Uses indices to identify nodes in a tree. 
; ;; Example: (AND A (OR B C))
; ;; AND : (0)
; ;; A : (1) or (0 1)
; ;; (OR B C) : (2) or (0 2)
; ;; B : (2 1)
; ;; C : (2 2)

; (: NodeId Type)
; (: mkNodeId (-> $tuple NodeId)) 

; (: mkLSK (-> DiscreteKnob (Tree $a) LogicalSubtreeKnob))
; (: DiscSpec Type)
; (: mkDiscSpec (-> Number DiscSpec))

; (: mkDiscKnob (-> Knob Multiplicity DiscreteKnob))
; (: mkDiscKnob (-> Knob Multiplicity DiscSpec DiscSpec (List DiscSpec) DiscreteKnob))
; (= (mkDiscKnob $knob $multiplicity) 
;    (mkDiscKnob $knob $multiplicity (mkDiscSpec 0) (mkDiscSpec 0) Nil)
; )
; (: Knob Type)
; (: mkKnob (-> (Tree $a) NodeId Knob)) 

; (: Cons $a (List $a) (List $a))
; ; $tree -- (mkTree (mkNode $node) (Cons $x $xs)) or (mkTree (mkNode $node) Nil)
; ; $nodeId -- (mkNodeId $tuple) -- tuple of indices
; ; $multi -- multiplicity of the DiscreteKnob
; ; $discSpecList -- list of disc specifications


; ;; replace a node
; (: removeNodeById (-> (Tree $a) NodeId (Tree $a)))
; (= (removeNodeById $tree $node)

; )

; ; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil) )))

; ; ! (get-type random-int)
; ; ; ! (random-float &rng 0 1)

; (mkLSK
;     (mkDiscKnob
;       (mkKnob
;         (mkTree (mkNode OR)
;           (Cons (mkTree (mkNode X) Nil)
;             (Cons (mkTree (mkNode Y) Nil)
;               (Cons (mkTree (mkNode Z) Nil)
;                 Nil))))
;         (mkNodeId (0 2)))
;       (mkMultip 3)
;       (mkDiscSpec 1)
;       (mkDiscSpec 1)
;       Nil)
;     (mkTree (mkNode Y) Nil))

; (= (getNodeId (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
;    $nodeId)
; ;; get current and default disc spec
; (= (getDiscSpec (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
;     (let ((mkDiscSpec $def) (mkDiscSpec $cur)) ($default $current) ($def $cur)))

; (= (getSubtree (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
;     $subtree)

; ;; represeantation of an empty tree with nullvertex 

; (: NullVertex (Tree $a))
; (: mkNullVex (-> (List (Tree $a)) (Tree $a)))

; ! (get-type (Cons (mkTree (mkNode A) Nil) Nil))
; ! (get-type (mkNullVex (Cons (mkTree (mkNode A) Nil) Nil)))
; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkNullVex (Cons (mkTree (mkNode A) Nil) Nil)) Nil))))
; ; ! (get-type (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))))
; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkNullVex (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil)) Nil))))
; ! (get-type (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode C) Nil) Nil))))
; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkNullVex (Cons (mkTree (mkNode B) Nil) Nil)) Nil))) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode C) Nil) (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode D) Nil) (Cons (mkTree (mkNode E) Nil) Nil))) Nil)) Nil))) Nil))) (Cons (mkNullVex (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode F) Nil) (Cons (mkTree (mkNode G) Nil) Nil))) Nil)) Nil))))
; ! (get-type (mkLSK (mkDiscKnob 
;                                 (mkKnob 
;                                     (mkTree (mkNode AND)
;                                         (Cons
;                                             (mkTree (mkNode A) Nil) 
;                                             (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
;                                                 (Cons (mkTree (mkNode Y) Nil) 
;                                                 (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil))) (mkNodeId (0 2)))
                                                
;                                                     (mkMultip 3))
;                                                         (mkTree (mkNode F) Nil)))
                                                        
; ;; a sample null vertex
; ; ! (get-type (mkNullVex (Cons NullVertex Nil)))

; (: isEmpty (-> (Tree $a) Bool))
; (= (isEmpty $tree)
;     (case $tree
;         (((mkNullVex (Cons NullVertex Nil)) True) ;; can replace (Cons NullVertex Nil) with a variable
;         ($else False))))

; ; ! (isEmpty (mkNullVex (Cons NullVertex Nil)))
; ; ! (isEmpty (mkTree (mkNode AND) Nil))
; ;; appendTo -- appends a subtree in place of a logical subtree using information from the subtree 
; ;;          -- $tree is an tree decorated with logica subtree knobs
; ;;          -- $lsk is a tree 

; (: appendTo (-> (Tree $a) LogicalSubtreeKnob (Tree $a)))
; (= (appendTo $tree $lsk)
;     ;; get current and default specifications, tree to be added to candidate from the
;     (let* (($nodeId (getNodeId $lsk))
;             (($default $current) (getDiscSpec $lsk))
;             ($subtree (getSubtree $lsk)))
;             (if (isEmpty $tree)
;                 $subtree
;                 (let $treeToAppend 
;                    (case ($current $default)
;                         (((2 1) (insertAbove $subtree (mkNode NOT))) ;; negating the subtree 
;                          ((2 0) (let $child (getChildrenByIdx $subtree 0) (insertAbove $child (mkNode NOT)))) ;; getting the first child of the subtree
;                          (($n 1) $subtree)
;                          (($n 0) (getChildrenByIdx $subtree 0))))

;                     (replaceNodeById $tree $nodeId $treeToAppend)))))


; ! (getNodeById (mkTree (mkNode AND)
;                       (Cons
;                         (mkTree (mkNode A) Nil) 
;                           (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
;                             (Cons (mkTree (mkNode Y) Nil) 
;                               (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil)))  (mkNodeId (0 2)))

; ! (appendTo (mkTree (mkNode AND)
;                       (Cons
;                         (mkTree (mkNode A) Nil) 
;                           (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
;                             (Cons (mkTree (mkNode Y) Nil) 
;                               (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil)))  (mkLSK (mkDiscKnob 
;                                                                                             (mkKnob 
;                                                                                                 (mkTree (mkNode AND)
;                                                                                                     (Cons
;                                                                                                         (mkTree (mkNode A) Nil) 
;                                                                                                         (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
;                                                                                                             (Cons (mkTree (mkNode Y) Nil) 
;                                                                                                             (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil))) (mkNodeId (2)))
                                                                                                            
;                                                                                                                 (mkMultip 3)
;                                                                                                                 (mkDiscSpec 1)
;                                                                                                                 (mkDiscSpec 1) Nil)
;                                                                                                                     (mkTree (mkNode F) Nil)))

; ! (replaceNodeById (mkTree (mkNode AND)
;                       (Cons
;                         (mkTree (mkNode A) Nil) 
;                           (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
;                             (Cons (mkTree (mkNode Y) Nil) 
;                               (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil)))  (mkNodeId (2)) 
                              
;                               (mkTree (mkNode H) Nil))

; ; ! (getNodeById (mkTree (mkNode AND) 
; ;                 (Cons (mkTree (mkNode OR) 
; ;                     (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) 
; ;                         (Cons (mkNullVex (Cons (mkTree (mkNode B) Nil) Nil)) Nil))) 
; ;                             (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode C) Nil) (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode D) Nil) (Cons (mkTree (mkNode E) Nil) Nil))) Nil)) Nil))) Nil))) (Cons (mkNullVex (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode F) Nil) (Cons (mkTree (mkNode G) Nil) Nil))) Nil)) Nil))) (mkNodeId (1)))
; ; ! (appendTo (mkTree (mkNode AND)
; ;                         (Cons
; ;                         (mkTree (mkNode X) Nil) 
; ;                             (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
; ;                             (Cons (mkTree (mkNode Y) Nil) 
; ;                                 (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil))) 
; ;                                 (mkNodeId (2)) )                              

; ; ! (getNodeById (mkTree (mkNode OR)
; ;   (Cons
; ;     (mkTree (mkNode B) Nil)
; ;     (Cons
; ;       (mkNullVex
; ;         (Cons
; ;           (mkTree (mkNode AND)
; ;             (Cons
; ;               (mkTree (mkNode X) Nil)
; ;               (Cons
; ;                 (mkTree (mkNode Y) Nil)
; ;               Nil)))
; ;         Nil)) ; children of NullVex
; ;       Nil))) (mkNodeId (2))); )

; ! (getNodeId (mkLSK
;     (mkDiscKnob
;       (mkKnob
;         (mkTree (mkNode OR)
;           (Cons
;             (mkTree (mkNode A) Nil)
;             (Cons
;               (mkNullVex
;                 (Cons
;                   (mkTree (mkNode AND)
;                     (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
;                 Nil))
;             Nil)))
;         (mkNodeId (2)))
;       (mkMultip 3)
;       (mkDiscSpec 2)
;       (mkDiscSpec 1)
;       Nil)
;     ;; Subtree to insert
;     (mkTree (mkNode Z) Nil)))
; ! (getNodeById (mkTree (mkNode OR)
;           (Cons
;             (mkTree (mkNode A) Nil)
;             (Cons
;               (mkNullVex
;                 (Cons
;                   (mkTree (mkNode AND)
;                     (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
;                 Nil))
;             Nil))) (mkNodeId (2)))
; ! (appendTo 
;   (mkTree (mkNode OR)
;     (Cons
;       (mkTree (mkNode A) Nil)
;       (Cons
;         (mkNullVex
;           (Cons
;             (mkTree (mkNode AND)
;               (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
;           Nil))
;       Nil)))
  
;   (mkLSK
;     (mkDiscKnob
;       (mkKnob
;         (mkTree (mkNode OR)
;           (Cons
;             (mkTree (mkNode A) Nil)
;             (Cons
;               (mkNullVex
;                 (Cons
;                   (mkTree (mkNode AND)
;                     (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
;                 Nil))
;             Nil)))
;         (mkNodeId (2)))
;       (mkMultip 3)
;       (mkDiscSpec 1)
;       (mkDiscSpec 2)
;       Nil)
;     ;; Subtree to insert
;     (mkTree (mkNode Z) Nil)))
; ! (appendTo 
;   (mkTree (mkNode OR)
;     (Cons
;       (mkTree (mkNode A) Nil)
;       (Cons
;         (mkNullVex
;           (Cons
;             (mkTree (mkNode AND)
;               (Cons (mkTree (mkNode W) Nil) Nil))
;           Nil))
;       Nil)))
  
;   (mkLSK
;     (mkDiscKnob
;       (mkKnob
;         (mkTree (mkNode OR)
;           (Cons
;             (mkTree (mkNode A) Nil)
;             (Cons
;               (mkNullVex
;                 (Cons
;                   (mkTree (mkNode AND)
;                     (Cons (mkTree (mkNode W) Nil) Nil))
;                 Nil))
;             Nil)))
;         (mkNodeId (2)))
;       (mkMultip 3)
;       (mkDiscSpec 0)
;       (mkDiscSpec 2)
;       Nil)
;     (mkTree (mkNode AND)
;       (Cons (mkTree (mkNode W) Nil) Nil))))

; ;; result
; ; (mkTree (mkNode OR)
; ;   (Cons
; ;     (mkTree (mkNode A) Nil)
; ;     (Cons
; ;       (mkTree (mkNode NOT)
; ;         (Cons (mkTree (mkNode W) Nil) Nil))
; ;     Nil)))

; ;; as is insertion

; ! (appendTo 
;     (mkTree (mkNode OR)
;         (Cons
;         (mkTree (mkNode A) Nil)
;         (Cons
;             (mkNullVex
;             (Cons
;                 (mkTree (mkNode NOT)
;                 (Cons (mkTree (mkNode N) Nil) Nil))
;             Nil))
;         Nil)))
  
;     (mkLSK
;         (mkDiscKnob
;         (mkKnob
;             ;; Same tree
;             (mkTree (mkNode OR)
;             (Cons
;                 (mkTree (mkNode A) Nil)
;                 (Cons
;                 (mkNullVex
;                     (Cons
;                     (mkTree (mkNode NOT)
;                         (Cons (mkTree (mkNode N) Nil) Nil))
;                     Nil))
;                 Nil)))
;             (mkNodeId (2)))
;         (mkMultip 3)
;         (mkDiscSpec 1)
;         (mkDiscSpec 1)
;         Nil)
;         (mkTree (mkNode NOT) 
;             (Cons (mkTree (mkNode N) Nil) Nil))))
; ;; result

; ; [(mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode NOT) (Cons (mkTree (mkNode N) Nil) Nil)) Nil)))]
; ;; 🧠 Scenario 4: (current=1, default=0) — Use only first child of subtree

; ! (appendTo 
;     (mkTree (mkNode OR)
;         (Cons
;         (mkTree (mkNode A) Nil)
;         (Cons
;             (mkNullVex
;             (Cons
;                 (mkTree (mkNode OR)
;       (Cons (mkTree (mkNode R) Nil) (Cons (mkTree (mkNode S) Nil) Nil)))
;             Nil))
;         Nil)))
  
;   (mkLSK
;     (mkDiscKnob
;       (mkKnob
;         (mkTree (mkNode OR)
;           (Cons
;             (mkTree (mkNode A) Nil)
;             (Cons
;               (mkNullVex
;                 (Cons
;                   (mkTree (mkNode OR)
;       (Cons (mkTree (mkNode R) Nil) (Cons (mkTree (mkNode S) Nil) Nil)))
;                 Nil))
;             Nil)))
;         (mkNodeId (2)))
;       (mkMultip 3)
;       (mkDiscSpec 0)
;       (mkDiscSpec 1)
;       Nil)
;     ;; Subtree
;     (mkTree (mkNode OR)
;       (Cons (mkTree (mkNode R) Nil) (Cons (mkTree (mkNode S) Nil) Nil)))))

; ;; result -- the first child of the subtree should've been added without negation

; (Cons A (Cons B (Cons $new $xs)))
; (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkNullVex (Cons)))))

; ! (getNodeById (mkTree (mkNode OR)
;           (Cons
;             (mkTree (mkNode A) Nil)
;             (Cons
;               (mkNullVex
;                 (Cons
;                   (mkTree (mkNode AND)
;                     (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
;                 Nil))
;             Nil))) (mkNodeId (2)))

! (getNodeById (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))) (mkNodeId (0 2 1)))

(: List.appendByIndex (-> (List $a) Number $a (List $a)))
(= (List.appendByIndex Nil $index $new) (if (== $index 0)(Cons $new Nil) (Error $index "Index out of range")))
(= (List.appendByIndex (Cons $x $xs) $index $new)
  (if (== $index 0)
    (Cons $new (Cons $x $xs))
    (Cons $x (List.appendByIndex $xs (- $index 1) $new))))

! (List.appendByIndex Nil 0 4)
; ! (List.appendByIndex Nil 3 4)
! (List.appendByIndex (Cons 5 Nil) 1 4)