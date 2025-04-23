; ! (register-module! ../../../experiments)
; ! (import! &self experiments:experimental:list-related)
; ! (import! &self experiments:experimental:tree-type)

;; Traverses a tree to find a node by its ID path.
;; Parameters:
;;   $tree: - The input tree (mkTree, mkNullVex, or Nil).
;;   $id: - A mkNodeId-wrapped tuple of indices (e.g., (mkNodeId (2 1))) representing the path.
;; Returns:
;;   (Tree $a) - The subtree at the specified ID path, or an error if invalid.
(: getNodeById (-> (Tree $a) NodeId (Tree $a)))
(= (getNodeById $tree (mkNodeId ())) $tree)
(= (getNodeById Nil $id) Nil)
(= (getNodeById $tree (mkNodeId $id))
   (let*
     ((($head $tail) (decons-atom $id))
       ($level (getLevelById $tree $head)))

     (if (== $tail ())
          $level
          (let*
              ((($nextHead $nextTail) (decons-atom $tail))
               ($nextLevel (getLevelById $level $nextHead)))

              (getNodeById $nextLevel (mkNodeId $nextTail))))))

;; Finds a subtree at a specific level in the tree.
;; Params:
;;   $tree: - The input tree (mkTree, mkNullVex, or Nil).
;;   $levelId: - index indicating the level (0 for root, 1 for first child, etc.).
;; Returns:
;;   (Tree $a) - The subtree at the specified level, or Nil if out of bounds.
(: getLevelById (-> (Tree $a) Number (Tree $a)))
(= (getLevelById (mkTree (mkNode $r) $children) $levelId)
   (if (== $levelId 0)
       (mkTree (mkNode $r) $children)
       (List.getByIdx $children (- $levelId 1))))
(= (getLevelById (mkNullVex $children) $levelId)
   (if (== $levelId 0)
       (mkNullVex $children)
       (List.getByIdx $children (- $levelId 1))))
(= (getLevelById Nil $levelId) Nil)

;; Creates a new tree with a node inserted above the given tree as its parent.
;; Params:
;;   $tree: - The original tree to be placed as a child.
;;   $node: - The new node to become the root, wrapping $tree.
;; Returns:
;;   (Tree $a) - A new mkTree with $node as the root and $tree as its only child.
(: insertAbove (-> (Tree $a) (Node $n) (Tree $a)))
(= (insertAbove $tree $node)
   (mkTree $node (Cons $tree Nil)))

;; replace Node By Id

(: replaceNodeById (-> (Tree $a) NodeId (Tree $a) (Tree $a)))
(= (replaceNodeById (mkTree (mkNode $r) $children) (mkNodeId $id) $newSubtree)
   (if (== $id ())  
       $newSubtree
       (let*
         (
           ($headId (car-atom $id))
           ($tailId (cdr-atom $id))
           ($childToUpdate (List.getByIdx $children (- $headId 1)))
           ($updatedChild (if (== $tailId ())
                              $newSubtree
                              (replaceNodeById $childToUpdate (mkNodeId $tailId) $newSubtree)))
           ($newChildren (List.replaceAt $children (- $headId 1) $updatedChild))
         )
         (mkTree (mkNode $r) $newChildren))))        

;; remove by index from a list of ..

(: List.removeByIdx (-> (List $a) Number (List $a)))
(= (List.removeByIdx Nil $n) (Error $n "Index out of bounds"))
(= (List.removeByIdx (Cons $x $xs) $n)
    (if (== $n 0)
        $xs 
        (Cons $x (List.removeByIdx $xs (- $n 1)))))

;; get children by index
; (: getChildrenById (-> (Tree $a) NodeId (List (Tree $a))))
; (= (getChildrenById $tree (mkNodeId $id))
;    (let $targetNode (getNodeById $tree (mkNodeId $id))
;      (case $targetNode
;        (
;          ((mkTree (mkNode $r) $childrenTgt) $childrenTgt)
;          ((mkNullVex $childrenTgt) $childrenTgt)
;          ($else (Error (Node not found or invalid)))))))

(: getChildrenById (-> (Tree $a) Number (List (Tree $a))))
(= (getChildrenByIdx $tree $idx)
        (case $tree
            (((mkTree (mkNode $r) $childrenTgt) (List.getByIdx $childrenTgt $idx))
              ((mkNullVex $childrenTgt) (List.getByIdx $childrenTgt $idx))
              ($else (Error (Node not found or invalid))))))

; ! (getNodeById (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))) (mkNodeId (2 1)))

; ! (getChildrenById (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) (mkNodeId (0)))         

(= (cleanTree (mkTree (mkNode $r) $children))
    (let $clean (List.clean $children)
        (mkTree (mkNode $r) (map cleanTree $clean))
    )
) 

; ! (List.clean (Cons (mkTree (mkNode A) Nil) (Cons null (Cons (mkTree (mkNode B) Nil) (Cons null Nil)))))

(: map (-> (-> $a $a) (List $a) (List $a)))
(= (map $func Nil) Nil)
(= (map $func (Cons $x $xs))
    (Cons ($func $x) (map $func $xs))
)
; ! (get-type (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode C) Nil) Nil)) Nil))))

; ! (cleanTree (mkTree (mkNode A) Nil)) ;; (mkTree (mkNode A) Nil)
; ! (cleanTree (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil))) ;; (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil))
; ! (cleanTree (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons null Nil))))) ;; (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil)))

; ! (cleanTree (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode C) Nil) Nil)) Nil)))) ;; (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode C) Nil) Nil)) Nil)))

; ! (cleanTree (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons null Nil)) Nil)))) ;; (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode C) Nil) Nil)) Nil)))

; ! (cleanTree (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons null Nil))))) ;; (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil)))
; ! (getNodeById (mkTree (mkNode AND) (Cons (mkTree (mkNode A)))))

; ! (getNodeById (mkTree (mkNode OR)
;   (Cons
;     (mkNullVex
;       (Cons
;         (mkTree (mkNode AND)
;           (Cons (mkTree (mkNode B) Nil)
;             (Cons (mkTree (mkNode A) Nil) Nil)))
;         Nil))
;     (Cons (mkTree (mkNode D) Nil) Nil))) (mkNodeId (0 1)))

; ! (getNodeById
;   (mkTree (mkNode AND)
;     (Cons
;       (mkTree (mkNode X) Nil) 
;         (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
;           (Cons (mkTree (mkNode Y) Nil) 
;             (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil))) 
;               (mkNodeId (2)))

; ! (let $tree (replaceNodeById (mkTree (mkNode AND)
;                       (Cons
;                         (mkTree (mkNode A) Nil) 
;                           (Cons (mkNullVex (Cons (mkTree (mkNode OR) 
;                             (Cons (mkTree (mkNode Y) Nil) 
;                               (Cons (mkTree (mkNode Z) Nil) Nil))) Nil)) Nil)))  (mkNodeId (2)) 
                              
;                               (mkTree (mkNode H) Nil)) (get-type $tree))
