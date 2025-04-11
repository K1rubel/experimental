(: Tree (-> $a Type))
(: List (-> $a Type))
(: Node (-> $a Type))
(: mkNode (-> $a (Node $a)))
(: Nil (List $a))
(: mkTree (-> (Node $a) (List (Tree $a)) (Tree $a)))
(: nodeConstructor (-> Atom (Tree $a)))
(: ex2L (-> Expression (List $a)))
(: exp2Tree (-> $t (Tree $a)))

(: map (-> (-> $a (Tree $a)) Expression Expression))

(: A Bool)

; This creates an tree with no children, a tree with a single root

; (= (nodeConstructor $t)
;   (mkTree (mkNode $t) Nil))


(= (ex2L $exp)
  (if (== $exp ())
    Nil
    (let* ((($f $t) (decons-atom $exp))
           ($c (ex2L $t)))

      (Cons $f $c))))

(= (map $func $exp)
  (if (== $exp ())
    $exp 
    (let* ((($f $t) (decons-atom $exp))
            ($c (map $func $t)))

       (let $h ($func $f)
         (cons-atom $h $c))
       )))


(= (exp2Tree $expr) 
    (if (not (== (get-metatype $expr) Expression))
        (mkTree (mkNode $expr) Nil)
        (let* 
            ((($f $t) (decons-atom $expr))
               ($tail (map exp2Tree $t)))

            (mkTree (mkNode $f) (ex2L $tail)))))