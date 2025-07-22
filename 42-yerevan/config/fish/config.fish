if status is-interactive && status is-login
    set --export fish_greeting ''
    set --export PATH ~/goinfre/nixsa/bin $PATH

    # For some reason (which fish) doesn't work with tmux.
    set --export SHELL /goinfre/ghelman/nixsa/state/profile/bin/fish

    which hx >/dev/null 2>&1 && set --export EDITOR hx
    if test (pwd) = ~
        cd my
    end
end
