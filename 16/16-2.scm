(require-extension syntax-case check)
(require '../16/chapter)
(import chapter-16)
(let ((tasks (list
              (make-task 0 3 #f #f)
              (make-task 1 7 #f #f)
              (make-task 2 13 #f #f)
              (make-task 3 6 #f #f)
              (make-task 4 1 #f #f)
              )))
  (let ((scheduled-tasks (non-preemptive-schedule tasks)))
    (check (map task-id scheduled-tasks) => '(4 0 3 1 2))
    (check (average-completion scheduled-tasks) => (/ 62 5))))

(let ((tasks (list
              (make-task 0 3 3 #f)
              (make-task 1 7 3 #f)
              (make-task 2 13 1 #f)
              (make-task 3 6 5 #f)
              (make-task 4 1 7 #f)
              )))
  (let ((scheduled-tasks (preemptive-schedule tasks)))
    (check (map task-id scheduled-tasks) =>
           '(2 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1
               1 3 3 3 3 3 4 3 0 0 0 2 2 idle))
    (check (average-completion tasks) => (/ 73 5))))
