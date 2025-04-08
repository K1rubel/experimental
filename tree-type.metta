(: Node (-> $a Type))
(: mkNode (-> $a (Node $a)))

(: List (-> $a Type))
(: Nil (List $a))

(: Cons (-> $a (List $a) (List $a)))

(: Tree (-> $a Tree))
(: mkTree (-> (Node $a) (List (Tree $a)) (Tree $a)))

(: A Bool)
;; moved the test cases to tests folder 