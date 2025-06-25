;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Definition of a List data structure with various methods for it. ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))


;; Fold a tuple from left to right
(: List.foldl (-> (-> $a $b $b) $b (List $a) $b))
; (= (List.foldl $f $i Nil) $i)
; (= (List.foldl $f $i (Cons $h $t)) (chain ($f $h $i) $i' (List.foldl $f $i' $t)))

;; alternative definitions using built-in functions 
(= (List.foldl $f $i $list) 
    (function (eval (if-equal $list Nil
                    (return $i)
                    (unify (Cons $x $xs) $list
                        (chain ($f $x $i) $c
                            (chain (List.foldl $f $c $xs) $result
                                (return $result)))
                    (return (Error $list IncompatibleListType)))))))

; ! (List.foldl + 1 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))))))))))
;; Fold a tuple from right to left
(: List.foldr (-> (-> $a $b $b) $b (List $a) $b))
; (= (List.foldr $f $i Nil) $i)
; (= (List.foldr $f $i (Cons $h $t)) ($f $h (List.foldr $f $i $t)))

;; alternative definition of List.foldr
(= (List.foldr $f $i $list)
    (function (eval (if-equal $list Nil
                        (return $i)
                        (unify (Cons $x $xs) $list
                            (chain ($f $x (List.foldr $f $i $xs)) $result
                                (return $result))
                            (return (Error $list IncompatibleListType)))))))

; ! (List.foldr + 1 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))))))))))
;; Define List.sum
(: List.sum (-> (List Number) Number))
(= (List.sum $xs) (List.foldr + 0 $xs))

;; alternative definition of List.sum
; (= (List.sum $list) (function (chain (List.foldr + 0 $list) $result (return $result))))

;; Testing List.sum
; ! (List.sum (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))))))))))
;; 
(: List.append (-> $a (List $a) (List $a)))
(= (List.append $val Nil) (Cons $val Nil))
(= (List.append $val (Cons $head $tail)) (Cons $head (List.append $val $tail)))

;; Get an element by index from a list
; (: List.getByIdx (-> (List $a) Number $a))
; (= (List.getByIdx Nil $idx) (Error Nil (Index out of range)))
; (= (List.getByIdx (Cons $head $tail) $idx) (if (== $idx 0 ) $head (List.getByIdx $tail (- $idx 1))) )

;; alternative def for List.getByIdx
(= (List.getByIdx $index $list)
    (function 
        (eval (if-equal $list Nil
                (return (Error Nil IndexOutOfRange))
                (unify $list (Cons $h $t)
                    (eval (if-equal $index 0
                            (return $h)
                            (return (List.getByIdx (- $index 1) $t))))
                    (return (Error $list IncompatibleListType)))))))

; ! (List.getByIdx 13 (Cons 1 (Cons 2 (Cons 3 (Cons 1 (Cons 2 (Cons 3 (Cons 1 (Cons 2 (Cons 3 (Cons 1 (Cons 2 (Cons 3 (Cons 1 (Cons 2 (Cons 3 Nil))))))))))))))))

;; Insert an element to a presumably sorted list, remains sorted.
(: List.insert (-> $a (List $a) (List $a)))
; (= (List.insert $x Nil) (Cons $x Nil))
; (= (List.insert $x (Cons $head $tail))
;    (if (< $x $head)
;        (Cons $x (Cons $head $tail))
;        (Cons $head (List.insert $x $tail))))

;; alternative implementation of List.insert
(= (List.insert $x $list)
    (function 
        (eval (if-equal $list Nil
                    (return (Cons $x $list))
                    (unify $list (Cons $h $t)
                        (chain (eval (< $x $h)) $truth
                            (eval (if-equal $truth True
                                    (return (Cons $x $list))
                                    (chain (List.insert $x $t) $r
                                        (return (Cons $h $r))))))
                        (return (Error $list IncompatibleListType)))))))


; ! (List.insert -1 Nil)                                    
; ! (List.insert 13.7 (Cons 0 (Cons 1 (Cons 3 (Cons 4 (Cons 5 (Cons 6 (Cons 7 (Cons 8 (Cons 9 (Cons 10 (Cons 13 (Cons 14 Nil)))))))))))))                                    
;; Sort a List in ascending order
(: List.sort (-> (List $a) (List $a)))
(= (List.sort Nil) Nil)
(= (List.sort (Cons $head $tail)) (List.insert $head (List.sort $tail)))

