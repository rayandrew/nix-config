;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Shamelessly copied from https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/doom/config.org?plain=1

(setq doom-theme 'doom-gruvbox)

(setq user-full-name "Ray Andrew"
      user-mail-address "rs@rs.ht")

(setq +rs/my-font "UbuntuMono Nerd Font Mono"
      doom-font (font-spec :family +rs/my-font :size 20)
      doom-variable-pitch-font (font-spec :family +rs/my-font :size 20)
      doom-big-font (font-spec :family +rs/my-font :size 20))

;;; to disable frame in emacsclient
;; (after! persp-mode
;;   (setq persp-emacsclient-init-frame-behaviour-override "main"))

(map! :leader
      (:prefix ("=" . "open file")
       :desc "Edit agenda file"      "a" #'(lambda () (interactive) (find-file "~/Cloud/Org/agenda.org"))
       :desc "Edit doom config.el"  "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.el"))
       :desc "Edit doom init.el"     "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))))
(map! :leader
      (:prefix ("= e" . "open eshell files")
       :desc "Edit eshell aliases"   "a" #'(lambda () (interactive) (find-file "~/.config/doom/eshell/aliases"))
       :desc "Edit eshell profile"   "p" #'(lambda () (interactive) (find-file "~/.config/doom/eshell/profile"))))

(map! "C-h" #'evil-window-left
      "C-k" #'evil-window-up
      "C-l" #'evil-window-right)
(map! :map 'override "C-j" #'evil-window-down)

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/Cloud/Org/"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-leading-bullet ?\s
        org-superstar-headline-bullets-list '("*" "*" "*" "*" "*" "*" "*")
        ; org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿")
        ; org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '(;; Sequence for TASKS
            ;; TODO means it's an item that needs addressing
            ;; WAITING means it's dependent on something else happening
            ;; DELEGATED means someone else is doing it and I need to follow up with them
            ;; ASSIGNED means someone else has full, autonomous responsibility for it
            ;; CANCELLED means it's no longer necessary to finish
            ;; DONE means it's complete
            (sequence "TODO(t@/!)" "WAITING(w@/!)" "DELEGATED(e@/!)" "|" "ASSIGNED(.@/!)" "CANCELLED(x@/!)" "DONE(d@/!)" )
            ;; Sequence for RESEARCH
            (sequence "RESEARCH(r@/!)" "IDEA(i@/!)" "|" "IMPLEMENTED(x@/!)" "POSTPONED(n@/!)")
            ;; Sequence for EVENTS
            ;; VISIT means that there is something you would physically like to do, no dates associated
            ;; DIDNOTGO means the event was cancelled or I didn't go
            ;; MEETING means a real time meeting, i.e. at work, or on the phone for something official
            ;; VISITED means the event took place and is no longer scheduled
            (sequence "VISIT(v@/!)" "|" "DIDNOTGO(z@/!)" "MEETING(m@/!)" "VISITED(y@/!)")
            (sequence )
            ))) ; Task has been cancelled

(after! org
  (setq org-agenda-files '("~/Cloud/Org/agenda.org")))

(after! org-fancy-priorities
  (setq
     ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
     ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
     org-fancy-priorities-list '("🟥" "🟧" "🟨")
     org-priority-faces
     '((?A :foreground "#ff6c6b" :weight bold)
       (?B :foreground "#98be65" :weight bold)
       (?C :foreground "#c678dd" :weight bold))
     org-agenda-block-separator 8411))

(setq org-agenda-tags-todo-honor-ignore-options t)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags-todo "PRIORITY=\"A\" -IGNORED"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "IGNORED")))
                 (org-agenda-overriding-header "🟥 High priority:")))
          (tags-todo "RESEARCH -IGNORED"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "IGNORED")))
                 (org-agenda-overriding-header "⁖ RESEARCH:")))
          (tags-todo "PRIORITY=\"B\" -IGNORED"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "IGNORED")))
                 (org-agenda-overriding-header "🟧 Medium priority:")))
          (tags-todo "PRIORITY=\"C\" -IGNORED"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "IGNORED")))
                 (org-agenda-overriding-header "🟨 Low-priority:")))
          (tags-todo "UCARE -IGNORED"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "IGNORED")))
                 (org-agenda-overriding-header "● UCARE:")))

          (agenda "")
          (alltodo "")))))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun dt/insert-auto-tangle-tag ()
  "Insert auto-tangle tag in a literate config."
  (interactive)
  (evil-org-open-below 1)
  (insert "#+auto_tangle: t ")
  (evil-force-normal-state))

(map! :leader
      :desc "Insert auto_tangle tag" "i a" #'dt/insert-auto-tangle-tag)

(setq org-journal-dir "~/Cloud/Org/journal/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

(defun dt/org-colors-doom-one ()
  "Enable Doom One colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.35 "#51afef" ultra-bold)
         (org-level-2 1.3 "#c678dd" extra-bold)
         (org-level-3 1.25 "#98be65" bold)
         (org-level-4 1.2 "#da8548" semi-bold)
         (org-level-5 1.15 "#5699af" normal)
         (org-level-6 1.1 "#a9a1e1" normal)
         (org-level-7 1.05 "#46d9ff" normal)
         (org-level-8 1.0 "#ff6c6b" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))


(defun dt/org-colors-gruvbox-dark ()
  "Enable Gruvbox Dark colors for Org headers."
  (interactive)
  ;; (dolist
  ;;     (face
  ;;      '((org-level-1 1 "#458588" ultra-bold)
  ;;        (org-level-2 1 "#b16286" extra-bold)
  ;;        (org-level-3 1 "#98971a" bold)
  ;;        (org-level-4 1 "#fb4934" semi-bold)
  ;;        (org-level-5 1 "#83a598" normal)
  ;;        (org-level-6 1 "#d3869b" normal)
  ;;        (org-level-7 1 "#d79921" normal)
  ;;        (org-level-8 1 "#8ec07c" normal)))
  ;;   (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(after! org
  (dt/org-colors-gruvbox-dark))

(after! org
  (setq org-roam-directory "~/Cloud/Org/roam/"
        org-roam-graph-viewer "/usr/bin/brave"
        org-roam-completion-everywhere t))

(map! :leader
      (:prefix ("n r" . "org-roam")
       :desc "Completion at point" "c" #'completion-at-point
       :desc "Find node"           "f" #'org-roam-node-find
       :desc "Show graph"          "g" #'org-roam-graph
       :desc "Insert node"         "i" #'org-roam-node-insert
       :desc "Capture to node"     "n" #'org-roam-capture
       :desc "Toggle roam buffer"  "r" #'org-roam-buffer-toggle))

(after! org
  (setq +org-capture-todo-file "agenda.org"
         org-capture-templates
      '(
   ("t" "Tasks")
   ;; TODO     (t) Todo template
   ("tt" "TODO      (t) Todo" entry (file +org-capture-todo-file)
    "* TODO %?
  :PROPERTIES:
  :Via:
  :Note:
  :END:
  :LOGBOOK:
  - State \"TODO\"       from \"\"           %U
  :END:" :empty-lines 1)

  ("b" "Bookmark" entry (file "~/Cloud/Org/bookmarks.org")
       "* %(org-cliplink-capture) :%?:\n")
  ("p" "process email" entry (file +org-capture-todo-file)
             "* TODO %? %:fromname: %a"))))


