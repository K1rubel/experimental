! (register-module! ../../../experiments)
! (import! &self experiments:experimental:tree-type)
! (import! &self experiments:experimental:list-related)
! (import! &self experiments:experimental:todos:helpers)
! (import! &self experiments:experimental:todos:append)
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
! (assertEqual (isEmpty (mkNullVex Nil)) True)
! (assertEqual (isEmpty (mkTree (mkNode A) Nil)) False)
! (assertEqual (isEmpty (mkTree (mkNode B) (Cons NullVertex Nil))) False)

;; appendTo
;; invalid disc specification
! (assertEqual
  (appendTo
    (mkTree (mkNode OR) Nil)
    (mkLSK
      (mkDiscKnob
        (mkKnob (mkTree (mkNode OR) Nil) (mkNodeId 0))
        (mkMultip 1)
        (mkDiscSpec 4)
        (mkDiscSpec 0)
        Nil)
      (mkTree (mkNode A) Nil)))
  (Error 4 "Invalid disc specification:- cannot exceed 2."))
;; appending to empty tree
! (assertEqual
  (appendTo
    (mkNullVex  Nil)
            (mkLSK
            (mkDiscKnob (mkKnob (mkNullVex Nil) (mkNodeId 0)) (mkMultip 1) (mkDiscSpec 1) (mkDiscSpec 0) Nil)
            (mkTree (mkNode AND)
                (Cons (mkTree (mkNode P) Nil) Nil))))
                    (mkTree (mkNode AND)
                        (Cons (mkTree (mkNode P) Nil) Nil)))
;; insertion at a node
! (assertEqual
  (appendTo (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil)
        (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
            Nil)) Nil)))
    (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil)
              (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
                Nil)) Nil)))
            (mkNodeId (2))) (mkMultip 3) (mkDiscSpec 2) (mkDiscSpec 1) Nil) (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)))) 
              (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode NOT) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil)) Nil))))

! (assertEqual
  (appendTo (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil)
        (Cons (mkTree (mkNode AND) (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
            Nil)) Nil)) Nil)))
    (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil)
        (Cons (mkTree (mkNode AND) (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil)))
            Nil)) Nil)) Nil)))
            (mkNodeId (2 1))) (mkMultip 3) (mkDiscSpec 2) (mkDiscSpec 1) Nil) (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)))) 
              (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode NOT) (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil)) Nil)) Nil))))

! (assertEqual
  (appendTo
    (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil)
      (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil))) Nil)) Nil)))
    (mkLSK (mkDiscKnob (mkKnob (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil)
                    (Cons (mkNullVex (Cons (mkTree (mkNode AND) (Cons (mkTree (mkNode X) Nil) (Cons (mkTree (mkNode Y) Nil) Nil))) Nil)) Nil)))
                      (mkNodeId (2)))
        (mkMultip 3) (mkDiscSpec 2) (mkDiscSpec 0) Nil)
      (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil))))
    
    (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode NOT) (Cons (mkTree (mkNode B) Nil) Nil)) Nil))))