((c++-mode
  (eval . (use-package lsp-mode
            :config
            (progn
              (lsp-register-client
               (make-lsp-client
                :new-connection (lsp-stdio-connection '("make" "lsp"))
                :major-modes '(c-mode c++-mode)
                :server-id 'clangd-docker
                :priority 1)))))))
