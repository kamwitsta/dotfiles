(add-to-list 'load-path "~/.emacs.d/plugins")


; wrap lines
(define-key global-map [f5] 'toggle-truncate-lines)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)


; nice moving through windows
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<down>") 'windmove-down)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<left>") 'windmove-left)


; the tsv mode
(require 'tsv-mode)
(autoload 'tsv-mode "tsv-mode" "A mode to edit table like file" t)
(autoload 'tsv-normal-mode "tsv-mode" "A minor mode to edit table like file" t)