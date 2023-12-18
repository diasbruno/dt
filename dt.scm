(define directory-separator "/")

(define stride-to-line 3)

(define pipe-char #\x2502)

(define empty-string "")

(define space-string " ")

(define corner-string  "└─")
(define divisor-string  "├─")

(define graph
  (lambda (level is-last)
    (if (<= level 1)
        empty-string
        (let* ((space (vector->string (make-vector stride-to-line #\space))))
          (when (not is-last)
            (string-set! space 0 pipe-char))
          space))))

(define draw
  (lambda (level current last text lines)
    (display
     (if (= level 0)
         text
         (string-append
          lines
          (if (= 0 (- last current))
              corner-string
              divisor-string)
          space-string
          text)))
    (newline)))

(define directory?
  (lambda (name) (equal? 'directory (file-type name))))

(define file-sort
  (lambda (fs)
    (call-with-values
        (lambda () (partition (lambda (f) (directory? (car f))) fs))
      (lambda (a b) (append (list-sort! (lambda (a b) (string<? (cdr a) (cdr b))) a)
                       (list-sort! (lambda (a b) (string<? (cdr a) (cdr b))) b))))))

(define list-directory-sorted
  (lambda (base-path fs)
    (define (xxx f)
      (cons (string-concatenate (list base-path f)
                                directory-separator)
            f))
    (file-sort (map xxx fs))))

(define -traverse-directory
  (lambda (level current last path filename line)
    (let ((is-last (= last current)))
      (case (file-type path)
        ((directory)
         (draw level current last filename line)
         (let* ((fs (directory-files path))
                (count (- (length fs) 1))
                (next 0)
                (next-line (string-append line (graph (+ 1 level) is-last))))
           (for-each
            (lambda (the-file)
              (-traverse-directory
               (+ 1 level)
               next
               count
               (car the-file)
               (cdr the-file)
               next-line)
              (set! next (+ 1 next)))
            (list-directory-sorted path fs))))
        ((regular)
         (draw level current last filename line))))))

(define traverse-directory
  (lambda (path)
    (-traverse-directory 0 0 0 path path "")))

(let ((path (if (= 0 (length (command-args)))
               "."
               (car (command-args)))))
 (traverse-directory path))
