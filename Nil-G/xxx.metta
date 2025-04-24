; Nil Geisweiller
(= (and $x True) $x)
(= (and $x (and $y)) (and $x $y))
; Nil Geisweiller

(and a b c)
->
(and a (and b c))
; Nil Geisweiller

(: PROOF (EnfOf $enf-cnd $cnd))
(: PROOF (Enf $cnd $enf-cnd))
; Nil Geisweiller

(: $prf (Enf $cnd $enf-cnd))
(: $prf (Enf (and ...) $enf-cnd))
; Nil Geisweiller

(-> (Enf $x $enf-x) (Enf $y $enf-y) (and $enf-x $enf-y))
(-> (Enf $x $enf-x) (Enf $y $enf-y) (Enf (and $x $y) (and $enf-x $enf-y)))
; Nil Geisweiller

(-> (Enf $x $enf-x) (Enf $y $enf-y) (TowardsEnf (and $x $y) (and $enf-x $enf-y)))