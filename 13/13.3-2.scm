(load "red-black-tree.scm")
(use red-black-tree test)

(let* ((root nil)
       (root (insert! root (make-node key: 41)))
       (root (insert! root (make-node key: 38)))
       (root (insert! root (make-node key: 31)))
       (root (insert! root (make-node key: 12)))
       (root (insert! root (make-node key: 19)))
       (root (insert! root (make-node key: 8))))
  (test
   "insertion of successive keys"
   '((38 . black)
     ((21 . red)
      ((19 . black)
       ((8 . red) (#f . black) (#f . black)) (#f . black))
      ((31 . black) (#f . black) (#f . black)))
     ((41 . black) (#f . black) (#f . black)))
   (tree->pre-order-key-color-list root)))
