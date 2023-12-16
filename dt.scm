(define directory-separator "/")

(define stride-to-line 3)

(define pipe-char #\x2502)

(define printer
  (lambda (text)
    (display text)
    (newline)))

(define place-pipes
  (lambda (space dv count length is-last)
    (when (< count length)
      (string-set! space (* dv count) pipe-char)
      (place-pipes space dv (+ 1 count) length is-last))))

(define graph
  (lambda (level is-last)
    (let* ((pad (* (- level 1) stride-to-line))
           (space (vector->string (make-vector pad #\space))))
      (when (> level 1)
        (place-pipes space stride-to-line 0 (- level 1) is-last))
      space)))

(define draw
  (lambda (level current last text)
    (printer
     (if (= level 0)
         text
         (string-append
          (graph level (= 0 (- last current)))
          (if (= 0 (- last current)) "└─" "├─")
          " "
          text)))))

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
    (file-sort
     (map (lambda (f)
            (cons (string-concatenate (list base-path f)
                                      directory-separator)
                  f))
          fs))))

(define -traverse-directory
  (lambda (level current last path filename)
    (case (file-type path)
      ((directory)
       (draw level current last filename)
       (let* ((fs (directory-files path))
              (count (- (length fs) 1))
              (next 0))
         (for-each
          (lambda (the-file)
            (-traverse-directory
             (+ 1 level)
             next
             count
             (car the-file)
             (cdr the-file))
            (set! next (+ 1 next)))
          (list-directory-sorted path fs))))
      ((regular)
       (draw level current last filename)))))

(define traverse-directory
  (lambda (path)
    (-traverse-directory 0 0 0 path path)))
