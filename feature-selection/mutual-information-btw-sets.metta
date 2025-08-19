(= (mutualInformationBtwSets $set1 $set2 (mkITable $table $labels))
    (let* (($union (union-atom $set1 $set2))
            ($len (List.length $table))         ;; total number of rows
            ($set1-zip (zipColumn $set1 (mkITable $table $labels)))
            ($set2-zip (zipColumn $set2 (mkITable $table $labels)))
            ($union-zip (zipColumn $union (mkITable $table $labels)))
            ($set1-count (List.uniqueValuesCount $set1-zip ()))
            ($set2-count (List.uniqueValuesCount $set2-zip ()))                         ;; there is a possibility of using map-atom here for similar scores
            ($union-count (List.uniqueValuesCount $union-zip ()))                       ;; like this --> (($set1-count $set2-count $union-count) (map-atom ($set1-zip $set2-zip $union-zip) $set (List.uniqueValuesCount $set ())))
            (($e1 $e2 $eu) (map-atom ($set1-count $set2-count $union-count) $count (entropy $count $len 0))))
        
        (- (+ $e1 $e2) $eu)))
