;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-gruvbox)

(setq user-full-name "Ray Andrew"
      user-mail-address "rs@rs.ht"
      org-directory "~/Org/"
      rs/default-bibliography `(,(expand-file-name "references.bib" org-directory))
      rs/org-agenda-directory (expand-file-name "gtd/" org-directory))

;; (setq
;;       org-archive-location "archive.org::* Archived Tasks")

(setq rs/my-font "UbuntuMono Nerd Font Mono"
      doom-font (font-spec :family rs/my-font :size 20)
      doom-variable-pitch-font (font-spec :family rs/my-font :size 20)
      doom-big-font (font-spec :family rs/my-font :size 20))

;;; to disable frame in emacsclient
;; (after! persp-mode
;;   (setq persp-emacsclient-init-frame-behaviour-override "main"))

(map! :leader
      (:prefix ("=" . "open file")
       :desc "Edit agenda file"      "a" #'(lambda () (interactive) (find-file "~/Org/gtd/inbox.org"))
       :desc "Edit bookmark file"    "b" #'(lambda () (interactive) (find-file "~/Org/bookmark.org"))
       :desc "Edit doom config.el"   "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.el"))
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

(after! org
    (require 'org-habit)
    (require 'find-lisp)
    (setq org-agenda-files (find-lisp-find-files rs/org-agenda-directory "\.org$")
      org-adapt-indentation nil
      org-habit-show-habits-only-for-today t))

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-leading-bullet ?\s
        org-superstar-headline-bullets-list '("*" "*" "*" "*" "*" "*" "*")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        org-link-abbrev-alist
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords
          '(;; Sequence for TASKS
            ;; TODO means it's an item that needs addressing
            ;; INPROGRESS means it's currently being worked on 
            ;; WAITING means it's dependent on something else happening
            ;; DELEGATED means someone else is doing it and I need to follow up with them
            ;; ASSIGNED means someone else has full, autonomous responsibility for it
            ;; CANCELLED means it's no longer necessary to finish
            ;; DONE means it's complete
            (sequence "TODO(t@/!)" "INPROGRESS(i@/!)" "WAITING(w@/!)" "DELEGATED(e@/!)" "|" "ASSIGNED(.@/!)" "CANCELLED(x@/!)" "DONE(d@/!)" )
            ;; Sequence for EVENTS
            ;; VISIT means that there is something you would physically like to do, no dates associated
            ;; DIDNOTGO means the event was cancelled or I didn't go
            ;; MEETING means a real time meeting, i.e. at work, or on the phone for something official
            ;; VISITED means the event took place and is no longer scheduled
            (sequence "VISIT(v@/!)" "|" "DIDNOTGO(z@/!)" "MEETING(m@/!)" "VISITED(y@/!)")
            (sequence )
            ))) ; Task has been cancelled

(after! org-fancy-priorities
  (setq
     org-fancy-priorities-list '("🟥" "🟧" "🟨")
     org-priority-faces
     '((?A :foreground "#ff6c6b" :weight bold)
       (?B :foreground "#98be65" :weight bold)
       (?C :foreground "#c678dd" :weight bold))
     org-agenda-block-separator 8411))

(use-package! org-agenda
  :init
  (map! "<f1>" #'rs/switch-to-agenda)
  (setq org-agenda-block-separator nil
        org-agenda-start-with-log-mode t
        org-agenda-tags-todo-honor-ignore-options t)
 (defun rs/switch-to-agenda ()
    (interactive)
    (org-agenda nil " "))
  :config
  (defun rs/is-project-p ()
    "Any task with a todo keyword subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
            (subtree-end (save-excursion (org-end-of-subtree t)))
            (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-todo-keywords-1)
              (setq has-subtask t))))
        (and is-a-task has-subtask))))

  (defun rs/skip-projects ()
    "Skip trees that are projects."
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (cond
         ((org-is-habit-p)
          next-headline)
         (t
          nil)))))

  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
  (setq org-agenda-custom-commands
        '(("p" "Priority"
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
            (alltodo "")))
          
          (" " "Agenda"
           ((agenda ""
                    ((org-agenda-span 'week)
                     (org-deadline-warning-days 365)))
            (todo "INPROGRESS"
                  ((org-agenda-overriding-header "In Progress")
                   (org-agenda-files `(,(expand-file-name "gtd/projects.org" org-directory)))))
            (alltodo ""
                     ((org-agenda-overriding-header "Inbox")
                      (org-agenda-files `(,(expand-file-name "gtd/inbox.org" org-directory)))))
            (todo "TODO"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files `(,(expand-file-name "gtd/projects.org" org-directory)))
                   (org-agenda-skip-function #'rs/skip-projects)))))

          )))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun rs/insert-auto-tangle-tag ()
  "Insert auto-tangle tag in a literate config."
  (interactive)
  (evil-org-open-below 1)
  (insert "#+auto_tangle: t ")
  (evil-force-normal-state))

