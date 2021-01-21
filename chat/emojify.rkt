#lang racket
(require 2htdp/image)

;; all but the final few emojis are from here:
;; https://github.com/twitter/twemoji/tree/master/assets/72x72
;; I weeded out a few seemed interesting/commmon
;; the rest are from the cmsc388q website
(define BASE-URL "https://raw.githubusercontent.com/twitter/twemoji/master/assets/72x72/")
(define SCALE .25)

;; hash table of string, emoji pairs
;; unfortunately, takes a second to load as each image is fetched at runtime
;; a more optimized version would have local image files
(define emoji-list
  (make-hash
   (list
    (cons "thinking" (scale SCALE (bitmap/url (string-append BASE-URL "1f914.png"))))
    (cons "happy-blush" (scale SCALE (bitmap/url (string-append BASE-URL "1f60a.png"))))
    (cons "satisfied" (scale SCALE (bitmap/url (string-append BASE-URL "1f60c.png"))))
    (cons "love" (scale SCALE (bitmap/url (string-append BASE-URL "1f60d.png"))))
    (cons "cool" (scale SCALE (bitmap/url (string-append BASE-URL "1f60e.png"))))
    (cons "smug" (scale SCALE (bitmap/url (string-append BASE-URL "1f60f.png"))))
    (cons "uh-oh" (scale SCALE (bitmap/url (string-append BASE-URL "1f61f.png"))))
    (cons "snoore" (scale SCALE (bitmap/url (string-append BASE-URL "1f62a.png"))))
    (cons "stress" (scale SCALE (bitmap/url (string-append BASE-URL "1f62b.png"))))
    (cons "cheesin" (scale SCALE (bitmap/url (string-append BASE-URL "1f62c.png"))))
    (cons "crying" (scale SCALE (bitmap/url (string-append BASE-URL "1f62d.png"))))
    (cons "angry" (scale SCALE (bitmap/url (string-append BASE-URL "1f92c.png"))))
    (cons "happy" (scale SCALE (bitmap/url (string-append BASE-URL "1f601.png"))))
    (cons "angel" (scale SCALE (bitmap/url (string-append BASE-URL "1f607.png"))))
    (cons "devil" (scale SCALE (bitmap/url (string-append BASE-URL "1f608.png"))))
    (cons "hard-frown" (scale SCALE (bitmap/url (string-append BASE-URL "1f620.png"))))
    (cons "hmph" (scale SCALE (bitmap/url (string-append BASE-URL "1f624.png"))))
    (cons "sorry" (scale SCALE (bitmap/url (string-append BASE-URL "1f625.png"))))
    (cons "blank" (scale SCALE (bitmap/url (string-append BASE-URL "1f626.png"))))
    (cons "scream" (scale SCALE (bitmap/url (string-append BASE-URL "1f631.png"))))
    (cons "woah" (scale SCALE (bitmap/url (string-append BASE-URL "1f632.png"))))
    (cons "embarrassed" (scale SCALE (bitmap/url (string-append BASE-URL "1f633.png"))))
    (cons "snoozin" (scale SCALE (bitmap/url (string-append BASE-URL "1f634.png"))))
    (cons "dead" (scale SCALE (bitmap/url (string-append BASE-URL "1f635.png"))))
    (cons "mask-up" (scale SCALE (bitmap/url (string-append BASE-URL "1f637.png"))))
    (cons "frown" (scale SCALE (bitmap/url (string-append BASE-URL "1f641.png"))))
    (cons "smile" (scale SCALE (bitmap/url (string-append BASE-URL "1f642.png"))))
    (cons "upside-down" (scale SCALE (bitmap/url (string-append BASE-URL "1f643.png"))))
    (cons "eye-roll" (scale SCALE (bitmap/url (string-append BASE-URL "1f644.png"))))
    (cons "nerd" (scale SCALE (bitmap/url (string-append BASE-URL "1f913.png"))))
    (cons "robot" (scale SCALE (bitmap/url (string-append BASE-URL "1f916.png"))))
    (cons "clown" (scale SCALE (bitmap/url (string-append BASE-URL "1f921.png"))))
    (cons "ill" (scale SCALE (bitmap/url (string-append BASE-URL "1f922.png"))))
    (cons "feelin-loved" (scale SCALE (bitmap/url (string-append BASE-URL "1f970.png"))))
    (cons "yawn" (scale SCALE (bitmap/url (string-append BASE-URL "1f971.png"))))
    (cons "party" (scale SCALE (bitmap/url (string-append BASE-URL "1f973.png"))))
    (cons "hot" (scale SCALE (bitmap/url (string-append BASE-URL "1f975.png"))))
    (cons "cold" (scale SCALE (bitmap/url (string-append BASE-URL "1f976.png"))))
    (cons "imposter" (scale SCALE (bitmap/url (string-append BASE-URL "1f978.png"))))
    (cons "ship-green" (scale SCALE (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipGreen_manned.png")))
    (cons "ship-yellow" (scale SCALE (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipYellow_manned.png")))
    (cons "ship-pink" (scale SCALE (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipPink_manned.png")))
    (cons "ship-blue" (scale SCALE (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png"))))))

(provide emoji-list)