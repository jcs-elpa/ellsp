(package "ellsp"
         "0.2.0"
         "Elisp Language Server")

(website-url "https://github.com/elisp-lsp/ellsp")
(keywords "convenience" "lsp")

(package-file "ellsp.el")

(files "ellsp-*.el" "bin")

(script "test" "echo \"Error: no test specified\" && exit 1")

(source 'gnu)
(source 'melpa)
(source 'jcs-elpa)

(depends-on "emacs" "27.1")
(depends-on "lsp-mode")
(depends-on "company")
(depends-on "log4e")
(depends-on "dash")
(depends-on "s")
(depends-on "msgu")

(development
 (depends-on "ic"))

(setq network-security-level 'low)  ; see https://github.com/jcs090218/setup-emacs-windows/issues/156#issuecomment-932956432
