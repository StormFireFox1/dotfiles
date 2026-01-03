set REPO (select-repo)
set REPO_NAME (string split -f 2 -m 1 -r "/" "$REPO")
pushd "$REPO"
code .
popd
