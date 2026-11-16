set SLIDES_PATH "$HOME/Obsidian/Presenterms/"
set PRESENTATION (fd ".md" "$SLIDES_PATH" -x echo "{/.}" | fzf)
if test "$TERM" = xterm-ghostty
    printf '\e]2;%s\a' "$PRESENTATION"
end
pushd "$HOME/Obsidian"
presenterm "$SLIDES_PATH/$PRESENTATION.md"
popd
