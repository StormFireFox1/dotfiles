function select-repo --description="Fuzzy searches for Git repos under ~/Repos and returns the selected path"
    set REPO_ROOT_DIR "$HOME/Repos"
    set SELECTED_REPO (fd --exact-depth 3 -t d . "$REPO_ROOT_DIR/" | string replace "$REPO_ROOT_DIR/" "" | string trim -r -c "/" | fzf)
    echo "$REPO_ROOT_DIR/$SELECTED_REPO"
end
