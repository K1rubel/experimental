;; insert above
;; Description -- inserts flipped logical operator over arguments in an exemplar tree
;; This expression (AND A B) -- would turn in to (AND (OR A) (OR B))

(AND A B)
(mkTree (mkNode AND) 
    (Cons (mkTree (mkNode A) Nil) 
    
        (Cons (mkTree (mkNode B) Nil)) Nil)) --> would turn into something like this

(AND (OR A) (OR B)) or in tree terms

(mkTree (mkNode AND) 

    (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode A) Nil) Nil)) 
        
        (Cons (mkTree (mkNode OR) (Cons (mkTree (mkNode B) Nil) Nil)) Nil)))

;; let use the expression type representation first to insert flipped operator above argument type

(: isLiteral (-> $a Bool))
(= (isLiteral $atom)
    (if (or (== (get-metatype $atom) Symbol) (== (get-metatype $atom) Grounded)) 
        True
        (unify $atom (NOT $exp) (not (== (get-metatype $exp) Expression)) False)))

(= (flippedHead $expr)
    (let* ((($f $t) (decons-atom $expr))
            ($c (flipArg $f $t)))

            (cons-atom $f $c)))

(= (flipArg $head $args) 
    (if (== $args ())
        $args
        (let* ((($f $t) (decons-atom $args))
                ($c (flipArg $head $t))
                ($h (if (isLiteral $f) (case $head ((AND (OR $f)) (OR (AND $f)))) $f)))
                
                (cons-atom $h $c))))

! (flippedHead (AND A B (NOT C)))
! (flippedHead (AND A B (AND C)))
