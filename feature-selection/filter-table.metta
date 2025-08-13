;; filterTable -- filters table containig only features in $ft-to-remove

(= (filterTable $ft-to-remove (mkITable $table $labels))
    (if-decons-expr $ft-to-remove $h $t
        (let* (($filtered-data (Table.pop $h $table))
                ($filtered-label (List.pop $h $labels)))
            
            (filterTable $t (mkITable $filtered-data $filtered-label)))
        (mkITable $table $labels)))   

;; Table.pop        
;;                  -- returns the remaining table 
;; XXX same table pop but very simplified version has been used in previous feature selection implementations
;; This takes value of the column as tuples as well -- a general version 
(= (Table.pop $i $rows)
    (unify $rows Nil Nil
        (unify $rows (Cons (Cons $d $ds) $rest)  ;; $d and $ds for data and rest of data
            (if (== $i 0)
                (Cons $ds (Table.pop $i $rest))
                (Cons (Cons $d (List.pop (- $i 1) $ds)) (Table.pop $i $rest))))))

