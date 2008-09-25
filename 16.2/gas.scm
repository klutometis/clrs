(define (minimize-stops stations full-tank)
  (let ((iter
         (rec (iter stops passed yet-to-pass gas)
              (if (null? yet-to-pass)
                  stops
                  (let ((last-station (car passed))
                        (next-station (car yet-to-pass)))
                    (let ((distance (- next-station last-station))
                          (passed (cons next-station passed))
                          (yet-to-pass (cdr yet-to-pass)))
                      (if (<= gas distance)
                          (iter (cons last-station stops)
                                passed
                                yet-to-pass
                                (- full-tank distance))
                          (iter stops
                                passed
                                yet-to-pass
                                (- gas distance)))))))))
    (let ((incipit (car stations)))
      (iter (list incipit) (list incipit) stations full-tank))))