;; helper function to find the length of the list
(: List.length (-> (List $a) Number))
(= (List.length Nil) 0)
(= (List.length (Cons $head $tail)) (+ 1 (List.length $tail)))

;; alternative implementation of List.length
; (= (List.length $list)
;     (function (eval (if-equal $list Nil
;                 (return 0)
;                 (unify $list (Cons $h $t)
;                     (return (+ 1 (List.length $t)))
;                     (return (Error $list IncompatibleListType)))))))

; ! (List.length (Cons 1 (Cons 2 (Cons a Nil))))                    
; ! (List.length (Cons 1 (Cons 2 (Cons (Cons a) Nil))))                    
;; Map a function over a list
(: List.map (-> (-> $a $b) (List $a) (List $b)))
(= (List.map $f Nil) Nil)
(= (List.map $f (Cons $x $xs)) (Cons ($f $x) (List.map $f $xs)))

;; alternative def for Map a function over a list
; (= (List.map $f $list)
;     (function 
;         (eval (if-equal $list Nil
;             (return $list)
;             (unify $list (Cons $h $t)
;                 (chain ($f $h) $newh
;                     (return (Cons $newh (List.map $f $t))))
;             (return (Error $list UnknowError)))))))

;; Test for List.map
(= (add2 $x) (+ $x 2))

; ! (List.map add2 Nil)
; ! (List.map add2 (Cons 3 (Cons 2 (Cons 4 (Cons 3 (Cons 2 (Cons 4 (Cons 3 (Cons 2 (Cons 4 (Cons 3 (Cons 2 (Cons 4 Nil)))))))))))))

;; Filter a list based on a predicate.
(: List.filter (-> (-> $a Bool) (List $a) (List $a)))
; (= (List.filter $p Nil) Nil)
; (= (List.filter $p (Cons $x $xs)) (if ($p $x) (Cons $x (List.filter $p $xs)) (List.filter $p $xs)))

;; alternative implementation of Filter a list based on a predicate.
(= (List.filter $p $list)
    (function 
        (eval (if-equal $list Nil
                (return $list)
                (unify $list (Cons $h $t)
                       (eval (if-equal ($p $h) True
                            (chain (List.filter $p $t) $r
                                (return (Cons $h $r)))
                            (return (List.filter $p $t))))
                    (return (Error $list UnknowError)))))))
;; Testing List.filter
;; predicate
(: isEven (-> Number Bool))
(= (isEven $x) 
    (function 
        (chain (% $x 2) $r
            (chain (== $r 0) $t
                (return $t)))))
; ! (get-doc if-equal)
! (chain (isEven 4) $b
    (if-equal $b True Yes No))
! (List.filter isEven (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))
; ! (List.filter isEven Nil)
! (if-equal 1 1 2 3)

;; Convert a list to an expression.
(: List.listToExpr (-> (List $a) Expression))
(= (List.listToExpr Nil) ())
(= (List.listToExpr (Cons $x $xs)) (let $t (List.listToExpr $xs) (cons-atom $x $t)))

;; defining List.max function with a comparator that compares non-numerical type values
(: List.max (-> (-> $a $a Bool) (List $a) $a))
; (= (List.max $comparator Nil) Nil)
; (= (List.max $comparator (Cons $x $xs))
;     (if (== $xs Nil)
;         $x
;          (let (Cons $t $u) $xs
;             (if ($comparator $x $t)
;                 (List.max $comparator (Cons $x $u))
;                 (List.max $comparator $xs)))))

;; alternative def for List.max
(= (List.max $op $list)
    (function
        (eval (if-equal $list Nil
            (return Nil)
            (unify $list (Cons $h $t)
                (eval (if-equal $t Nil
                    (return $h)
                    (unify $t (Cons $x $xs)
                        (chain (eval ($op $h $x)) $bool
                            (eval (if-equal $bool True
                                (return (List.max $op (Cons $h $xs)))
                                (return (List.max $op (Cons $x $xs))))))
                            (return (Error $list UnknowError)))))
            (return (Error $list UnknowError))))))) 
