#!/bin/bash
read -p "Enter the path to directory you need to backup: " source_dir
read -p "Enter the path to directory where backup will be stored: " backup_dir
mkdir -p "$backup_dir"
backup_name="$(basename "$source_dir")_backup_$(date +'%Y%m%d%H%M%S').tar.gz"
tar -czvf "$backup_dir/$backup_name" "$source_dir" && echo "Backup created: $backup_dir/$backup_name"
