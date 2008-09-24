(require-extension syntax-case check (srfi 11))
(require '../2.3/section)
(import section-2.3)
(let ((S '(117 13 207 170 138 222 145 109 16 248 140)))
  (let-values (((x y) (sum-search S 130)))
    (check x => 13)
    (check y => 117))
  (check (sum-search S 129) => #f))

;;; Returns either i) ordered pair (x, y) that adds to x, or ii) false
;;; if no such pair by sorting the sequence S in O(n lg n); starting
;;; from i = 0 and j = |S'|; returning if the sum S'i + S'j = x, or
;;; recursing upon i + 1 if sum < x or j - 1 if sum > x.
;;; 
;;; i) is demonstrable from the code; ii) depends on the contradiction
;;; that, had, say, i (without loss of generality) crossed some i'
;;; such that S'i' + S'j' = x, Si + Sj should have been greater than
;;; x. But j would have been decremented, not i incremented, resulting
;;; in a contradiction.
