(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(custom-safe-themes
   (quote
    ("f34b107e8c8443fe22f189816c134a2cc3b1452c8874d2a4b2e7bb5fe681a10b" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'TeX-mode-hook
	  (lambda ()
	    (add-to-list 'TeX-view-program-list
			 '("Zathura"
			   ("zathura "
			    (mode-io-correlate " --synctex-forward %n:0:%b -x \"emacsclient +%{line} %{input}\" ")
			    " %o")
			   "zathura"))
	    (add-to-list 'TeX-view-program-selection
			 '(output-pdf "Zathura"))
	    (TeX-source-correlate-mode)
	    ))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'zenburn t)

(tool-bar-mode -1)