! (List.max > Nil)               
! (List.max > (Cons 1 (Cons 2 (Cons 3 Nil))))               
;; Overloading the above List.max with the built in >= comparison operator for operation on List of numbers
(: List.max (-> (List $a) $a))
(= (List.max (Cons $x $xs)) (List.max >= (Cons $x $xs)))

;; Checks if an element is member of a list
(: List.contains (-> $a (List $a) Bool))
(= (List.contains $a Nil) False)
(= (List.contains $a (Cons $head $tail)) (if (== $a $head) True (List.contains $a $tail)))

; Replaces an element at a specific index with another element
(: List.replaceAt (-> (List $a) Number $a (List $a)))
(= (List.replaceAt Nil $n $elem) Nil)
(= (List.replaceAt (Cons $head $tail) $n $elem) 
   (if (== $n 0) (Cons $elem $tail) (Cons $head (List.replaceAt $tail (- $n 1) $elem))))  

;; List.prepend .. adds an element at the beginnig of a list
(: List.prepend (-> $a (List $a) (List $a)))
(= (List.prepend $a $list) (Cons $a $list))

;; Find an element in a list
;; Params: 
;;  $list: The list to search
;;  $target: The element to find
;; Returns: 
;;  The index of the first found element or
;;  -1 If the element can't be found
(: List.index (-> (List $a) $a Number))
(= (List.index Nil $target) -1)
(= (List.index (Cons $x $xs) $target)
    (if (== $x $target)
        0
        (chain (List.index $xs $target) $idx
          (if (< $idx 0)
              $idx
              (+ 1 $idx)))))

;; Return the first element from a list
;; Params:
;;  $list: The list to return from
;; Returns:
;;  The first element of the list
(: List.head (-> (List $a) $a))
(= (List.head Nil) (Error Nil EmptyList))
(= (List.head (Cons $x $xs)) $x)


;; Return the list without its first element
;; Params:
;;  $list: The list to return from
;; Returns:
;;  The rest of the list
(: List.tail (-> (List $a) (List $a)))
(= (List.tail Nil) Nil)
(= (List.tail (Cons $x $xs)) $xs)

;; Subtract list element wise
(: List.sub (-> (List Number) (List Number) (List Number)))
; (= (List.sub Nil Nil) Nil)
; (= (List.sub Nil (Cons $y $ys)) (Error (Cons $y $ys) LenghtOfListNotEqual))
; (= (List.sub (Cons $x $xs) Nil) (Error (Cons $x $xs) LenghtOfListsNotEqual))
; (= (List.sub (Cons $x $xs) (Cons $y $ys)) (Cons (- $x $y) (List.sub $xs $ys)))

;; an alternative implementation of List.sub
(= (List.sub $list1 $list2)
   (let ($len1 $len2) ((List.length $list1) (List.length $list2))
    (if (== $len1 $len2)
        (List.elementWise - $list1 $list2)
        (Error $list1 $list2 LenghtOfListNotEqual))))

(: List.zip (-> (List $a) (List $b) (List ($a $b))))
(= (List.zip Nil Nil) Nil)
(= (List.zip Nil (Cons $y $ys)) Nil)
(= (List.zip (Cons $x $xs) Nil) Nil)
(= (List.zip (Cons $x $xs) (Cons $y $ys)) (Cons ($x $y) (List.zip $xs $ys)))

(: List.zipWith (-> (-> $a $b $c) (List $a) (List $b) (List $c)))
(= (List.zipWith $f Nil Nil) Nil)
(= (List.zipWith $f Nil (Cons $y $ys)) Nil) (= (List.zipWith $f (Cons $x $xs) Nil) Nil) (= (List.zipWith $f (Cons $x $xs) (Cons $y $ys)) (Cons ($f $x $y) (List.zipWith $f $xs $ys)))

(: List.drop (-> Number (List $a) (List $a)))
(= (List.drop $n Nil) Nil)
(= (List.drop $n (Cons $x $xs))
   (if (== $n 0)
       (Cons $x $xs)
       (List.drop (- $n 1) $xs)))

;; Temporary flatten function that works only for list of 
;;  lists where the second list has only single elements.
(: List.flatten (-> (List (List $a)) (List $a)))
(= (List.flatten Nil) Nil)
(= (List.flatten (Cons $x $xs))
    (case $x
       (
         ((Cons $y Nil) (Cons $y (List.flatten $xs)))
         ((Cons $y $ys) (Error $x "Can't be flattened")))))

