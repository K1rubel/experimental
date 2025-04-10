! (register-module! ../../experimental)
! (import! &self experimental:tree-size)
! (import! &self experimental:tree-type)
! (import! &self experimental:list-related)

! (sizeAtom (AND A (OR B (C D))))
! (treeSize (mkTree (mkNode AND) (Cons (mkTree (mkNode A) Nil) (Cons (mkTree (mkNode B) Nil) (Cons (mkTree (mkNode C) Nil) Nil)))))