(define-record-type :task
  (make-task id remaining release completion)
  task?
  (id task-id)
  (remaining task-remaining set-task-remaining!)
  (release task-release)
  (completion task-completion set-task-completion!))

(define (non-preemptive-schedule tasks)
  (let ((queue (make-heap task-remaining
                          set-task-remaining!
                          <
                          +inf
                          (length tasks)
                          tasks)))
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

(define (average-completion tasks)
  (let ((n (length tasks)))
    (/ (apply + (map task-completion tasks)) n)))
