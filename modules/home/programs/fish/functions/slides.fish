function slides --description="Opens a Presenterm from your Obsidian Vault."
    set SLIDES_PATH "$HOME/Obsidian/Presenterms/"
    set PRESENTATION (fd ".md" "$SLIDES_PATH" -x echo "{/.}" | fzf)
    if command -q kitty
        kitty @ set-tab-title "$PRESENTATION"
    end
    pushd "$HOME/Obsidian"
    presenterm "$SLIDES_PATH/$PRESENTATION.md"
    popd
end
