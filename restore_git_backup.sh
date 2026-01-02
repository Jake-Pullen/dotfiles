#!/bin/bash

# Git Restore Script for Latest Backup
# Usage: ./restore_git_backup.sh [project_name] (optional - restore specific project)

# Configuration
BACKUP_DIR="/mnt/nas/Jake/git_backups"
REPO_SOURCE="/mnt/bulk/temp"

# Function to restore a single project from latest backup
restore_project() {
    local project_name="$1"
    local latest_backup=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "*" | sort -r | head -n 1)
    
    if [ -z "$latest_backup" ]; then
        echo "Error: No backups found in $BACKUP_DIR"
        exit 1
    fi
    
    local project_backup_path="${latest_backup}/${project_name}"
    
    if [ ! -d "$project_backup_path" ]; then
        echo "Error: Backup for project '$project_name' not found in latest backup"
        exit 1
    fi
    
    echo "Restoring $project_name from latest backup..."
    
    # Create the project directory if it doesn't exist
    mkdir -p "$REPO_SOURCE/$project_name"
    
    # Extract the backup to the source directory
    tar -xf "${project_backup_path}/backup.tar" -C "$REPO_SOURCE/$project_name"
    
    echo "Successfully restored $project_name from backup"
}

# Main restore function
main_restore() {
    local latest_backup=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "*" | sort -r | head -n 1)
    
    if [ -z "$latest_backup" ]; then
        echo "Error: No backups found in $BACKUP_DIR"
        exit 1
    fi
    
    echo "Latest backup directory: $latest_backup"
    
    if [ $# -eq 0 ]; then
        # Restore all projects from latest backup
        echo "Restoring all projects from latest backup..."
        
        # Get list of project directories in the backup
        local projects=($(ls "$latest_backup"))
        
        for project in "${projects[@]}"; do
            restore_project "$project"
        done
    else
        # Restore specific project
        local target_project="$1"
        restore_project "$target_project"
    fi
    
    echo "Restore completed successfully!"
}

# Run main restore function
main_restore "$@"