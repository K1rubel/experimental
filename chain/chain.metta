;; checking how chain works
;; better form of let binding for multiple consecutively passed down variables
;; instead of wrting sth like this
! (let* (($a (pow-math 3 2))
        ($b (* $a $a))
        ($c (% $b 5)))
        
        (+ $c 41))
;; it executes faster to write the above with nested chain statements like this

! (chain (pow-math 3 2) $a
    (chain (* $a $a) $b
        (chain (% $b 5) $c
            (+ $c 41))))