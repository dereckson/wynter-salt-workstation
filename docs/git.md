# Git helpers

For user `dereckson`, Salt copies `~/bin/git-*` scripts. Git treats each `git-<name>` on `PATH` as a subcommand, so you run `git land`, not `./git-land`.

!!! note "`~/bin` on PATH"
    The provisioned `.zshrc` does **not** add `$HOME/bin` to `PATH`. Many Fedora/GNOME setups still include it via systemd user environment or `/etc/profile`. If `git land` is “not a git command”, add `~/bin` yourself or call the scripts by path.

All helpers refuse to run (or behave differently) on the **default branch**. Default branch detection is `git get-default-branch`.

## `git get-default-branch`

Prints the default branch name. Heuristics, in order:

1. Repo directory named `puppet` → `production`
2. Repo directory named `pixelfed` → `dev`
3. Else `.git/arc/default-relative-commit` last path component (Arcanist)
4. Else local `main` if that ref exists
5. Else `master`

No arguments. Used by the other helpers.

## `git newbug <branch>`

Update default branch from remotes, then create a feature branch:

```bash
git switch "$DEFAULT_BRANCH"
git fetch --all
git pull --ff-only
git switch -c "$WORKING_BRANCH"
```

Usage: `git newbug <name of the branch to create>`.

## `git resend`

Amend the current commit (after `git add -p`), keep the message, force-push the feature branch so another machine can `git receive`.

Remote choice:

1. If remote `datacube` exists → `git push datacube <branch> -f`
2. Else if any remote URL matches `devcentral.nasqueron.org` → refuse (use `arc diff` or add datacube)
3. Else `git push origin <branch> -f`

Aborts on the default branch.

## `git receive`

On the **receiving** clone (dev/deploy box): `git fetch --all` then `git reset --hard <remote>/<current-branch>`. Remote is `datacube` if it exists, else `origin`. **Destroys local uncommitted work** on that branch. Aborts on the default branch.

## `git land`

Land the current feature branch onto the default branch, push, delete local and remote feature branches.

1. `git fetch --all`, switch to default branch, abort if the working tree has uncommitted tracked changes
2. `git pull --ff-only`
3. If the feature branch is a fast-forward of default: `git merge --ff-only`
4. Else one commit: `cherry-pick`; multiple commits: prompt `Land all N commits? [y/N]` then cherry-pick the range
5. `git push` (default remote of the default branch)
6. Delete local branch; `git delete-remote-branch` on `datacube` or `origin`

Inspired by `arc land` / Gerrit-style linear history.

## `git bye`

After the work is merged **elsewhere**: switch to default branch, `pull --ff-only` if the tree is clean, `git branch -D` the old feature branch. Does not delete remotes. Aborts if already on default, or if uncommitted tracked files exist (switches back).

## `git rename-branch [<old>] <new> [<remote>]`

Rename local branch and its remote counterpart.

| Args | Meaning |
| --- | --- |
| one | rename **current** branch to `<new>` |
| two | `<old>` → `<new>` |
| three | also set `<remote>` |

Default remote: `datacube` if present, else `origin`. Steps: `git branch -m`, fetch, delete old remote branch if it exists, unset upstream, `git push -u` the new name.

Refuses detached HEAD, identical names, missing old branch, existing new branch, missing remote.

## `git delete-remote-branch [remote] [branch]`

`git push <remote> --delete <branch>`. Defaults: remote `origin`, branch `master`.

```bash
git delete-remote-branch                  # origin/master
git delete-remote-branch datacube topic   # datacube/topic
```

## Distro git tools

Packages (not wrappers): `git-lfs`, `git-review`, `git-subtree`, `colordiff`. FreeBSD base userland also installs `hub` and `arcanist`.
