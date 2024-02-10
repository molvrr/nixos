(setq package-enable-at-startup nil)

(setq gc-cons-threshold
      (* 100 1024 1024))

(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold
         (expt 2 23))))


