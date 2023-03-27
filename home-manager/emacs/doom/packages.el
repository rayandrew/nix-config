;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! benchmark-init)
(package! org-auto-tangle)
(package! org-web-tools)
(package! rainbow-mode)
(package! org-roam
  :recipe (:host github :repo "org-roam/org-roam" :branch "main"))
(package! dash)
(package! citar-org-roam)
(package! org-roam-ui)
;; (package! emacsql-sqlite-builtin)
