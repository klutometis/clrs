(require-extension syntax-case check)
(require '../16/chapter)
(import chapter-16)
;;; a. Minimizing the average is a matter of minimizing large numbers;
;;; therefore, schedule smaller tasks first. O(n lg n) to heapify and
;;; systematically extract-min.
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

;;; b. The same principle of minimizing large numbers applise; when a
;;; task is released, therefore, if its remaining time is less than
;;; the remaining time of the current task, put the current task back
;;; in the priority queue and preempt it with the lesser task.
;;;
;;; Otherwise, systematically extract the task with the least
;;; remaining time from the priority queue.
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
