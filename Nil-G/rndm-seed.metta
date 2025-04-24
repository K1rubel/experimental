;; to set random seed
; ! (set-random-seed &rng 42)

;; random int generator with 
; ! (random-int &rng 0 10)


;; concat charaters into a string
; !(charsToString ('A' 'C' 'R')) ;; "ACR"   

;; the following too works just fine
; ! (let* (($a "be")
;         ($b "ice")) (charsToString ( $a " " $b)) )
;; numStr -- python binding for  number to string conversion
; ! (bind! numStr (py-atom str))

