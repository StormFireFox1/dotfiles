function find-repo-and-open --description="Opens a NeoVim window on the selected repo"
    set REPO (select-repo)
    set REPO_NAME (string split -f 2 -m 1 -r "/" "$REPO")
    if command -q kitty
        kitty @ set-tab-title "$REPO_NAME"
    end
    cd "$REPO" && nvim
end
