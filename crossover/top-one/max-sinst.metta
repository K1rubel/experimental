; Type signature
(: maxSInstByCscore (-> mkSInstSet mkSInst))

; Helper to extract Cscore from SInst
(: getCscoreFromSInst (-> mkSInst Cscore))
(= (getCscoreFromSInst $sinst)
   (let (($pair (getPair $sinst)))
       (getCscore $pair))) ; Assuming getCscore works like (get second from pair)

; Helper recursive function
(: maxSInstByCscoreHelper (-> (List mkSInst) mkSInst mkSInst))
(= (maxSInstByCscoreHelper Nil $max) $max)
(= (maxSInstByCscoreHelper (Cons $head $tail) $max)
   (let (($c1 (getCscoreFromSInst $head))
         ($c2 (getCscoreFromSInst $max)))
        (if (cScore>= $c1 $c2)
            (maxSInstByCscoreHelper $tail $head)
            (maxSInstByCscoreHelper $tail $max))))

; Main function
(= (maxSInstByCscore $set)
   (let (($list (unpackSInstSet $set))) ; Extract list from mkSInstSet
        (match $list
            (Cons $head $tail) (maxSInstByCscoreHelper $tail $head)
            _ (error "Empty mkSInstSet"))))
