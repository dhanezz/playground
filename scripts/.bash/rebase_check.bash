#!/bin/bash
# Script to check if the branch needs rebasing
#
# Author: E. Dhane Canupin
# Created: 23/02/2025
#
# Note: Specificly used Bash for this script, since it has more features than sh especially better git integrations.

set -e # Exit immediately if a command exits with a non-zero status

### VARIABLES ###

# Fetch all branches (local and remote)
all_branches=$(git branch -r | grep -v '\->' | sed 's/origin\///')

target_branch=main; # default target branch
check_branch=$(git rev-parse --abbrev-ref HEAD) # default check branch

### FUNCTIONS FOR GIT LOGIC ###

# Function to merge the branch
merge_branch() {
    echo -e "\n🔄️ Merging branch..."

    echo -e "\n🔄️ Switching to branch $target_branch..."
    git checkout "$target_branch"
    git pull origin "$target_branch"

    echo -e "\n🔄️ Merging branch $check_branch into $target_branch..."

    read -p "Do you want to merge with --no-ff? (y/n): " merge_choice
    if [ "$merge_choice" = "y" ]; then
        git merge --no-ff "$check_branch"
    else
        git merge "$check_branch"
    fi

    echo -e "\n✅ Branch merged successfully!"
}

# Function to fetch the target branch
fetch_target_branch() {
    echo "🔄️ Fetching latest changes from $target_branch..."
    git fetch origin "$target_branch" 
}

# Function to stack the branch
squash_branch() {
    echo -e "\n🔄️ Squashing branch..."
    commit_count=$(git rev-list --count "$target_branch".."$check_branch")

    git rebase -i "$check_branch"~$commit_count
}

# Function to rebase the branch
rebase_branch() {
    current_branch=$(git symbolic-ref --short HEAD)
    echo -e "\n📌 Currently on branch: $current_branch"
    
    echo -e "\n🔄️ Rebasing branch..."
    git fetch origin # Make sure the latest changes are fetched
    git rebase "origin/$target_branch"
    echo -e "\n✅ Branch rebased successfully!"

    read -p "Do you want to merge the branch? (y/n): " merge_choice
    if [ "$merge_choice" = "y" ]; then
        merge_branch
    fi
}

# Functions to  push branch
push_branch() {
   echo "Pushing changes..."
   git push origin "$check_branch"
}

# Functions to commit branch
commit_branch() {
   read -p "Enter commit message: " commit_message
   git add .  # Add all changes
   git commit -m "$commit_message"
   echo -e "\n🔄️ Commit changes..."
}

# Function to check if there are uncommitted changes (modified or staged)
check_uncommited_changes() {
    if [ -n "$(git status --porcelain)" ]; then
        # Get the number of uncommitted changes
        uncommitted_list=$(git status --short )

        echo -e "\n⚠️ There are uncommitted changes:\n\n$uncommitted_list\n\nConsider committing your changes.\n"
        read -p "Do you want to commit your changes? (y/n): " commit_choice

        if [ "$commit_choice" = "y" ]; then
            commit_branch
        else
            echo "Please commit your changes before checking for rebasing."
            exit 1
        fi
    fi
}

# Function to check if they are unpushed commits
check_unpushed_commits() {
    echo "🔄️ Fetching latest changes from remote..."
    git fetch

    # Check if there are commits in the local branch that haven't been pushed to the remote
    unpushed_commits=$(git rev-list --count "origin/$check_branch".."$check_branch" )
    commit_list=$(git log --oneline "origin/$check_branch".."$check_branch")

    if [ "$unpushed_commits" -gt 0 ]; then
        echo -e "⚠️ There are $unpushed_commits unpushed commit(s) on this branch:\n\n$commit_list\n\nConsider pushing your changes!"

        read -p "Do you want to push your changes? (y/n): " push_choice

        if [ "$push_choice" = "y" ]; then
            push_branch
        else
            echo "Please push your changes before checking for rebasing."
            exit 1
        fi
    fi
}

# Function to check if the branch needs rebasing
main() {
    read -p "Do you want to check current branch to default? (y/n): " current_to_default_choice
    if [ "$current_to_default_choice" = "n" ]; then
        get_check_target_branch
        get_check_branch

        echo -e "\n🔍 Checking branch \033[1;34m$check_branch\033[0m against \033[1;34m$target_branch\033[0m...\n"
    fi

    # Check if there are uncommitted changes (modified or staged)
    check_uncommited_changes
    wait
    check_unpushed_commits 
    wait
    fetch_target_branch "$target_branch"

    check_rebase_needed
}

check_rebase_needed() {
    behind_count=$(git rev-list --count "$check_branch".."origin/$target_branch")

    if [[ "$behind_count" -gt 0 ]]; then
        echo "⚠️ Your branch ("$check_branch") is $behind_count commit(s) behind $target_branch. Consider rebasing!"
        return 1
    else
        echo "✅ Your branch ("$check_branch") is up to date with $target_branch."
        
        read -p "Do you want to squash the commits? (y/n): " squash_choice
        if [ "$squash_choice" = "y" ]; then
            squash_branch
        fi

        read -p "Do you want to rebase your branch? (y/n): " rebase_choice
        if [ "$rebase_choice" = "y" ]; then
            rebase_branch
        else
            echo "No rebase needed."
            exit 0
        fi
    fi
}

### FUNCTIONS FOR BRANCH SELECTION ###

get_check_target_branch() {
    echo -e "\n🎯 Please select the \033[1;31mTARGET\033[0m branch to check against: "
    get_branch_select_menu "target"
}

get_check_branch() {
    echo -e "\n✅ Please select the branch to be \033[1;31mCHECKED\033[0m: "
    get_branch_select_menu "check"

    if $(git symbolic-ref --short HEAD) != "$check_branch"; then
        echo -e "\n❌ You are not on the check branch. Switching to $check_branch..."
        echo -e "\n🔄️ Switching to branch $check_branch..."
        git checkout "$check_branch"
        git pull origin "$check_branch"
    fi
}

get_branch_select_menu() {
    local branch_type="$1"

    # Fetch all branches (local and remote)
    if [ -z "$all_branches" ]; then
        echo "No branches found."
        exit 1
    fi

    if [ "$branch_type" = "check" ]; then
        # Filter out the target branch from the list of branches
        # tr ' ' '\n' converts the space-separated branches into newline-separated branches
        filtered_branches=$(echo "$all_branches" | tr ' ' '\n' | grep -v "^$target_branch$")
    else
        filtered_branches="$all_branches"
    fi

    # Use a conditional inside the PS3 prompt    
    PS3=$'\n'"Choose the $( [ "$branch_type" = "target" ] && echo "target" || echo "check") branch (press Enter to select):"$'\n'
    
    # Display the branches in a select menu
    select branch in $filtered_branches; do
        if [ -n "$branch" ]; then
            if [ "$branch_type" == "target" ]; then
                target_branch=$(echo "$branch" | xargs) # Remove leading/trailing whitespace
            elif [ "$branch_type" == "check" ]; then
                check_branch=$(echo "$branch" | xargs) # Remove leading/trailing whitespace
            fi
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

###### MAIN SCRIPT EXECUTION START #######

main

###### MAIN SCRIPT EXECUTION END #######