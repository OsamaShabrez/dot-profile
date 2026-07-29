#!/usr/bin/env zsh

# Git Branch Cleanup Tool (gitr)
# A Zsh utility function to efficiently audit and purge local Git branches.
# Features automated safety guards for production/active branches, 
# case-insensitive string filtering, dry-run safety checks, and an 
# interactive bulk-deletion UI powered by 'fzf' with live commit previews.

gitr() {
    emulate -L zsh

    autoload -Uz colors
    colors

    local GREEN=$fg[green]
    local RED=$fg[red]
    local YELLOW=$fg[yellow]
    local BLUE=$fg[blue]
    local CYAN=$fg[cyan]
    local RESET=$reset_color

    local action="${1:-list}"
    (( $# > 0 )) && shift

    case "$action" in
        list|delete|interactive) ;;
        help|-h|--help)
            cat <<EOF
Git Branch Cleanup

Usage:
  gitr list [FILTER...]
  gitr delete [--force|-f] [FILTER...]
  gitr interactive [--force|-f] [FILTER...]

FILTERS are case-insensitive substrings.

Examples:
  gitr list
  gitr list client feature
  gitr delete
  gitr delete --force
  gitr interactive
  gitr interactive -f release

Protected automatically:
  • current branch
  • main
  • master
  • develop
EOF
            return
            ;;
        *)
            echo "${RED}Unknown command '$action'${RESET}"
            return 1
            ;;
    esac

    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
        echo "${RED}Not inside a git repository.${RESET}"
        return 1
    }

    local force=false
    local -a filters=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--force)
                force=true
                ;;
            *)
                filters+=("$1")
                ;;
        esac
        shift
    done

    local current
    current=$(git branch --show-current)

    local -a branches candidates
    branches=("${(@f)$(git for-each-ref \
        --sort=refname \
        --format='%(refname:short)' \
        refs/heads)}")

    local branch keep filter

    for branch in "${branches[@]}"; do
        keep=false

        case "$branch" in
            "$current"|main|master|develop)
                keep=true
                ;;
        esac

        if ! $keep; then
            local lower="${branch:l}"
            for filter in "${filters[@]}"; do
                [[ "$lower" == *"${filter:l}"* ]] && keep=true && break
            done
        fi

        $keep || candidates+=("$branch")
    done

    if (( ${#candidates} == 0 )); then
        echo "${GREEN}✓ Nothing to delete.${RESET}"
        return
    fi

    case "$action" in

        list)
            echo
            echo "${CYAN}Branches that would be deleted${RESET}"
            echo "────────────────────────────────────────"

            printf "%s\n" "${candidates[@]}"

            echo
            echo "${BLUE}Dry run only.${RESET}"
            ;;

        delete)

            if $force; then
                echo
                echo "${RED}WARNING:${RESET} Force delete removes branches regardless of merge status."
                printf "Delete %d branches? [y/N] " "${#candidates}"
                read -r reply
                [[ ! "$reply" =~ ^[Yy]$ ]] && return
            fi

            echo
            echo "${RED}Deleting ${#candidates} branches...${RESET}"
            echo

            local deleted=0
            local failed=0

            for branch in "${candidates[@]}"; do
                if $force; then
                    git branch -D "$branch"
                else
                    git branch -d "$branch"
                fi

                if [[ $? -eq 0 ]]; then
                    ((deleted++))
                else
                    ((failed++))
                fi
            done

            echo
            echo "${GREEN}Deleted : ${deleted}${RESET}"
            echo "${YELLOW}Skipped : ${failed}${RESET}"
            ;;

        interactive)

            command -v fzf >/dev/null || {
                echo "${RED}fzf is not installed.${RESET}"
                return 1
            }

            local selected

            selected=$(
                printf "%s\n" "${candidates[@]}" |
                fzf \
                    --multi \
                    --reverse \
                    --border \
                    --height=85% \
                    --prompt="Delete branches > " \
                    --header="TAB select • ENTER delete • ESC cancel" \
                    --preview-window=right:65% \
                    --preview '
                        git log \
                            --graph \
                            --decorate \
                            --color=always \
                            --date=relative \
                            --pretty=format:"%C(auto)%h %Cgreen(%cr)%Creset %s %Cblue<%an>" \
                            -30 {}
                    '
            )

            [[ -z "$selected" ]] && return

            if $force; then
                echo
                echo "${RED}WARNING:${RESET} Force delete removes branches regardless of merge status."
                printf "Delete selected branches? [y/N] "
                read -r reply
                [[ ! "$reply" =~ ^[Yy]$ ]] && return
            fi

            echo
            echo "${RED}Deleting selected branches...${RESET}"
            echo

            local deleted=0
            local failed=0

            while IFS= read -r branch; do
                [[ -z "$branch" ]] && continue

                if $force; then
                    git branch -D "$branch"
                else
                    git branch -d "$branch"
                fi

                if [[ $? -eq 0 ]]; then
                    ((deleted++))
                else
                    ((failed++))
                fi
            done <<< "$selected"

            echo
            echo "${GREEN}Deleted : ${deleted}${RESET}"
            echo "${YELLOW}Skipped : ${failed}${RESET}"
            ;;
    esac
}