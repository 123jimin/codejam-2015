(define in (open-input-file "A-large.in"))
(define T (string->number (read-line in)))

(define (compute-a1 ls pv ca1 mx)
	(if (empty? ls)
		(cons ca1 mx)
		(let (
			[cur_dec (max 0 (- pv (first ls)))]
		) (compute-a1 (rest ls) (first ls) (+ ca1 cur_dec) (max mx cur_dec)))))

(define (compute-a2 ls mx ca2)
	(if (empty? (rest ls)) ca2 (compute-a2 (rest ls) mx (+ ca2 (min (first ls) mx)))))

(define (compute ls) (let (
	[a1p (compute-a1 (rest ls) (first ls) 0 0)]
	) (cons (car a1p) (compute-a2 ls (cdr a1p) 0))))

(define (process ti) (begin (read-line in)
	(let (
		[answer (compute (map string->number (regexp-split #rx" " (read-line in))))]
	) (printf "Case #~s: ~s ~s~n" ti (car answer) (cdr answer)))))

(define (process-loop ti)
	(if (<= ti T)
		(begin (process ti) (process-loop (+ ti 1)))
		ti))

(process-loop 1)
