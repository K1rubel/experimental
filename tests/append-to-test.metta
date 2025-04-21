! (register-module! ../../../experiments)
! (import! &self experiments:experimental:tree-type)
! (import! &self experiments:experimental:list-related)
! (import! &self experiments:experimental:todos:helpers)
! (import! &self experiments:experimental:todos:append-child)

;; getNodeId test cases
!(assertEqual (getNodeId (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) Nil)) (mkNodeId (1 0))) (mkMultip 2) (mkDiscSpec 0) (mkDiscSpec 0) Nil) (mkTree (mkNode A) Nil))) (mkNodeId (1 0)))
!(assertEqual (getNodeId (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) (mkNodeId (3 5))) (mkMultip 1) (mkDiscSpec 1) (mkDiscSpec 1) Nil) (mkTree (mkNode B) Nil))) (mkNodeId (3 5)))

;; getDiscSpec
! (assertEqual (getDiscSpec (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode A) Nil) (mkNodeId (2 3))) (mkMultip 1) (mkDiscSpec 1) (mkDiscSpec 2) Nil) (mkTree (mkNode A) Nil))) (1 2))
! (assertEqual (getDiscSpec (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode B) Nil) (mkNodeId (4 1))) (mkMultip 2) (mkDiscSpec 0) (mkDiscSpec 1) Nil) (mkTree (mkNode B) Nil))) (0 1))

;; getSubtree

! (assertEqual (getSubtree 
                    (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode A) Nil) (mkNodeId (1 1))) (mkMultip 1) (mkDiscSpec 0) (mkDiscSpec 0) Nil) 
                            (mkTree (mkNode B) Nil))) (mkTree (mkNode B) Nil))

! (assertEqual (getSubtree 
                    (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode B) Nil) (mkNodeId (2 2))) (mkMultip 1) (mkDiscSpec 1) (mkDiscSpec 1) Nil) 
                        (mkTree (mkNode OR) (Cons (mkTree (mkNode D) Nil) (Cons (mkTree (mkNode E) Nil) Nil))))) 
                            (mkTree (mkNode OR) (Cons (mkTree (mkNode D) Nil) (Cons (mkTree (mkNode E) Nil) Nil))))

;; isEmpty
! (assertEqual (isEmpty (mkNullVex (Cons NullVertex Nil))) True)
! (assertEqual (isEmpty (mkTree (mkNode A) Nil)) False)
! (assertEqual (isEmpty (mkTree (mkNode B) (Cons NullVertex Nil))) False)

;; getChildernByIdx

! (assertEqual (getChildrenByIdx (mkTree (mkNode A) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil))) 0) (mkTree (mkNode B) Nil))
! (assertEqual (getChildrenByIdx (mkTree (mkNode X) (Cons (mkTree (mkNode Y) Nil) (Cons (mkTree (mkNode Z) Nil) Nil))) 1) (mkTree (mkNode Z) Nil))
! (assertEqual (getChildrenByIdx (mkNullVex (Cons (mkTree (mkNode P) Nil) (Cons (mkTree (mkNode Q) Nil) Nil))) 0) (mkTree (mkNode P) Nil))
! (assertEqual (getChildrenByIdx (mkNullVex (Cons (mkTree (mkNode R) Nil) (Cons (mkTree (mkNode S) Nil) Nil))) 1) (mkTree (mkNode S) Nil))

;; 