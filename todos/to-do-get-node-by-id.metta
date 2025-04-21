
(mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil)))
;; the implementation below finds a given node in a tree based on preorder traversal -- but not complete
;; TODO -- type definitions
;; TODO -- correction of error cases

(= (getNodeByID (mkTree (mkNode $node) Nil) 0) (mkNode $node))

(= (getNodeByID (mkTree (mkNode $node) (Cons $x $xs)) $id)
    (if (== $id 0)
        (mkNode $node)
        (mpp getNodeByID (Cons $x $xs) (- $id 1))))

(= (mpp $func Nil $id) (Error $id "Out of bounds"))
(= (mpp $func (Cons $x $xs) $id)
    (let* (($r ($func $x $id))
            ($ctor (car-atom $r)))
        (if (== $ctor mkNode)
            $r
            (mpp $func $xs (- $id 1)))))

;; A
! (getNodeByID (mkTree (mkNode A) Nil) 1) ;; doesnt reduce 
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)) 0) ;; (mkNode AND)
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)) 1) ;; (mkNode A)
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) Nil))) 2) ;; (mkNode B)
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil)))) 3) ;; (mkNode C)

(AND A (OR B))

! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))) 2) ;; (mkNode OR)
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))) 3) ;; (mkNode B)

(AND A (OR B C))

! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))) 4) ;; (mkNode C)
! (getNodeByID (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) Nil))) 5) ;; (Error 0 "Out of bounds")


;; below is an implementation of the ID system that assigns the same id for all elements found in the same nested level
;;          e.g., in (AND A B (OR C)) 0 would mean evrything on the first leval -- the whole expression
;;                                    1 would mean the next nested structure -- (OR C)
;;                                    (0 0) would mean the first element in the first layer -- AND
;;                                    (0 1) would mean the second element in the first layer -- A
;;                                    (0 3) would mean the 4th element in the first layer -- (OR C)