(: List.repeat (-> Number $a (List $a)))
(= (List.repeat $n $a)
   (if (== $n 0)
       Nil
       (Cons $a (List.repeat (- $n 1) $a))))

;; Concatenates two lists into a single list, preserving element order.
;; Params:
;;   $list1: First list to concatenate.
;;   $list2: Second list to concatenate.
;; Returns:
;;   (List $a) - New list containing all elements of $list1 followed by $list2.
(: List.concat (-> (List $a) (List $a) (List $a)))
(= (List.concat Nil $list2) $list2)
(= (List.concat (Cons $head $tail) $list2)
   (Cons $head (List.concat $tail $list2)))

;; Removes the element at the specified index from the list.
;; Params:
;;   $list: Input list.
;;   $idx: Non-negative index of element to remove (0-based).
;; Returns:
;;   (List $a) - New list with element at $idx removed, or original list if $idx is invalid.
(: List.removeAtIdx (-> (List $a) Number (List $a)))
(= (List.removeAtIdx Nil $idx) Nil)
(= (List.removeAtIdx (Cons $head $tail) $idx)
   (if (< $idx 0) (Cons $head $tail)
       (if (== $idx 0) $tail
           (Cons $head (List.removeAtIdx $tail (- $idx 1))))))

;; Checks if an element exists in a list.
;; Params:
;;   $elem: Element to search for.
;;   $list: Input list to search in.
;; Returns:
;;   Bool - True if $elem is found in $list, False otherwise.
(: List.isMember (-> $a (List $a) Bool))
(= (List.isMember $elem Nil) False)
(= (List.isMember $elem (Cons $head $tail))
   (if (== $elem $head) True
       (List.isMember $elem $tail)))

;; List.partialSort -- sorts the top n values in a list and leaves the rest unsorted      
(: List.partialSort (-> (-> $a $a Bool) (List $a) Number (List $a) (List $a)))
(= (List.partialSort $comparator (Cons $x $xs) $n $acc)
    (let* (($max (List.max $comparator (Cons $x $xs)))
            ($unsortedList (List.delete $max (Cons $x $xs)))
            ($sortedList (List.append $max $acc)))
                
                (if (== (- $n 1) 0)
                    (List.appendList $unsortedList $sortedList)
                    (List.partialSort $comparator $unsortedList (- $n 1) $sortedList))))

;; Overloading the above partialSort for partial Sorting list of numbers -- decreasing order
(: List.partialSort (-> (List Number) Number (List Number) (List Number)))
(= (List.partialSort $list $n $acc) (List.partialSort >= $list $n $acc))          

;; append a list to a list
(: List.appendList (-> (List $a) (List $a) (List $a)))
(= (List.appendList $a (Cons $x $xs))
    (if (== $xs Nil)
        (Cons $x $a)
        (Cons $x (List.appendList $a $xs))))   

;; deletes the first occurence of an item in the list
(: (List.delete (-> $a (List $a) (List $a))))
(= (List.delete $a Nil) (Error Nil "empty list"))
(= (List.delete $a (Cons $x $xs))
    (if (== $x $a)
        $xs
        (Cons $x (List.delete $a $xs))))        

;; List.takeN -- takes the first N members of a list 
(: List.takeN (-> Number (List $a) (List $a)))
(= (List.takeN $n Nil) Nil)
(= (List.takeN $n (Cons $x $xs)) 
    (if (== $n 0)
        Nil
        (let $t (List.takeN (- $n 1) $xs) (Cons $x $t))))

;; List.takeNFrom -- takes N members starting from given start position position 
(: List.takeNFrom (-> Number Number (List $a) (List $a)))
(= (List.takeNFrom $start $n Nil) Nil)
(= (List.takeNFrom $start $n (Cons $x $xs))
    (if (== $n 0)
        Nil
        (if (== $start 0)
            (List.takeN $n (Cons $x $xs))
            (List.takeNFrom (- $start 1) $n $xs))))

;; element wise operations
(: List.elementWise (-> (-> $a $a $a) (List $a) (List $a)))
(= (List.elementWise $op Nil Nil) Nil)
(= (List.elementWise $op (Cons $x $xs) (Cons $y $ys))
    (Cons ($op $x $y) (List.elementWise $op $xs $ys)))            