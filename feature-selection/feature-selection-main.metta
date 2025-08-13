;; the c++ version starts logging feature selection options 
;; reads in the data table
;; checks if subsampling ratio is < 1 ===> if so do a subsampling -> subsampleTable
;; the sub sampler -- just removes a number of rows from the input table by random
;; this is done to reduce a potentailly large data into managable size
;; nrow -- to be removed
;; 
(= (subsampleTable $nrow $table)
    (let $t-size (List.length $table)
        (subSampleHelper $nrow $t-size $table)))

;; helper -- subSampleHelper
(= (subSampleHelper $nrow $t-size $table)
    (if (== $t-size $nrow)
        $table
        (let* (($row-index (random-int 0 $t-size))
                ($new-table (List.pop $row-index $table)))
            (subSampleHelper $nrow (- $t-size 1) $new-table ))))
    
;; then red           


;; can a dorepeat kind of function be defined for metta/log

; (: until (-> (-> $a Bool) (-> $a $a) $a $a))
; (= (until $predicate $function $x) (if ($predicate $x) $x (let $x' ($function $x) (until $predicate $function $x'))))