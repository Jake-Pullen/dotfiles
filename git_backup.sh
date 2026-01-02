#!/bin/bash

# Git Backup Script for All Projects in /mnt/bulk/source
# Usage: ./git_backup.sh [project_name] (optional - backup specific project)

# Configuration
BACKUP_DIR="/mnt/nas/Jake/git_backups"
TEMP_DIR="/tmp/git_backup_$(date +%Y%m%d)"
REPO_SOURCE="/mnt/bulk/source"

# Find all git projects in /mnt/bulk/source
find_git_projects() {
    local projects=()
    
    # Find directories that contain .git folder
    while IFS= read -r -d '' project; do
        if [ -d "$project/.git" ]; then
            projects+=("$project")
        fi
    done < <(find "$REPO_SOURCE" -type d -print0)
    
    echo "${projects[@]}"
}

# Function to backup a single project
backup_project() {
    local project_path="$1"
    local project_name=$(basename "$project_path")
    local temp_dir="${TEMP_DIR}_${project_name}"
    
    echo "Backing up: $project_path"

    # Check if HEAD exists (repository has commits)
    if ! git -C "$project_path" rev-parse HEAD > /dev/null 2>&1; then
        echo "Warning: $project_path has no commits, skipping..."
        return 0
    fi

    # Create temporary directory
    mkdir -p "$temp_dir"
    
    # Archive the git project (excluding ignored files)
    git -C "$project_path" archive --format=tar --output="$temp_dir/backup.tar" HEAD
    
    # Sync files to NAS
    rsync -az "$temp_dir/" "${BACKUP_DIR}/${timestamp}/${project_name}/"
    
    # Clean up temporary files
    rm -rf "$temp_dir"
}

# Main backup function
main_backup() {
    local timestamp=$(date +%Y%m%d)
    
    echo "Starting git backup for all projects..."
    
    # Create dated backup directory on NAS
    mkdir -p "${BACKUP_DIR}/${timestamp}"
    
    # Get all git projects
    local projects=($(find_git_projects))
    
    if [ $# -eq 0 ]; then
        # Backup all projects
        if [ ${#projects[@]} -eq 0 ]; then
            echo "No git projects found in $REPO_SOURCE"
            exit 1
        fi
        
        for project in "${projects[@]}"; do
            backup_project "$project"
        done
    else
        # Backup specific project
        local target_project="$1"
        if [ -d "$target_project" ] && [ -d "$target_project/.git" ]; then
            backup_project "$target_project"
        else
            echo "Project not found or not a git repository: $target_project"
            exit 1
        fi
    fi
    
    # Keep only 7 most recent backups
    cd "${BACKUP_DIR}" && ls -1d * | head -n -7 | xargs rm -rf
    
    echo "Backup completed successfully!"
}

# Run main backup function
main_backup "$@"

# Clean up temporary directory if it exists
if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi
