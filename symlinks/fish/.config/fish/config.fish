# Checking for login status here allows for faster start times when using tmux.
# See:
# - https://posts.mksanders.org/instant-pyenv-rbenv-startup-times-with-tmux
# - https://posts.mksanders.org/faster-fish-startup-times

if test -f (brew --prefix asdf)/asdf.fish
  source (brew --prefix asdf)/asdf.fish
end
	

    set --export HOMEBREW_AUTO_UPDATE_SECS 86400
    set --export LANG en_US.UTF-8
    set --export LANGUAGE en_US.UTF-8
    set --export LC_ALL en_US.UTF-8
    set --export MANPAGER "sh -c 'col -bx | bat -l man -p'"
    # Fix for M1 and HDF5 in Python
    set --export HDF5_DIR /opt/homebrew/opt/hdf5
    
    set --export SHELLCHECK_OPTS "--external-sources"

if status is-login
    	fish_add_path -P $HOME/.bin $HOME/.dotfiles/.bin $HOME/.cargo/bin $HOME/.yarn/bin /usr/local/bin "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" /opt/homebrew/opt/openssl@3/bin


    if status is-interactive

        if test -f $HOME/.aliases
            source $HOME/.aliases

            # Export aliases for lazy-loading in child shells.
            for alias in (rg -o "^alias \b\w+\b" $HOME/.aliases | cut -c 7-)
                funcsave $alias
            end
        end

        if test -f $HOME/.functions.fish
            source $HOME/.functions.fish

            # Export functions for lazy-loading in child shells.
            for func in (rg -o "function \b\w+\b" $HOME/.functions.fish | cut -c 10-)
                funcsave $func
            end
        end

    end
end

if status is-interactive
    # Disable greeting.
    set --export fish_greeting
    function fish_greeting; end
end
