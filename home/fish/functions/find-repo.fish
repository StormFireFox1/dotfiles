function find-repo --description="Cd's to the selected repo."
    set REPO (select-repo)
    cd "$REPO"
end
