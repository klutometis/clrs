(define-record-type :task
  (make-task id remaining release completion)
  task?
  (id task-id)
  (remaining task-remaining set-task-remaining!)
  (release task-release)
  (completion task-completion set-task-completion!))

(define (make-task-queue tasks)
  (make-heap task-remaining
             set-task-remaining!
             <
             +inf
             (length tasks)
             tasks))

(define (non-preemptive-schedule tasks)
  (let ((queue (make-task-queue tasks)))
    (build-heap! queue)
    (let ((ordered-tasks (heapsort! queue)))
      (fold (lambda (new-task old-completion)
              (let ((new-completion
                     (+ old-completion (task-remaining new-task))))
                (set-task-remaining! new-task 0)
                (set-task-completion! new-task new-completion)
                new-completion))
            0
            ordered-tasks)
      ordered-tasks)))

(define (preemptive-schedule tasks)
  (let* ((releases (map task-release tasks))
         (releasable-tasks
          (alist->hash-table
           (map (cut cons <> (make-task-queue '())) releases))))
    (for-each
     (lambda (task)
       (let ((releasable-tasks
              (hash-table-ref releasable-tasks (task-release task))))
         (heap-insert! releasable-tasks task)))
     tasks)
    (let ((idle-task (make-task 'idle +inf -1 #f))
          (idle? (lambda (task) (eq? (task-id task) 'idle)))
          (queued-tasks (make-task-queue '())))
      (let ((iter
             (rec (iter timeline current-task time)
                  (if (and (zero? (hash-table-size releasable-tasks))
                           (heap-empty? queued-tasks)
                           (idle? current-task))
                      timeline
                      (let ((released-tasks
                             (hash-table-ref/default releasable-tasks time #f)))
                        (if released-tasks
                            (begin
                              (heap-union! queued-tasks released-tasks)
                              (hash-table-delete! releasable-tasks time)))
                        (let ((preemptive-task
                               (if (heap-empty? queued-tasks)
                                   #f
                                   (let ((task (heap-extremum queued-tasks)))
                                     (if (< (task-remaining task)
                                            (task-remaining current-task))
                                         task
                                         #f)))))
                          (let ((current-task
                                 (if (idle? current-task)
                                     (if (heap-empty? queued-tasks)
                                         idle-task
                                         (heap-extract-extremum!
                                          queued-tasks))
                                     (if preemptive-task
                                         (let ((preemptive-task
                                                (heap-extract-extremum!
                                                 queued-tasks)))
                                           (heap-insert! queued-tasks
                                                         current-task)
                                           preemptive-task)
                                         current-task))))
                            (set-task-remaining!
                             current-task
                             (- (task-remaining current-task) 1))
                            (iter (cons current-task timeline)
                                  (if (zero? (task-remaining current-task))
                                      (begin
                                        (set-task-completion! current-task time)
                                        idle-task)
                                      current-task)
                                  (+ time 1)))))))))
        (iter '() idle-task 0)))))

(define (average-completion tasks)
  (let ((n (length tasks)))
    (/ (apply + (map task-completion tasks)) n)))