(map! :leader
      :desc "Insert auto_tangle tag" "i a" #'rs/insert-auto-tangle-tag)

(setq org-journal-dir "~/Org/journal/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

(defun rs/org-colors-doom-one ()
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

(defun rs/org-colors-gruvbox-dark ()
  "Enable Gruvbox Dark colors for Org headers."
  (interactive)
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(after! org
  (rs/org-colors-gruvbox-dark))

(after! org
  (setq org-capture-templates
      `(("i" "Todo [inbox]" entry (file "gtd/inbox.org")
         "* TODO %i%?")
        ("t" "Todo [inbox]" entry (file "gtd/inbox.org")
         "* TODO %i%?")
        ("T" "Tickler" entry
         (file+headline "gtd/tickler.org" "Tickler")
         "* %i%? \n %U")
        ("s" "Slipbox" entry  (file "brain/inbox.org")
         "* %?\n"))))

(after! org
        (setq org-refile-targets '(("~/Org/gtd/projects.org" :maxlevel . 3)
                                   ("~/Org/gtd/someday.org" :level . 1)
                                   ("~/Org/gtd/tickler.org" :maxlevel . 2))))

(defun rs/org-capture-inbox ()
  (interactive)
  (org-capture nil "i"))

(defun rs/org-capture-slipbox ()
  (interactive)
  (org-capture nil "s"))

(defun rs/org-agenda ()
  (interactive)
  (org-agenda nil " "))

(bind-key "C-c <tab>" #'rs/org-capture-inbox)
(bind-key "C-c SPC" #'rs/org-agenda)


(defun rs/org-rg-search ()
  "Search org directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep (concat "rg "
                                 "--null --multiline --ignore-case --type org --line-buffered --color=always --max-columns=1000 "
                                 "--no-heading --line-number "
                                 "--hidden -g !.git -g !.svn -g !.hg -g !.osync_workdir -g !.orgids"
                                 ". -e ARG OPTS")))
    (consult-ripgrep org-directory)))

(map! :leader
      :desc "Search org notes"
      "n s" #'rs/org-rg-search)

(map! "S-M-RET" #'vertico-exit-input)

;; https://org-roam.discourse.group/t/using-consult-ripgrep-with-org-roam-for-searching-notes/1226/19
(defun rs/org-roam-rg-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep (concat "rg "
                                 "--null --multiline --ignore-case --type org --line-buffered --color=always --max-columns=1000 "
                                 "--no-heading --line-number "
                                 "--hidden -g !.git -g !.svn -g !.hg -g !.osync_workdir -g !.orgids"
                                 ". -e ARG OPTS")))
    (consult-ripgrep org-roam-directory)))

(use-package! org-roam
  :init
  (map! :leader
        :prefix "n r"
        :desc "Toggle roam buffer" "r" #'org-roam-buffer-toggle
        :desc "Completion at point" "c" #'completion-at-point
        :desc "Insert node" "i" #'org-roam-node-insert
        :desc "Find node" "f" #'org-roam-node-find
        :desc "Find references" "r" #'org-roam-ref-find
        :desc "Show graph" "g" #'org-roam-show-graph
        :desc "Capture slipbox" "<tab>" #'rs/org-capture-slipbox
        :desc "Capture to node" "n" #'org-roam-capture
        :desc "Search" "s" #'rs/org-roam-rg-search)
  (setq org-roam-directory (file-truename "~/Org/brain/")
        ; org-roam-database-connector 'sqlite-builtin
        org-roam-db-gc-threshold most-positive-fixnum
        org-id-link-to-org-use-id t
        org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode +1)
  (set-popup-rules!
    `((,(regexp-quote org-roam-buffer) ; persistent org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 1)
      ("^\\*org-roam: " ; node dedicated org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 2)))
  (add-hook 'org-roam-mode-hook #'turn-on-visual-line-mode)
  (setq org-roam-capture-templates
        '(("m" "main" plain
           "%?"
           :if-new (file+head "main/${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new
           (file+head "refs/${slug}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("p" "private" plain "%?"
           :if-new
           (file+head "private/${title}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("a" "article" plain "%?"
           :if-new
           (file+head "articles/${slug}.org" "#+title: ${title}\n#+filetags: :article:\n")
           :immediate-finish t
           :unnarrowed t)
          ("n" "literature note" plain
           "%?"
           :target
           (file+head
            "refs/${citar-citekey}.org"
            "#+title: ${title}\n#+authors: ${citar-author}\n#+created: %U\n#+last_modified: %U\n\n")
           :unnarrowed t)))
  (defun rs/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'rs/tag-new-node-as-draft)
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag))))

(after! bibtex-completion
  (setq! bibtex-completion-notes-path org-roam-directory
         bibtex-completion-bibliography rs/default-bibliography
         org-cite-global-bibliography rs/default-bibliography
         bibtex-completion-pdf-field "file"))

(after! bibtex-completion
  (after! org-roam
    (setq! bibtex-completion-notes-path org-roam-directory)))

(after! citar
  (map! :map org-mode-map
        :desc "Insert citation" "C-c b" #'citar-insert-citation)
  (setq citar-bibliography rs/default-bibliography
        citar-at-point-function 'embark-act
        citar-symbol-separator "  "
        citar-format-reference-function 'citar-citeproc-format-reference
        org-cite-csl-styles-dir "~/Zotero/styles"
        citar-citeproc-csl-styles-dir org-cite-csl-styles-dir
        citar-citeproc-csl-locales-dir "~/Zotero/locales"
        citar-citeproc-csl-style (file-name-concat org-cite-csl-styles-dir "apa.csl")))

(use-package! citar-org-roam
  :init
  (setq citar-org-roam-subdir "refs"
        citar-org-roam-capture-template-key "n")
  :after (citar org-roam)
  :config 
  (setq citar-org-roam-note-title-template "${title}")
  (citar-org-roam-mode))

(use-package! tree-sitter
  :hook
  (prog-mode . global-tree-sitter-mode))

(when init-file-debug
  (require 'benchmark-init)
  (add-hook 'doom-first-input-hook #'benchmark-init/deactivate))
