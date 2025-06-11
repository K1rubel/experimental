
;; get node id from lsk
(= (getNodeId (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
   $nodeId)

;; get current and default disc spec
(= (getDiscSpec (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
    (let ((mkDiscSpec $def) (mkDiscSpec $cur)) ($default $current) ($def $cur)))

;; get subtree from lsk
(= (getSubtree (mkLSK (mkDiscKnob (mkKnob $tree $nodeId) $multi $default $current $discSpecList) $subtree))
    $subtree)

;; check if tree is empty
(: isEmpty (-> (Tree $a) Bool))
(= (isEmpty $tree)
    (case $tree
        (((mkNullVex Nil) True)
        ($else False))))

;; appendTo -- appends a subtree in place of a logical subtree using information from the lsk 
;;          -- $tree is an tree decorated with logica subtree knobs
;;          -- $lsk is a the knob containing information of how the subtree is appeneded to the original tree 

(: appendTo (-> (Tree $a) LogicalSubtreeKnob (Tree $a)))
(= (appendTo $tree $lsk)
    (let* (($nodeId (getNodeId $lsk))
            (($current $default) (getDiscSpec $lsk))
            ($subtree (getSubtree $lsk)))

            (if (> $current 2)
              (Error $current "Invalid disc specification:- cannot exceed 2.")
              (if (isEmpty $tree)
                $subtree
                (let $treeToAppend 
                   (case ($current $default)
                        (((2 1) (insertAbove $subtree (mkNode NOT)))
                         ((2 0) (let $child (getChildrenByIdx $subtree 0) (insertAbove $child (mkNode NOT))))
                         ($else (if (and (not (== $current 0)) (== $default 1))
                                $subtree
                                (getChildrenByIdx $subtree 0)))))

                    (replaceNodeById $tree $nodeId $treeToAppend))))))